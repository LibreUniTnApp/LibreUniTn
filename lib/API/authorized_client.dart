import 'package:openid_client/openid_client.dart' show Credential;
import './client.dart';
import './logout_request.dart';
import './openid_utils.dart';
import './unitn_http_client.dart';
import './login_request.dart';

class AuthorizedClient extends Client {
  final UnitnHttpClient _unauthenticatedHttpClient;
  final Credential credential;

  /* This constructor wraps the UnitnHttpClient in another client that adds the
   * access token to the requests */
  AuthorizedClient(this._unauthenticatedHttpClient, this.credential):
        super.withHttpClient(
          credential.createHttpClient(_unauthenticatedHttpClient)
        );

  LogoutRequest logout() =>
      LogoutRequest(_unauthenticatedHttpClient, getEndSessionUri(credential));

  static Future<AuthorizedClient> validateBeforeCreating(
      UnitnHttpClient httpClient,
      Credential credential
  ) async {
    final exceptionList = await credential.validateToken().toList();
    if (exceptionList.isEmpty) {
      return AuthorizedClient(httpClient, credential);
    } else {
      throw exceptionList;
    }
  }

  @override
  Future<LoginRequest> login() {
    //TODO: Improve error
    throw Exception('Logout before logging in again');
  }
}
