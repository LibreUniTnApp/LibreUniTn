import 'dart:math' show Random;
import 'dart:typed_data' show Uint8List;
import 'dart:convert' show base64Url;
import 'package:http/http.dart' as http show Client;
import 'package:openid_client/openid_client.dart';

Future<Client> getClient([http.Client? httpClient]) async {
  final issuer =
      await Issuer.discover(Uri.parse('https://idsrv.unitn.it/sts/identity'), httpClient: httpClient);
  return Client(issuer, 'it.unitn.icts.unitrentoapp',
      clientSecret: 'FplHsHYTvmMN7hvogSzf', httpClient: httpClient);
}

Flow getAuthorizationFlow(Client client) =>
    Flow.authorizationCodeWithPKCE(client, state: _generateState())
      ..redirectUri = Uri.parse('unitrentoapp://callback')
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
//TODO: add "&access_type=offline" to Authorization URL, even though it doesn't seem necessary

Uri? getEndSessionUri(Credential credential) => credential.generateLogoutUrl(
    redirectUri: Uri.parse('unitrentoapp://endsession'),
    state: _generateState());

String _generateState() {
  final rng = Random();
  final Uint8List randomByteString = Uint8List(16);
  for (int i = 0; i < randomByteString.length; ++i) {
    randomByteString[i] = rng.nextInt(0x100000000);
  }
  return base64Url.encode(randomByteString);
}
