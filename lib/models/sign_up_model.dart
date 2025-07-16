class SignUpModel {
  String accountId;
  String password;

  SignUpModel({required this.accountId, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'password': password,
    };
  }
}
