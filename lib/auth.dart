import 'package:openid_client/openid_client.dart';

Future<Client> getClient() async {
  final issuer =
      await Issuer.discover(Uri.parse('https://idsrv.unitn.it/sts/identity'));
  return Client(issuer, 'it.unitn.icts.unitrentoapp',
      clientSecret: 'FplHsHYTvmMN7hvogSzf');
}

Flow getAuthorizationFlow(Client client) =>
    Flow.authorizationCodeWithPKCE(client, state: 'placeholder')
      ..redirectUri = Uri.parse('unitrentoapp://callback')
      ..scopes.addAll(const [
        'openid',
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
    redirectUri: Uri.parse('unitrentoapp://endsession'), state: 'placeholder');

String _generateState() =>
    throw UnimplementedError('generateState not yet implemented');
