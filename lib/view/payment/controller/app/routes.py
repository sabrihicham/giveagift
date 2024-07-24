from flask import current_app as app, jsonify, request
from .models import db, User, Document, Inbox

from flask_jwt_extended import (
    JWTManager, create_access_token, jwt_required, get_jwt_identity
)

import bcrypt

from functools import wraps

from ast import literal_eval as make_tuple

from crypto import generate_key_pair, eddsa_sign, eddsa_verify

import time, os

class Permission:
    GENERAL = 1
    ADMIN = 0
    
def permission_required(permission):
    """Restrict a view to users with the given permission."""

    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            user = User.query.filter_by(username=get_jwt_identity()).first()
            if not user.can(permission):
                return jsonify({"msg": "Permission denied"}), 403
            return f(*args, **kwargs)

        return decorated_function

    return decorator


def admin_required(f):
    return permission_required(Permission.ADMIN)(f)

def getUserByUsername(username: str) -> User:
    return User.query.filter_by(username=username).first()

def getUserById(id: int) -> User:
    return User.query.get(id)

def getModelById(model, id: int):
    return model.query.get(id)

def hash_password(password):
    # Generate a salt
    salt = bcrypt.gensalt()
    # Hash the password with the salt
    hashed_password = bcrypt.hashpw(password.encode('utf-8'), salt)
    return hashed_password

def validate_password(hashed_password, password):
    # Use bcrypt to check if the password matches the hash
    return bcrypt.checkpw(password.encode('utf-8'), hashed_password.encode('utf-8'))

# Register endpoint
@app.route('/register', methods=['POST'])
@admin_required
def register():
    username = request.json.get('username')
    password = hash_password(request.json.get('password'))

    if not username or not password:
        return jsonify({"msg": "Please provide both username and password"}), 400    
    
    if getUserByUsername(username):
        return jsonify({"msg": "User already exists"}), 400
    
    # Generate key pair
    private_key, public_key = generate_key_pair()
    
    user = User(username=username, password=password, role=Permission.GENERAL, public_key=public_key)
    
    db.session.add(user)
    db.session.commit()
    
    return jsonify({"msg": "User registered successfully"}), 201

# Login endpoint
@app.route('/login', methods=['POST'])
def login():
    username = request.json.get('username')
    password = request.json.get('password')

    if not username or not password:
        return jsonify({"msg": "Please provide both username and password"}), 400
    
    user = getUserByUsername(username)
    
    if not validate_password(user.password, password):
        return jsonify({"msg": "Invalid username or password"}), 401

    access_token = create_access_token(identity=username)
    return jsonify(access_token=access_token)

def deserializeModel(model, pouplate=[]):
    return {column.name: getattr(model, column.name) for column in model.__table__.columns}

def inbox_to_dict(inbox: Inbox):
    return {
        'id': inbox.id,
        'document': deserializeModel(getModelById(Document, inbox.document_id)),
        'sender': deserializeModel(getModelById(User, inbox.sender_id)),
        'date_received': inbox.date_received
    }

@app.route('/get_inbox', methods=['GET'])
@jwt_required()
def get_inbox():
    user = getUserByUsername(get_jwt_identity())
    
    inbox = Inbox.query.filter_by(receiver_id=user.id).all()
    
    return jsonify([inbox_to_dict(_inbox) for _inbox in inbox]), 200

@app.route('/send_document', methods=['POST'])
@jwt_required()
def send_document():
    if 'file' not in request.files:
        return jsonify({'error': 'No file provided'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400

    # file.mimetype != 'application/pdf'
    if  not file.filename.endswith('.pdf'):
        return jsonify({'error': 'Invalid file format. Only PDF files are allowed'}), 400
    
    # verify the signature
    signature = make_tuple(request.headers.get('Signature'))
    
    if not signature:
        return jsonify({'error': 'No signature provided'}), 400
    
    # get metadata from body
    metadata = request.form.to_dict()
    
    if not metadata:
        return jsonify({'error': 'No metadata provided'}), 400
    
    reciver_id = metadata.pop('reciver_id')
    
    if not reciver_id or not getUserById(reciver_id):
        return jsonify({'error': 'Invalid reciver_id'}), 400
    
    user = getUserByUsername(get_jwt_identity())
    
    public_key = make_tuple(user.public_key)
    
    start_time = time.time()
    
    valid = eddsa_verify(file.read(), public_key, signature, metadata)
    
    print("--- Eddsa Verify Tooks :%s ms ---" % ((time.time() - start_time) * 1000))
    
    if not valid:
        return jsonify({'error': 'Invalid signature'}), 400
    
    current_path = os.path.dirname(os.path.realpath(__file__))
    
    # Save the file to a desired location
    file.save(current_path + file.filename)
    
    document = Document(id=1,title=user.username, description="Test Description", dmetadata=metadata, signature=request.headers.get('Signature'), path=current_path + file.filename, user_id=user.id)

    db.session.add(document)
    db.session.commit()
    
    inbox = Inbox(id=1,document_id=document.id, sender_id=user.id, receiver_id=reciver_id)
    
    db.session.add(inbox)
    db.session.commit()

    return jsonify({'message': 'Document sent successfully'}), 200
