class UserModel {
  final String token;
  final User user;

  UserModel({
    required this.token,
    required this.user,
  });

  // Factory method to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['data']['token'] as String? ?? '',
      user: User.fromJson(json['data']['user'] ?? {}),
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': {
        'token': token,
        'user': user.toJson(),
      },
    };
  }
}

class User {
  final int id;
  final String email;
  final int userType;
  final int isVerified;
  final String? rememberToken;
  final String? profilePicture;
  final String? apiToken;
  final String? idNumber;
  final String? dob;
  final int phoneNumber;

  User({
    required this.id,
    required this.email,
    required this.userType,
    required this.isVerified,
    this.rememberToken,
    this.profilePicture,
    this.apiToken,
    this.idNumber,
    this.dob,
    required this.phoneNumber,
  });

  // Factory method to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      userType: json['user_type'] as int? ?? 0,
      isVerified: json['is_verified'] as int? ?? 0,
      rememberToken: json['remember_token'] as String?,
      profilePicture: json['profile_picture'] as String?,
      apiToken: json['api_token'] as String?,
      idNumber: json['id_number'] as String?,
      dob: json['dob'] as String?,
      phoneNumber: json['phone_number'] as int? ?? 0,
    );
  }

  // Method to convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'user_type': userType,
      'is_verified': isVerified,
      'remember_token': rememberToken,
      'profile_picture': profilePicture,
      'api_token': apiToken,
      'id_number': idNumber,
      'dob': dob,
      'phone_number': phoneNumber,
    };
  }
}
