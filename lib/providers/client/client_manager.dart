import 'dart:async';
import 'package:flutter/widgets.dart' show StateSetter;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libreunitn/API/credentials.dart';
import 'package:logging/logging.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart' show JsonMapper;
import 'package:libreunitn/main.dart' show jsonMapperInitialized;
import 'package:libreunitn/API/client.dart';
import 'package:libreunitn/API/authorized_client.dart';
import 'package:libreunitn/secure_storage_constants.dart'
  as secure_storage_constants;

class ClientManager {
  late final _logger = Logger('App.ClientManager');

  Client? _client;
  Client? get client => _client;

  final StateSetter _update;

  ClientManager._withClient(this._client, this._update);

  factory ClientManager.fromSecureStorage(StateSetter updateFunction){
    final manager = ClientManager._withClient(null, updateFunction);
    manager._scheduleReadingClientFromStorage();
    return manager;
  }

  void _setClient(Client client) {
    _logger.info('setClient called with ${client.runtimeType}');
    _update(() => _client = client);
  }

  void login(AuthorizedClient authClient) async {
    _setClient(authClient);
    await jsonMapperInitialized;
    const secureStorage = FlutterSecureStorage();
    await secureStorage.write(
        key: secure_storage_constants.credentialKey,
        value: JsonMapper.serialize(authClient.credentials),
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

  Future _scheduleReadingClientFromStorage() =>
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
          await jsonMapperInitialized;
          final credentials = JsonMapper.fromJson<Credentials>(credentialJson)!;
          try {
            final client = AuthorizedClient(
                Client(),
                credentials
            );
            //Skip saving Credentials
            _setClient(client);
            return;
          } on List<Exception> catch (exceptions) {
            _logger.severe('Couldn\'t validate Credentials', exceptions);
          }
        }
        //Create a normal Client as a fallback
        _setClient(Client());
      });
  
  String? _catchFlutterSecureStorageError(dynamic error){
    _logger.severe('Error while reading secureStorage', error);
    return null;
    //TODO: the error should be shown to the user before continuing. Maybe add a Handler in ClientProvider?
  }
}
