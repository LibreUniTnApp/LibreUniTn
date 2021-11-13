import 'package:http/http.dart' as http show Client;
import 'package:libreunitrentoapp/API/constants.dart';
import './client.dart';

class LogoutRequest {
  final http.Client _httpClient;
  final Uri? logoutUrl;

  const LogoutRequest(this._httpClient, this.logoutUrl);

  //TODO: Refine exception
  Client respond(String uri) => uri.startsWith(logoutRedirectUri) ? Client.withHttpClient(_httpClient) : throw Exception('Incorrect redirect URL');
}
