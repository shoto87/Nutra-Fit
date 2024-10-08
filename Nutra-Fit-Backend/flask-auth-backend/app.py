from flask import Flask, request, jsonify, session
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
import datetime
import logging
from flask_migrate import Migrate


app = Flask(__name__)
app.secret_key = "your_secret_key"

# Database setup
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///users.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['JWT_SECRET_KEY'] = 'your_secret_key'

db = SQLAlchemy(app)
bcrypt = Bcrypt(app)
jwt = JWTManager(app)
migrate = Migrate(app, db) 

# Set up logging
logging.basicConfig(level=logging.INFO)

# User model
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)

    # Relationship to UserData
    user_data = db.relationship('UserData', backref='user', lazy=True)

# User Data model
class UserData(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    weight = db.Column(db.String(10), nullable=False)
    height = db.Column(db.String(10), nullable=False)
    objective = db.Column(db.String(50), nullable=False)
    work_category = db.Column(db.String(50), nullable=False)
    gender = db.Column(db.String(10), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.datetime.utcnow)

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
        logging.warning(f"Failed login attempt for email: {email}")
        return jsonify({"message": "Invalid credentials!"}), 401

# Logout
@app.route('/logout', methods=['POST'])
def logout():
    session.clear()
    return jsonify({"message": "Successfully logged out"}), 200

# Create User Data
@app.route('/create-user-data', methods=['POST'])
@jwt_required()
def create_user_data():
    current_user_id = get_jwt_identity()
    user = User.query.get(current_user_id)

    if not user:
        logging.warning(f"User not found for ID: {current_user_id}")
        return jsonify({"message": "User not found"}), 404

    data = request.get_json()

    weight = data.get('weight')
    height = data.get('height')
    objective = data.get('objective')
    work_category = data.get('work_category')
    gender = data.get('gender')

    # Check for required fields
    if not all([weight, height, objective, work_category, gender]):
        logging.warning("One or more fields are missing: "
                        f"weight={weight}, height={height}, "
                        f"objective={objective}, work_category={work_category}, gender={gender}")
        return jsonify({"message": "All fields are required"}), 400

    try:
        new_user_data = UserData(
            user_id=current_user_id,
            weight=weight,
            height=height,
            objective=objective,
            work_category=work_category,
            gender=gender
        )

        db.session.add(new_user_data)
        db.session.commit()
        logging.info(f"User data created successfully for user ID: {current_user_id}")

        return jsonify({"message": "User data created successfully!"}), 201

    except Exception as e:
        logging.error(f"Error creating user data: {str(e)}")
        return jsonify({"message": "An error occurred while creating the user data."}), 500

# Get User Details
@app.route('/user-details', methods=['GET'])
@jwt_required()
def user_details():
    current_user_id = get_jwt_identity()
    user = User.query.get(current_user_id)

    if not user:
        return jsonify({"message": "User not found"}), 404

    user_data = {
        "username": user.username,
        "email": user.email,
        "diet_plans": [
            {
                "weight": plan.weight,
                "height": plan.height,
                "objective": plan.objective,
                "work_category": plan.work_category,
                "gender": plan.gender,
                "created_at": plan.created_at.isoformat()  # Optional: if you want to include created_at
            } for plan in user.user_data  # This should be user.user_data instead of user.diet_plans
        ]
    }

    return jsonify(user_data), 200


    return jsonify(user_data), 200

if __name__ == '__main__':
    app.run(debug=True)
