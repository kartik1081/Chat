class Users {
  late String name, email, profilePic;
  Users.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    email = json["email"];
    profilePic = json["profilePic"];
  }
}
