import 'dart:async';
import 'dart:convert' show json;
import 'package:flutter/widgets.dart' show StateSetter;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:libreunitn/API/client.dart';
import 'package:libreunitn/API/authorized_client.dart';
import 'package:libreunitn/secure_storage_constants.dart'
  as secure_storage_constants;

class ClientManager {
  static late final _logger = Logger('App.ClientManager');

  Client? _client;
  Client? get client => _client;

  final StateSetter _update;

  ClientManager._withClient(this._client, this._update);

  factory ClientManager.fromSecureStorage(StateSetter updateFunction){
    final manager = ClientManager._withClient(null, updateFunction);
    _scheduleReadingClientFromStorage(manager);
    return manager;
  }

  void _setClient(Client client) {
    _logger.info('setClient called with ${client.runtimeType}');
    _update(() => _client = client);
  }

  void login(AuthorizedClient authClient) async {
    _setClient(authClient);
    const secureStorage = FlutterSecureStorage();
    await secureStorage.write(
        key: secure_storage_constants.credentialKey,
        value: json.encode(authClient.credential.toJson()),
        iOptions: secure_storage_constants.iOSOptions,
        aOptions: secure_storage_constants.androidOptions
    ).catchError(_catchFlutterSecureStorageError);
  }

  void logout(Client client) async {
    const secureStorage = FlutterSecureStorage();
    await secureStorage.delete(
        key: secure_storage_constants.credentialKey,
        iOptions: secure_storage_constants.iOSOptions
    ).catchError(_catchFlutterSecureStorageError);
    _setClient(client);
  }

  static Future _scheduleReadingClientFromStorage(ClientManager manager) =>
      Future(() async {
        //Reading from Secure Storage
        const secureStorage = FlutterSecureStorage();
        final credentialJson = await secureStorage.read(
            key: secure_storage_constants.credentialKey,
            iOptions: secure_storage_constants.iOSOptions,
            aOptions: secure_storage_constants.androidOptions
        ).catchError(_catchFlutterSecureStorageError);

        if (credentialJson != null) {
          _logger.finer('Found Credentials in SecureStorage');
          final credential = Credential.fromJson(json.decode(credentialJson));
          try {
            //See comment in LoginRequest.respond, which is in API/login_request.dart
            /*final client = await AuthorizedClient.validateBeforeCreating(
              http.Client(),
              credential
          );*/
            final client = AuthorizedClient(
                UnitnHttpClient(),
                credential
            );
            //Skip saving Credentials
            manager._setClient(client);
            return;
          } on List<Exception> catch (exceptions) {
            _logger.severe('Couldn\'t validate Credentials', exceptions);
          }
        }
        //Create a normal Client as a fallback
        manager._setClient(Client());
      });
  
  static String? _catchFlutterSecureStorageError(dynamic error){
    _logger.severe('Error while reading secureStorage', error);
    return null;
    //TODO: the error should be shown to the user before continuing. Maybe add a Handler in ClientProvider?
  }
}
