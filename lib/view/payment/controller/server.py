from flask import Flask, request, jsonify, abort
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager, UserMixin, login_user, login_required, current_user
from flask_jwt_extended import (
    JWTManager, create_access_token, jwt_required, get_jwt_identity
)
import bcrypt

from datetime import datetime

from functools import wraps

from ast import literal_eval as make_tuple

from crypto import generate_key_pair, eddsa_sign, eddsa_verify

import time, os

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///db.sqlite3'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['JWT_SECRET_KEY'] = 'dsssecretundefined@18coundntbefound'  # Change this to a random secret key

jwt = JWTManager(app)

login_manager = LoginManager(app)

db = SQLAlchemy(app)

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(user_id)


class Role(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    role_name = db.Column(db.String(50), unique=True, nullable=False)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    name = db.Column(db.String(50), nullable=False)
    lastname = db.Column(db.String(50), nullable=False)
    password = db.Column(db.String(50), nullable=False)
    public_key = db.Column(db.String(50))   
    roles = db.relationship('Role', secondary='user_role', backref=db.backref('users', lazy='dynamic'))
    
    def can(self, permission):
        return permission in [role.id for role in self.roles]
    
    def get_id(self):
           return (self.id)
       
    def __repr__(self):
        return f"User('{self.username}')"

class UserRole(db.Model):
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), primary_key=True)
    role_id = db.Column(db.Integer, db.ForeignKey('role.id'), primary_key=True)
    
class Document(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=True)
    dmetadata = db.Column(db.JSON, nullable=True)  # Store metadata as JSON
    signature = db.Column(db.String(100), nullable=True)
    path = db.Column(db.String(255), nullable=False)
    date_created = db.Column(db.DateTime, default=datetime.utcnow)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    user = db.relationship('User', backref=db.backref('documents', lazy=True))
    
class Inbox(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    document_id = db.Column(db.Integer, db.ForeignKey('document.id'), nullable=False)
    sender_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    receiver_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    date_received = db.Column(db.DateTime, default=datetime.utcnow)

# Connect MongoDB Cloud
# mongodb+srv://dss:bprH9kxByDOG5vot
# client = MongoClient("mongodb+srv://dss:bprH9kxByDOG5vot@digitialsignaturesystem.yeroqjs.mongodb.net/?retryWrites=true&w=majority&appName=DigitialSignatureSystem")

# # Create model for the database
# # users
# db = client["dss"]

# users_collection = db["users"]

class Permission:
    GENERAL = 1
    ADMIN = 0

# Dummy user credentials for demonstration purposes
# users = [
#     {
#         "id": "123456",
#         "username": "admin",
#         "password": "password",
#         "role": [Permission.ADMIN],
#         # "private_key": 97655886817525644841001748842989591847874708828217123903343932609640165809792,
#         "public_key": (26042919850653392665995592663899333172151421342577843254917442755308842232255, 27874518024675484680583672760271313946404846868622343283448833273361574810128)
#     },
#     {
#         "id": "123456",
#         "username": "user",
#         "password": "password",
#         "role": [Permission.GENERAL],
#         # "private_key": 97655886817525644841001748842989591847874708828217123903343932609640165809792,
#         "public_key": (26042919850653392665995592663899333172151421342577843254917442755308842232255, 27874518024675484680583672760271313946404846868622343283448833273361574810128)
#     }
# ]

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

if __name__ == '__main__':
    
    app.run()
    
# Example request to send a document
# POST /send_document
# Headers:
# Authorization Basic <base64 encoded username:password>
# Content-Type: multipart/form-data
# Body:
# file: <PDF file>

# Curl command to send a document with metadata
# curl -X POST -F "file=@/path/to/file.pdf" -u admin:password http://localhost:5000/send_document -H "Signature: <signature>"