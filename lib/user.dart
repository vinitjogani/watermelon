import 'dart:convert';
import 'package:http/http.dart';

import 'package:googleapis_auth/auth_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String accessTokenType;
  String accessTokenData;
  DateTime accessTokenExpiry;
  String refreshToken;

  User(this.accessTokenType,
      this.accessTokenData,
      this.accessTokenExpiry,
      this.refreshToken);

  static User fromCredentials(AccessCredentials credentials) {
    return User(
        credentials.accessToken.type,
        credentials.accessToken.data,
        credentials.accessToken.expiry,
        credentials.refreshToken
    );
  }

  AccessCredentials getCredentials(scopes) {
    return AccessCredentials(
      AccessToken(accessTokenType, accessTokenData, accessTokenExpiry),
      refreshToken,
      scopes,
    );
  }

  AutoRefreshingAuthClient getClient(clientId, scopes) {
    return autoRefreshingClient(clientId, getCredentials(scopes), Client());
  }

  String toJson() {
    return jsonEncode({
      "type": accessTokenType,
      "data": accessTokenData,
      "expiry": accessTokenExpiry.toIso8601String(),
      "refresh": refreshToken
    });
  }

  static User fromJson(json) {
    return User(
      json['type'],
      json['data'],
      DateTime.parse(json['expiry']),
      json['refresh']
    );
  }

  void save({String key = 'user'}) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(key, toJson());
  }

  static Future<User> load({String key = 'user'}) async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) return fromJson(jsonDecode(prefs.getString(key)));
    else return null;
  }
}