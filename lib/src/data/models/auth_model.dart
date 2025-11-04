class AuthResponse {
  final bool status;
  final String message;
  final AuthData data;

  AuthResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: AuthData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class AuthData {
  final UserModel user;
  final String token;

  AuthData({
    required this.user,
    required this.token,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      user: UserModel.fromJson(json['user'] ?? {}),
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
    };
  }
}

class UserModel {
  final int id;
  final String username;
  final String name;
  final String role;
  final bool active;

  UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.role,
    required this.active,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'role': role,
      'active': active,
    };
  }

  UserModel copyWith({
    int? id,
    String? username,
    String? name,
    String? role,
    bool? active,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      role: role ?? this.role,
      active: active ?? this.active,
    );
  }
}

class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
