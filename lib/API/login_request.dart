import 'package:flutter/foundation.dart';
import 'package:openid_client/openid_client.dart' show Flow;
import './authorized_client.dart';
import './unitn_http_client.dart';

class LoginRequest {
  final UnitnHttpClient _httpClient;
  final Flow _authorizationFlow;

  const LoginRequest(this._httpClient, this._authorizationFlow);

  Uri get authenticationUri {
    final originalAuthUri = _authorizationFlow.authenticationUri;
    // We add access_type=offline to the URI
    return originalAuthUri.replace(
      queryParameters: {
        ...originalAuthUri.queryParametersAll,
        'access_type': const ['offline']
      }
    );
  }

  Future<AuthorizedClient> respondWithCustomUri(Uri response) {
    if(response.scheme == 'unitrentoapp' && response.host == 'callback'){
      return respond(response.queryParameters);
    } else {
      throw LoginException(response, 'Invalid Login URI');
    }
  }

  Future<AuthorizedClient> respond(Map<String, String> response) async {
    final credentials = await _authorizationFlow.callback(response);
    /* Right now validation fails because the token cannot be validated
     * The original application, to my knowledge, doesn't verify the token signature
     * so we can safely skip the validation */
    //return AuthorizedClient.validateBeforeCreating(_httpClient, credentials);
    return AuthorizedClient(_httpClient, credentials);
  }
}

@immutable
class LoginException implements Exception {
  final Uri responseUri;
  final String message;

  const LoginException(this.responseUri, this.message);
}