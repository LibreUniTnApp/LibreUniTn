import 'package:http/http.dart' as http show Client;
import 'package:openid_client/openid_client.dart' show Flow;
import './authorized_client.dart';

class LoginRequest {
  final http.Client _httpClient;
  final Flow _authorizationFlow;

  const LoginRequest(this._httpClient, this._authorizationFlow);

  Uri get authenticationUri => _authorizationFlow.authenticationUri;

  Future<AuthorizedClient> respondWithCustomUri(Uri response) {
    /*
    TODO:
    if(response.scheme != 'unitrentoapp') throw Error
    */
    return respond(response.queryParameters);
  }

  Future<AuthorizedClient> respond(Map<String, String> response) async {
    final credentials = await _authorizationFlow.callback(response);
    return AuthorizedClient.validateBeforeCreating(_httpClient, credentials);
  }
}
