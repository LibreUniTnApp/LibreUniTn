import 'dart:math' show Random;
import 'dart:typed_data' show Uint8List;
import 'dart:convert' show base64;
import 'package:oauth2/oauth2.dart' show Client, AuthorizationCodeGrant;

Uri getClient() {
  //Generating 128 random bits
  late final String codeVerifier;
  {
    //128 / 8 gives the number of bytes
    final codeVerifierBytes = Uint8List(128 ~/ 8);
    final rng = Random.secure();
    for (int i = 0; i < codeVerifierBytes.length; ++i) {
      codeVerifierBytes[i] = rng.nextInt(0x100000000);
    }
    codeVerifier = base64.encode(codeVerifierBytes);
  }

  final authorizationGrant = AuthorizationCodeGrant(
    'it.unitn.icts.unitrentoapp',
    Uri.parse('https://idsrv.unitn.it/sts/identity/connect/authorize'),
    Uri.parse('https://idsrv.unitn.it/sts/identity/connect/authorize'),
    secret: 'FplHsHYTvmMN7hvogSzf',
    basicAuth: false,
    codeVerifier: codeVerifier
  );
  return authorizationGrant.getAuthorizationUrl(
    Uri.parse('unitrentoapp://callback'),
    scopes: const [
      'openid', 'profile', 'account', 'email', 'offline_access',
      'icts://unitrentoapp/preferences', 'icts://servicedesk/support',
      'icts://studente/carriera', 'icts://opera/mensa'
    ]
    //TODO: generate state
  );
  //https://idsrv.unitn.it/sts/identity/connect/authorize?state=hdpV4DRZf8&access_type=offline&client_secret=FplHsHYTvmMN7hvogSzf
}
