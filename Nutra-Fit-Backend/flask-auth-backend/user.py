
# Create User Data (including weight loss diet plan)
@app.route('/create-user-data', methods=['POST'])
@jwt_required()
def create_user_data():
    current_user_id = get_jwt_identity()
    user = db.session.get(User, current_user_id)  # Replaced deprecated method

    if not user:
        return jsonify({"message": "User not found"}), 404

    data = request.get_json()
    weight = data.get('weight')
    height = data.get('height')
    objective = data.get('objective')
    work_category = data.get('work_category')
    gender = data.get('gender')
    age = data.get('age')  # Ensure 'age' is part of the form

    if not all([weight, height, objective, work_category, gender, age]):
        return jsonify({"message": "All fields are required"}), 400

    try:
        new_user_data = UserData(
            user_id=current_user_id,
            weight=weight,
            height=height,
            objective=objective,
            work_category=work_category,
            gender=gender,
            age=age
        )

        db.session.add(new_user_data)
        db.session.commit()

       

        return jsonify({"message": "User data created successfully!"}), 201

    except Exception as e:
        logging.error(f"Error creating user data: {str(e)}")
        return jsonify({"message": "An error occurred while creating user data"}), 500
