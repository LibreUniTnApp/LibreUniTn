import 'package:meta/meta.dart';
import 'package:libreunitn/API/constants.dart';
import './client.dart';
import './unitn_http_client.dart';

class LogoutRequest {
  static late final Uri _logoutRedirect = Uri.parse(logoutRedirectUri);

  final UnitnHttpClient _httpClient;
  final Uri? logoutUrl;
  final String? _state;

  LogoutRequest(this._httpClient, this.logoutUrl)
      : _state = logoutUrl?.queryParameters['state']!;

  Client respond(Uri uri) {
    if(uri.scheme == _logoutRedirect.scheme && uri.host == _logoutRedirect.host) {
      if(uri.queryParameters['state'] == _state){
        return Client.withClient(_httpClient);
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
