class AuthResponseModel {
  final String accessToken;

  const AuthResponseModel({required this.accessToken});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final accessToken = data?['access_token'] as String?;
    
    if (accessToken == null) {
      throw Exception('Invalid response format: access_token is missing');
    }
    
    return AuthResponseModel(accessToken: accessToken);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {'access_token': accessToken},
    };
  }
}
