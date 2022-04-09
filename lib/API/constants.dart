const clientId = 'it.unitn.icts.unitrentoapp';
const clientSecret = 'FplHsHYTvmMN7hvogSzf';
const authorizationRedirectUri = 'unitrentoapp://callback';
const logoutRedirectUri = 'unitrentoapp://endsession';
const discoveryUrl = 'https://idsrv.unitn.it/sts/identity/.well-known/openid-configuration';
const scopes = [
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
