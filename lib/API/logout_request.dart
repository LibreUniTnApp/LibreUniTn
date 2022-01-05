import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http show Client;
import 'package:libreunitrentoapp/API/constants.dart';
import './client.dart';

class LogoutRequest {
  final http.Client _httpClient;
  final Uri? logoutUrl;
  final String? _state;

  LogoutRequest(this._httpClient, this.logoutUrl)
      : _state = logoutUrl?.queryParameters['state']!;

  Client respond(Uri uri) {
    if(uri.scheme == 'unitrentoapp' && uri.host == 'endsession') {
      if(uri.queryParameters['state'] == _state){
        return Client();
      } else {
        throw LogoutException(uri, 'State does not match');
      }
    } else {
      throw LogoutException(uri, 'Invalid Logout URI');
    }
  }
}

@immutable
class LogoutException implements Exception {
  final Uri responseUri;
  final String message;

  const LogoutException(this.responseUri, this.message);
}
