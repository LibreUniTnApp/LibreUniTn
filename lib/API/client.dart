import 'package:meta/meta.dart' show protected;
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:logging/logging.dart';
import './authorized_client.dart';
import './credentials.dart';
import './constants.dart' as constants;

class Client extends http.BaseClient {
  @protected
  late final Logger logger = createLogger();

  final String language;

  /* WARNING: This is not ok, language should always be specified.
   * since there's no easy way in the application to set a language yet, this
   * will have to do for now. */
  //TODO: Make language a required positional parameter
  @Deprecated("Language should always be specified")
  Client([String language = 'en']) : this._withHttpClient(http.Client(), language);
  Client.fromClient(Client source) : this._withHttpClient(source._inner, source.language);

  /* This can be called only from the other constructors, so _inner will either
   * come from another Client or it will be a new valid HTTP Client */
  Client._withHttpClient(this._inner, this.language);

  AuthorizedClient? downcast() {
    if (this is AuthorizedClient) {
      return this as AuthorizedClient;
    } else {
      return null;
    }
  }

  AuthorizedClient forceDowncast() => this as AuthorizedClient;

  Future<AuthorizedClient> login() async {
    final appAuth = FlutterAppAuth();
    //TODO: Maybe wrap in try{} to handle exceptions?
    final tokenResponse = await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        constants.clientId,
        constants.authorizationRedirectUri,
        clientSecret: constants.clientSecret,
        discoveryUrl: constants.discoveryUrl,
        scopes: constants.scopes
      )
    );
    if(tokenResponse != null){
      logger.fine(()=>'Received $tokenResponse');
      final credentials = Credentials.fromTokenResponse(tokenResponse);
      return AuthorizedClient(this, credentials);
    } else {
      //TODO: Handle error
      throw "No Response";
    }
  }

  final http.Client _inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    //Adding Accept to warn the server that we expect json or text
    request.headers['Accept'] = 'application/json, text/plain, */*';
    //Adding unitn-culture header because Accept-Language wasn't good enough
    request.headers['unitn-culture'] = language;
    return _inner.send(request);
  }

  @protected
  Logger createLogger() => Logger('Client');
}
