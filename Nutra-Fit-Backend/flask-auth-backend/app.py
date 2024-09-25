from flask import Flask, request, jsonify, session
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
import datetime

app = Flask(__name__)
app.secret_key = "your_secret_key"

# Database setup
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///users.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['JWT_SECRET_KEY'] = 'your_secret_key'

db = SQLAlchemy(app)
bcrypt = Bcrypt(app)
jwt = JWTManager(app)

# User model
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)

# Diet Plan model
class DietPlan(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    weight = db.Column(db.String(10), nullable=False)
    height = db.Column(db.String(10), nullable=False)
    objective = db.Column(db.String(50), nullable=False)
    work_category = db.Column(db.String(50), nullable=False)
    gender = db.Column(db.String(10), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.datetime.utcnow)

    user = db.relationship('User', backref=db.backref('diet_plans', lazy=True))

# Registration
@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    username = data['username']
    email = data['email']
    password = data['password']

    hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
    new_user = User(username=username, email=email, password=hashed_password)

    db.session.add(new_user)
    db.session.commit()

    return jsonify({"message": "User registered successfully!"}), 201

# Login
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data['email']
    password = data['password']

    user = User.query.filter_by(email=email).first()
    if user and bcrypt.check_password_hash(user.password, password):
        access_token = create_access_token(identity=user.id, expires_delta=datetime.timedelta(days=1))
        return jsonify(access_token=access_token), 200
    else:
        return jsonify({"message": "Invalid credentials!"}), 401

# Logout
@app.route('/logout', methods=['POST'])
def logout():
    session.clear()  # Clears the user session
    return jsonify({"message": "Successfully logged out"}), 200

# Dashboard
@app.route('/data', methods=['GET'])
def get_data():
    data = {
        'message': 'Welcome to your dashboard!'
    }
    return jsonify(data)

# Profile
@app.route('/user/profile', methods=['GET'])
@jwt_required()
def profile():
    current_user_id = get_jwt_identity()  # Get the current user ID from the JWT
    user = User.query.get(current_user_id)
    
    if user:
        return jsonify({
            'name': user.username,
            'email': user.email
        }), 200
    else:
        return jsonify({"message": "User not found!"}), 404

# Create Diet Plan
@app.route('/diet-plan', methods=['POST'])
@jwt_required()
def create_diet_plan():
    current_user_id = get_jwt_identity()
    user = User.query.get(current_user_id)

    if not user:
        return jsonify({"message": "User not found"}), 404

    data = request.get_json()
    weight = data.get('weight')
    height = data.get('height')
    objective = data.get('objective')
    work_category = data.get('work_category')
    gender = data.get('gender')

    if not all([weight, height, objective, work_category, gender]):
        return jsonify({"message": "All fields are required"}), 400

    new_plan = DietPlan(
        user_id=current_user_id,
        weight=weight,
        height=height,
        objective=objective,
        work_category=work_category,
        gender=gender
    )

    db.session.add(new_plan)
    db.session.commit()

    return jsonify({"message": "Diet plan created successfully!"}), 201

if __name__ == '__main__':
    app.run(debug=True)
