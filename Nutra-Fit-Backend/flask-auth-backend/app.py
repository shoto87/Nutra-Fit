from flask import Flask, request, jsonify, session
import wtmaintenance  
import wtloss  
import ckd2
import diebetes
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
import datetime
import logging
from flask_migrate import Migrate
# from wtloss import wtloss 

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

# Get User Details
@app.route('/user-details', methods=['GET'])
@jwt_required()
def user_details():
    current_user_id = get_jwt_identity()
    user = db.session.get(User, current_user_id)

    if not user:
        return jsonify({"message": "User not found"}), 404

    # Assuming `User` has `username` and `email` fields
    return jsonify({
        "username": user.username,
        "email": user.email
    }), 200


class UserDetails(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    age = db.Column(db.Integer, nullable=False)
    gender = db.Column(db.String(10), nullable=False)
    weight = db.Column(db.Float, nullable=False)
    height = db.Column(db.Float, nullable=False)
    work = db.Column(db.String(50), nullable=False)

  
    user = db.relationship('User', backref=db.backref('details', lazy=True))

@app.route('/submit', methods=['POST'])
def submit():
    data = request.get_json()  # Get JSON data from the request
    # name = data['name']
    age = data['age']
    gender = data['gender']
    weight = data['weight']
    height = data['height']
    work = data['work']

    user_data = {
        # 'name': name,
        'age': age,
        'gender': gender,
        'weight': weight,
        'height': height,
        'work': work
    }

    return jsonify(user_data)  # Send the user data back to Flutter




# Define a new model for user details
class UserDetailsStore(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, nullable=False)  # This can be linked with your existing user model.
    weight = db.Column(db.Float, nullable=False)
    height = db.Column(db.Float, nullable=False)
    age = db.Column(db.Integer, nullable=False)
    gender = db.Column(db.String(10), nullable=False)
    work = db.Column(db.String(20), nullable=False)

    def __repr__(self):
        return f"UserDetailsStore('{self.user_id}', '{self.weight}', '{self.height}')"

# Create the database tables if they don't exist
with app.app_context():
    db.create_all()

# New endpoint to store user details
@app.route('/user-details-store', methods=['POST'])
def store_user_details():
    data = request.get_json()

    # Extract user details from the request body
    user_id = data.get('user_id')
    weight = data.get('weight')
    height = data.get('height')
    age = data.get('age')
    gender = data.get('gender')
    work = data.get('work')

    user_data = {
        # 'name': name,
        'age': age,
        'gender': gender,
        'weight': weight,
        'height': height,
        'work': work
    }

    # Validate data
    if not user_id or not weight or not height or not age or not gender or not work:
        return jsonify({"error": "Missing required fields"}), 400

    # Create a new user details record and add it to the database
    new_user_details = UserDetails(
        user_id=user_id,  # User ID should be passed from the frontend
        weight=weight,
        height=height,
        age=age,
        gender=gender,
        work=work
    )

    db.session.add(new_user_details)
    db.session.commit()

    return jsonify({"message": "User details stored successfully"},user_data), 201





@app.route('/weight-maintenance', methods=['POST'])
def weight_maintenance():
    data = request.get_json()
    weight = data['weight']
    height = data['height']
    gender = data['gender']
    age = data['age']
    work = data['work']

    # Call the wtmen function from wtmaintenance.py to get the recipes
    recipes = wtmaintenance.wtmen(weight, height, gender, age, work)

    return jsonify(recipes)  # Return the recipes in JSON format

@app.route('/weight-loss', methods=['POST'])
def weight_loss():
    data = request.get_json()
    weight = data['weight']
    height = data['height']
    gender = data['gender']
    age = data['age']
    work = data['work']

    # Call the wtloss function from wtloss.py to get the recipes
    recipes = wtloss.wtloss(weight, height, gender, age, work)

    return jsonify(recipes)  # Return the recipes in JSON format

    
@app.route('/chronic-kidney', methods=['POST'])
def chronic_kidney():
    data = request.get_json()
    weight = data['weight']
    height = data['height']
    gender = data['gender']
    age = data['age']
    work = data['work']

    # Call the wtloss function from wtloss.py to get the recipes
    recipes =ckd2.chronickidneydisease(weight, height, gender, age, work)

    return jsonify(recipes)  # Return the recipes in JSON format


@app.route('/diebetes', methods=['POST'])
def diebetes():
    try:
        # Parse input data
        data = request.get_json()
        weight = float(data['weight'])
        height = float(data['height'])
        gender = data['gender']
        age = int(data['age'])
        work = data['work']

        # Call the diabetes function
        if weight > 0 and height > 0:
            response = diebetes.diabetes(weight, height, gender, age, work)

            # Return the response based on the logic in diabetes.py
            return jsonify({
                "message": "Diabetes management function executed successfully!",
                "result": response  # Add any relevant data from `diabetes` function
            }), 200
        else:
            return jsonify({
                "message": "Invalid weight or height values!"
            }), 400

    except Exception as e:
        logging.error(f"Error in diebetes endpoint: {str(e)}")
        return jsonify({
            "message": "An error occurred while processing the request.",
            "error": str(e)
        }), 500


if __name__ == '__main__':
    app.run(debug=True)
