class AuditResponse {
  final bool status;
  final String message;
  final AuditData data;

  AuditResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AuditResponse.fromJson(Map<String, dynamic> json) {
    return AuditResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: AuditData.fromJson(json['data'] ?? {}),
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

class AuditData {
  final List<AuditLogModel> auditLogs;

  AuditData({
    required this.auditLogs,
  });

  factory AuditData.fromJson(Map<String, dynamic> json) {
    return AuditData(
      auditLogs:
          (json['auditLogs'] as List<dynamic>?)
              ?.map((e) => AuditLogModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'auditLogs': auditLogs.map((e) => e.toJson()).toList(),
    };
  }
}

class AuditLogModel {
  final int id;
  final int? userId;
  final String action;
  final String description;
  final Map<String, dynamic> details;
  final String? ipAddress;
  final DateTime createdAt;
  final AuditUser? user;

  AuditLogModel({
    required this.id,
    this.userId,
    required this.action,
    required this.description,
    required this.details,
    this.ipAddress,
    required this.createdAt,
    this.user,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    return AuditLogModel(
      id: json['id'] ?? 0,
      userId: json['user_id'],
      action: json['action'] ?? '',
      description: json['description'] ?? '',
      details: json['details'] as Map<String, dynamic>? ?? {},
      ipAddress: json['ip_address'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      user: json['user'] != null
          ? AuditUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'action': action,
      'description': description,
      'details': details,
      'ip_address': ipAddress,
      'created_at': createdAt.toIso8601String(),
      if (user != null) 'user': user!.toJson(),
    };
  }

  // Método auxiliar para obter o nome do usuário
  String get userName {
    return user?.name ?? 'Usuário ID: ${userId ?? 'N/A'}';
  }

  // Método auxiliar para obter o tipo de ação formatado
  String get actionType {
    switch (action) {
      case 'LOGIN_SUCCESS':
        return 'Login';
      case 'LOGIN_FAILED':
        return 'Falha no Login';
      case 'LOGIN_USER_NOT_FOUND':
        return 'Usuário não encontrado';
      case 'LOGOUT':
        return 'Logout';
      case 'CLASSIFICATION_SUCCESS':
        return 'Classificação';
      case 'USER_CREATE':
        return 'Criação de Usuário';
      case 'USER_UPDATE':
        return 'Atualização de Usuário';
      case 'USER_DELETE':
        return 'Exclusão de Usuário';
      case 'USER_ACTIVATE':
        return 'Ativação de Usuário';
      case 'USER_DEACTIVATE':
        return 'Desativação de Usuário';
      default:
        return action;
    }
  }

  // Método auxiliar para obter a cor do ícone baseado na ação
  String get actionCategory {
    if (action.startsWith('LOGIN') || action == 'LOGOUT') {
      return 'auth';
    } else if (action.startsWith('CLASSIFICATION')) {
      return 'classification';
    } else if (action.startsWith('USER')) {
      return 'user';
    }
    return 'other';
  }

  // Método auxiliar para verificar se a ação foi bem-sucedida
  bool get isSuccess {
    return action.contains('SUCCESS') ||
        action == 'LOGOUT' ||
        action == 'USER_CREATE' ||
        action == 'USER_UPDATE' ||
        action == 'USER_ACTIVATE';
  }

  AuditLogModel copyWith({
    int? id,
    int? userId,
    String? action,
    String? description,
    Map<String, dynamic>? details,
    String? ipAddress,
    DateTime? createdAt,
    AuditUser? user,
  }) {
    return AuditLogModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      description: description ?? this.description,
      details: details ?? this.details,
      ipAddress: ipAddress ?? this.ipAddress,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
    );
  }
}

class AuditUser {
  final int id;
  final String name;
  final String username;
  final String role;
  final bool active;

  AuditUser({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
    required this.active,
  });

  factory AuditUser.fromJson(Map<String, dynamic> json) {
    return AuditUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      role: json['role'] ?? '',
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'role': role,
      'active': active,
    };
  }
}
