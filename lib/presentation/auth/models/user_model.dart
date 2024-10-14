class UserModel {
  String? login;
  String? name;
  String? email;
  String? locationId;
  String? token;
  String? refreshToken;
  String? baseUrl;

  UserModel(
      {this.login,
      this.name,
      this.email,
      this.locationId,
      this.token,
      this.refreshToken,
      this.baseUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String? login = json['login'];
    String? name = json['name'];
    String? email = json['email'];
    String? locationId = (json['locationid']).toString();
    String? token = json['apitoken'];
    String? refreshToken = json['refresh_token'];
    String? baseUrl = 'http://rajwin.dyndns.org:8092/scriptcase/app/ekc_qc';
    // String? baseUrl = 'https://192.168.0.78:8091';

    return UserModel(
        login: login,
        name: name,
        email: email,
        locationId: locationId,
        baseUrl: baseUrl,
        token: token,
        refreshToken: refreshToken);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = login;
    data['name'] = name;
    data['email'] = email;
    data['locationId'] = locationId;
    data['apitoken'] = token;
    data['refresh_token'] = refreshToken;
    data['baseUrl'] = baseUrl;
    return data;
  }
}
