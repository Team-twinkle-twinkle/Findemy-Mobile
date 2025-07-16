class UserModel {
  String accountId;
  String password;

  UserModel({required this.accountId, required this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account_id'] = accountId;
    data['password'] = password;

    return data;
  }
}