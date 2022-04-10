import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';
import './constants.dart';

//TODO: Maybe implement validation? Theoretically the server doesn't support it, so it would be useless
@jsonSerializable
class Credentials {
  final String accessToken;
  final String refreshToken;
  final DateTime accessTokenExpiration;
  final String idToken;

  const Credentials({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiration,
    required this.idToken
  });

  static Credentials fromTokenResponse(TokenResponse tokenResponse){
    if(
      tokenResponse.accessToken != null &&
          tokenResponse.refreshToken != null &&
          tokenResponse.accessTokenExpirationDateTime != null &&
          tokenResponse.idToken != null
    ){
      return Credentials(
        accessToken: tokenResponse.accessToken!,
        refreshToken: tokenResponse.refreshToken!,
        accessTokenExpiration: tokenResponse.accessTokenExpirationDateTime!,
        idToken: tokenResponse.idToken!
      );
    } else {
      //TODO: Improve Error
      throw "Failed Validation!";
    }
  }

  static Credentials fromTokenResponseWithId(TokenResponse tokenResponse, String idToken){
    if(
      tokenResponse.accessToken != null &&
        tokenResponse.refreshToken != null &&
        tokenResponse.accessTokenExpirationDateTime != null
    ){
      return Credentials(
          accessToken: tokenResponse.accessToken!,
          refreshToken: tokenResponse.refreshToken!,
          accessTokenExpiration: tokenResponse.accessTokenExpirationDateTime!,
          idToken: tokenResponse.idToken ?? idToken
      );
    } else {
      //TODO: Improve Error
      throw "Failed Validation!";
    }
  }

  Future<Credentials> refresh() async {
    /* This should refer to the same FlutterAppAuthPlatform singleton, the class
     * should be cheap to instantiate */
    final appAuth = FlutterAppAuth();
    final tokenResponse = await appAuth.token(
      TokenRequest(
        OpenIDConstants.clientId,
        OpenIDConstants.authorizationRedirectUri,
        clientSecret: OpenIDConstants.clientSecret,
        discoveryUrl: OpenIDConstants.discoveryUrl,
        refreshToken: refreshToken,
        //grantType: 'refresh_token'
      )
    );
    if(tokenResponse != null){
      return Credentials.fromTokenResponseWithId(tokenResponse, idToken);
    } else {
      //TODO: Improve error
      throw "No Response";
    }
  }
}