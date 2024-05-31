class UserModel {
  String? userName;
  String? id;

  String? firstName;
  String? lastName;
  String? birthDate;
  String? address;
  String? profilePicLink = '';
  bool? canEdit = true;

  double? lat = 0;
  double? long = 0;

  UserModel({
    this.userName,
    this.id,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.address,
    this.profilePicLink = '',
    this.canEdit = true,
    this.lat = 0,
    this.long = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json['userName'],
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      birthDate: json['birthDate'],
      address: json['address'],
      profilePicLink: json['profilePicLink'],
      canEdit: json['canEdit'],
      lat: json['lat'],
      long: json['long'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
      'address': address,
      'profilePicLink': profilePicLink,
      'canEdit': canEdit,
      'lat': lat,
      'long': long,
    };
  }
}
