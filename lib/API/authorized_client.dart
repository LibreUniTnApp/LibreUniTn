import 'package:openid_client/openid_client.dart' show Credential;
import 'package:http/http.dart' as http show Client;
import './client.dart';
import './logout_request.dart';
import './auth.dart';

class AuthorizedClient extends Client {
  final Credential credential;

  const AuthorizedClient(http.Client httpClient, this.credential)
      : super.withHttpClient(httpClient);

  LogoutRequest logout() =>
      LogoutRequest(httpClient, getEndSessionUri(credential));

  static Future<AuthorizedClient> validateBeforeCreating(
      http.Client httpClient, Credential credential) async {
    final exceptionList = await credential.validateToken().toList();
    if (exceptionList.isEmpty) {
      return AuthorizedClient(httpClient, credential);
    } else {
      throw exceptionList;
    }
  }
}
