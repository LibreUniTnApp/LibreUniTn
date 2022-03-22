import 'package:meta/meta.dart';
import 'package:http/http.dart' as http show Client;
import './openid_utils.dart';
import './authorized_client.dart';
import './login_request.dart';
import './unitn_http_client.dart';

class Client {
  final http.Client httpClient;

  /* WARNING: This is not ok, language should always be specified.
   * since there's no easy way in the application to set a language, this
   * will have to do for now. the defaultLanguage() constructor should be preferred */
  //TODO: Make language a required positional parameter
  @Deprecated("Language should always be specified")
  Client([String language = 'en']) : this.withHttpClient(UnitnHttpClient(language));
  Client.defaultLanguage() : this.withHttpClient(UnitnHttpClient('en'));
  Client.withClient(UnitnHttpClient client) : this.withHttpClient(client);
  @protected
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
    return LoginRequest(httpClient as UnitnHttpClient, openidFlow);
  }
}
