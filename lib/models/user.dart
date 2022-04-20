class UserModel {
  late String email;
  late String userPhoto;
  late String name;
  late String? customUserId;

  UserModel({
    required this.email,
    required this.userPhoto,
    required this.name,
  });

  UserModel.fromJson(Map<String, dynamic> jsonData) {
    email = jsonData['email'];
    name = jsonData['name'];
    if (jsonData.containsKey("userPhoto")) userPhoto = jsonData['userPhoto'];
    customUserId = "${jsonData['customUserId']}";
  }
}
