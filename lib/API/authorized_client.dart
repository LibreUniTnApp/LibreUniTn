import 'package:http/http.dart' as http;
import './client.dart';

class AuthorizedClient extends Client {
  final Credential credential;

  AuthorizedClient(Client client, this.credential):
        super.fromClient(client);

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
  Future<AuthorizedClient> login() {
    //TODO: Improve error, maybe return this?
    throw Exception('Logout before logging in again');
  }

  //TODO: Add refresh code, insert token in Request
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return super.send(request);
  }
}
