from flask_sqlalchemy import SQLAlchemy

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
    
def init(app):
    return SQLAlchemy(app)