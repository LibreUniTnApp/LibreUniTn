import 'package:openid_client/openid_client.dart' show Credential;
import 'package:http/http.dart' as http show Client;
import './client.dart';

class AuthorizedClient extends Client {
  final Credential _credentials;

  const AuthorizedClient(http.Client httpClient, this._credentials)
      : super.withHttpClient(httpClient);
}
