import 'package:meta/meta.dart' show protected;
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import './authorized_client.dart';

class Client extends http.BaseClient {
  @protected
  late final Logger logger = createLogger();

  String language;

  Client(String language) : this._withHttpClient(http.Client(), language);
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
