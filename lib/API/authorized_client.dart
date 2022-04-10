import 'package:meta/meta.dart' show protected;
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:logging/logging.dart';
import './client.dart';
import './credentials.dart';
import './constants.dart';

class AuthorizedClient extends Client {
  final Credentials credentials;

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
