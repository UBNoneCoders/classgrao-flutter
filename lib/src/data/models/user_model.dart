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
      id: json['id'] as int,
      username: json['username'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      active: json['active'] as bool,
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

class CreateUserRequest {
  final String username;
  final String password;
  final String name;
  final String role;
  final bool active;

  CreateUserRequest({
    required this.username,
    required this.password,
    required this.name,
    required this.role,
    this.active = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'name': name,
      'role': role,
      'active': active,
    };
  }
}

class UpdateUserRequest {
  final String? username;
  final String? password;
  final String? name;
  final String? role;
  final bool? active;

  UpdateUserRequest({
    this.username,
    this.password,
    this.name,
    this.role,
    this.active,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (username != null) json['username'] = username;
    if (password != null) json['password'] = password;
    if (name != null) json['name'] = name;
    if (role != null) json['role'] = role;
    if (active != null) json['active'] = active;

    return json;
  }

  bool get hasData =>
      username != null ||
      password != null ||
      name != null ||
      role != null ||
      active != null;
}
