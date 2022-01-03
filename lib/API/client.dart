import 'package:http/http.dart' as http show Client;
import './openid.dart';
import './authorized_client.dart';
import './login_request.dart';

class Client {
  //TODO: Replace http.Client with a class that adds "Accept: application/json, text/plain, */*" and "unitn-culture: <language>"
  final http.Client httpClient;

  Client() : this.withHttpClient(http.Client());
  const Client.withHttpClient(this.httpClient);

  AuthorizedClient? downcast() {
    if (this is AuthorizedClient) {
      return this as AuthorizedClient;
    } else {
      return null;
    }
  }

  AuthorizedClient forceDowncast() => this as AuthorizedClient;

  Future<LoginRequest> login() async {
    final openidClient = await getOpenidClient(httpClient);
    final openidFlow = getAuthorizationFlow(openidClient);
    return LoginRequest(httpClient, openidFlow);
  }
}
