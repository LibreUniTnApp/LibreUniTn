import 'dart:async';
import 'dart:ui' show Locale;
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

typedef LanguageResolver = Locale Function();

/* Using json to serialize and deserialize credentials may look ugly, but
 * it also turns the Secure Storage entry in a single source of truth,
 * this way we don't have to worry about strange logical invariants like
 * missing the idToken but not the others. This way, either everything is
 * saved or nothing */
//TODO: Use a better, binary-oriented and tightly packed serialization format (ex: msgpack, ProtocolBuffers, etc...)
class ClientManager {
  late final _logger = Logger('App.ClientManager');

  Client? _client;
  Client? get client => _client;

  final StateSetter _update;

  ClientManager._withClient(this._client, this._update);

  factory ClientManager.fromSecureStorage(LanguageResolver langResolver, StateSetter updateFunction){
    final manager = ClientManager._withClient(null, updateFunction);
    manager._scheduleReadingClientFromStorage(langResolver);
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
        iOptions: secure_storage_constants.iOSOptions,
        aOptions: secure_storage_constants.androidOptions
    ).catchError(_catchFlutterSecureStorageError);
    _setClient(client);
  }

  Future _scheduleReadingClientFromStorage(LanguageResolver langResolver) =>
      Future(() async {
        //Reading from Secure Storage
        const secureStorage = FlutterSecureStorage();
        final credentialJson = await secureStorage.read(
            key: secure_storage_constants.credentialKey,
            iOptions: secure_storage_constants.iOSOptions,
            aOptions: secure_storage_constants.androidOptions
        ).catchError(_catchFlutterSecureStorageError);

        if (credentialJson != null) {
          _logger.fine('Found Credentials in SecureStorage');
          await jsonMapperInitialized;
          final credentials = JsonMapper.fromJson<Credentials>(credentialJson)!;

          final language = langResolver().languageCode;
          _logger.finer('Received language', language);
          final client = AuthorizedClient(
              Client(language),
              credentials
          );
          //Skip saving Credentials by calling _setClient directly
          _setClient(client);
          return;
        }
        //Create a normal Client as a fallback
        final language = langResolver().languageCode;
        _logger.finer('Received language', language);
        _setClient(Client(language));
      });
  
  String? _catchFlutterSecureStorageError(dynamic error){
    _logger.severe('Error while using secureStorage', error);
    return null;
    //TODO: the error should be shown to the user before continuing. Maybe add a Handler in ClientProvider?
  }
}
