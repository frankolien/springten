class UserModel {
  final String username;
  final String email;
  final String fullName;
  final bool biometricEnabled;
  final String? walletAddress;
  final String? recoveryPhraseHash;
  final String status;

  UserModel({
    required this.username,
    required this.email,
    required this.fullName,
    required this.biometricEnabled,
    this.walletAddress,
    this.recoveryPhraseHash,
    required this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      biometricEnabled: json['biometricEnabled'] ?? false,
      walletAddress: json['walletAddress'],
      recoveryPhraseHash: json['recoveryPhraseHash'],
      status: json['status'] ?? 'ACTIVE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'fullName': fullName,
      'biometricEnabled': biometricEnabled,
      'walletAddress': walletAddress,
      'recoveryPhraseHash': recoveryPhraseHash,
      'status': status,
    };
  }
}

class AuthResponse {
  final String message;
  final String token;
  final String username;
  final int? userId;

  AuthResponse({
    required this.message,
    required this.token,
    required this.username,
    this.userId,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      username: json['username'] ?? '',
      userId: json['userId'],
    );
  }
}

class WalletInfo {
  final String address;
  final String username;
  final String fullName;
  final bool biometricEnabled;
  final String? error;

  WalletInfo({
    required this.address,
    required this.username,
    required this.fullName,
    required this.biometricEnabled,
    this.error,
  });

  factory WalletInfo.fromJson(Map<String, dynamic> json) {
    return WalletInfo(
      address: json['address'] ?? '',
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      biometricEnabled: json['biometricEnabled'] ?? false,
      error: json['error'],
    );
  }
}

class WalletBalance {
  final String address;
  final String balance;
  final String balanceEth;
  final String? error;

  WalletBalance({
    required this.address,
    required this.balance,
    required this.balanceEth,
    this.error,
  });

  factory WalletBalance.fromJson(Map<String, dynamic> json) {
    return WalletBalance(
      address: json['address'] ?? '',
      balance: json['balance'] ?? '0',
      balanceEth: json['balanceEth'] ?? '0',
      error: json['error'],
    );
  }
}
