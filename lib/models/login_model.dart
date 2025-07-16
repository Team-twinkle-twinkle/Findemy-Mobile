class LoginModel {
  String? accessToken;
  String? refreshToken;

  LoginModel({required this.accessToken, required this.refreshToken});

  LoginModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }
}
