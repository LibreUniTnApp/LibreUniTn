import 'package:meta/meta.dart' show protected;
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import './client.dart';
import './credentials.dart';

class AuthorizedClient extends Client {
  final Credentials credentials;

  //TODO: Validate credentials (introspection OpenID endpoint?)
  AuthorizedClient(Client client, this.credentials):
        super.fromClient(client);

  //TODO: Add refresh code, insert token in Request
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    //super.send adds generic headers and delegates to http.Client
    return super.send(request);
  }

  @override
  @protected
  Logger createLogger() => Logger('AuthorizedClient');
}
