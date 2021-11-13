import 'package:openid_client/openid_client.dart' show Credential;
import 'package:http/http.dart' as http show Client;
import './client.dart';
import './logout_request.dart';
import './auth.dart';

class AuthorizedClient extends Client {
  final Credential credentials;

  const AuthorizedClient(http.Client httpClient, this.credentials)
      : super.withHttpClient(httpClient);

  LogoutRequest logout() =>
      LogoutRequest(httpClient, getEndSessionUri(credentials));
}
