class UserModel {
  String id;
  String displayName;
  String email;
  String photoUrl;
  String secretKey;

  UserModel(
    this.id,
    this.displayName,
    this.email,
    this.photoUrl,
    this.secretKey,
  );

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "display_name": displayName,
      "email": email,
      "photo_url": photoUrl,
      "secrete_key": secretKey,
    };
  }
}
