class AuthResponseModel {
  final String accessToken;

  const AuthResponseModel({required this.accessToken});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(accessToken: json['data']['access_token']);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {'access_token': accessToken},
    };
  }
}
