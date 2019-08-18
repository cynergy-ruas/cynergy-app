class User {
  Map<String, dynamic> claims;
  static User instance;

  void setClaims(Map<String, dynamic> claims) {
    /*
    Sets the claims. User can be changed by setting new claims.

    Args:
      claims (Map<String, dynamic>): The claims
    */

    this.claims = claims;
  }

  String getEmailID() {
    /*
    Gets the email id of the user.

    Returns:
      String: The email id.
    */

    return claims["email"];
  }

  bool isCoordinator() {
    /*
    Checks if user is a coordinator or not.

    Returns:
      bool: true, if user is a coordinator, false otherwise.
    */

    return (claims["coordinator"] != null) ? true : false;
  }

  static User getInstance() {
    /*
    Gets the user instance.

    Returns:
      User: The instance of this class.
    */

    if (instance == null) {
      instance = User();
    }
    return instance;
  }
}