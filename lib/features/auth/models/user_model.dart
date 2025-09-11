class UserModel {
  final String token;
  final User user;

  UserModel({
    required this.token,
    required this.user,
  });

  /// Use this when you parse the original API response:
  /// { data: [ { token: ..., user: {...} }, { ...profile... } ], ... }
  factory UserModel.fromApiResponse(Map<String, dynamic> apiJson) {
    final dataList = apiJson['data'] as List? ?? [];

    final authInfo = dataList.isNotEmpty
        ? Map<String, dynamic>.from(dataList[0])
        : <String, dynamic>{};

    final userInfo = (authInfo['user'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
    final profileInfo = dataList.length > 1
        ? Map<String, dynamic>.from(dataList[1])
        : <String, dynamic>{};

    final token = authInfo['token']?.toString() ?? '';

    return UserModel(
      token: token,
      user: User.fromJson(userInfo, profileInfo),
    );
  }

  /// Use this when reading from SharedPreferences (already flattened { token, user })
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final token = json['token']?.toString() ?? '';
    final userMap = (json['user'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
    // profileJson is not present in stored format; pass empty map
    return UserModel(
      token: token,
      user: User.fromJson(userMap, <String, dynamic>{}),
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'user': user.toJson(),
      };
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

  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String username;

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
    required this.firstName,
    required this.lastName,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> userJson, Map<String, dynamic> profileJson) {
    int _parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    return User(
      id: _parseInt(userJson['id']),
      email: userJson['email']?.toString() ?? '',
      userType: _parseInt(userJson['user_type']),
      isVerified: _parseInt(userJson['is_verified']),
      rememberToken: userJson['remember_token']?.toString(),
      profilePicture: userJson['profile_picture']?.toString(),
      apiToken: userJson['api_token']?.toString(),
      idNumber: userJson['id_number']?.toString(),
      dob: userJson['dob']?.toString(),

      phoneNumber: profileJson['phone_number']?.toString() ??
          userJson['phone_number']?.toString() ??
          '',
      firstName: profileJson['first_name']?.toString() ?? '',
      lastName: profileJson['last_name']?.toString() ?? '',
      username: profileJson['username']?.toString() ??
          userJson['username']?.toString() ??
          '',
    );
  }

  Map<String, dynamic> toJson() => {
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
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
      };

  bool get isVerifiedBool => isVerified == 1;
}