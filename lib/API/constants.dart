abstract class OpenIDConstants {
        static const clientId = 'it.unitn.icts.unitrentoapp';
        static const clientSecret = 'FplHsHYTvmMN7hvogSzf';
        static const authorizationRedirectUri = 'unitrentoapp://callback';
        static const logoutRedirectUri = 'unitrentoapp://endsession';
        static const discoveryUrl = 'https://idsrv.unitn.it/sts/identity/.well-known/openid-configuration';
        static const scopes = [
                'openid',
                'profile',
                'account',
                'email',
                'offline_access',
                'icts://unitrentoapp/preferences',
                'icts://servicedesk/support',
                'icts://studente/carriera',
                'icts://opera/mensa'
        ];

        //This should ensure that the class is never instantiated or extended
        OpenIDConstants._();
}
