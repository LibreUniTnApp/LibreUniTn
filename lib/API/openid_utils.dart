import 'dart:math' show Random;
import 'dart:typed_data' show Uint8List;
import 'dart:convert' show base64Url;
import 'package:http/http.dart' as http show Client;
import 'package:openid_client/openid_client.dart';
import './constants.dart';

Future<Client> getOpenidClient([http.Client? httpClient]) async {
  final issuer = await Issuer.discover(
      Uri.parse('https://idsrv.unitn.it/sts/identity'),
      httpClient: httpClient);
  return Client(issuer, 'it.unitn.icts.unitrentoapp',
      clientSecret: 'FplHsHYTvmMN7hvogSzf', httpClient: httpClient);
}

Flow getAuthorizationFlow(Client client, [ String? state ]) =>
    Flow.authorizationCodeWithPKCE(client, state: state ?? _generateState())
      ..redirectUri = Uri.parse(authorizationRedirectUri)
      ..scopes.addAll(const [
//        'openid', should be already in the array
        'profile',
        'account',
        'email',
        'offline_access',
        'icts://unitrentoapp/preferences',
        'icts://servicedesk/support',
        'icts://studente/carriera',
        'icts://opera/mensa'
      ]);

Uri? getEndSessionUri(Credential credential) => credential.generateLogoutUrl(
    redirectUri: Uri.parse(logoutRedirectUri),
    state: _generateState()
);

String _generateState() {
  final rng = Random();
  final Uint8List randomByteString = Uint8List(10);
  for (int i = 0; i < randomByteString.length; ++i) {
    randomByteString[i] = rng.nextInt(0x100000000);
  }
  return base64Url.encode(randomByteString);
}
