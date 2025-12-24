from backend_python.database.models.user import User

def test_add_user(db_session):
    """
    GIVEN a db_session fixture
    WHEN a new user is added to the database
    THEN check that the user is correctly created
    """
    email = "test@example.com"
    user = User(email=email, hashed_password="password")
    db_session.add(user)
    db_session.commit()

    retrieved_user = db_session.query(User).filter_by(email=email).first()
    assert retrieved_user is not None
    assert retrieved_user.email == email
