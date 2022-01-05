import 'dart:async';
import 'dart:convert' show json;
import 'package:flutter/foundation.dart' show ValueNotifier, Key;
import 'package:flutter/widgets.dart'
    show InheritedNotifier, Widget, BuildContext;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:openid_client/openid_client.dart' show Credential;
import 'package:http/http.dart' as http show Client;
import 'package:logging/logging.dart';
import 'package:libreunitrentoapp/API/client.dart';
import 'package:libreunitrentoapp/API/authorized_client.dart';
import 'package:libreunitrentoapp/secure_storage_constants.dart'
    as secure_storage_constants;

late final clientManager = ClientManager._fromSecureStorage();

class ClientManager extends ValueNotifier<Client?> {
  factory ClientManager._fromSecureStorage() {
    final notifier = ClientManager._(null);
    Future(() async {
      //Reading from Secure Storage
      const secureStorage = FlutterSecureStorage();
      final credentialJson = await secureStorage.read(
          key: secure_storage_constants.credentialKey,
          iOptions: secure_storage_constants.iOSOptions,
          aOptions: secure_storage_constants.androidOptions
      ).catchError(catchFlutterSecureStorageError);
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
              http.Client(),
              credential
          );
          //Skip saving Credentials
          notifier._setClient(client);
          return;
        } on List<Exception> catch (exceptions) {
          _logger.severe('Couldn\'t validate Credentials', exceptions);
        }
      }
      //Create a normal Client as a fallback
      notifier._setClient(Client());
    });
    return notifier;
  }

  ClientManager._(Client? client) : super(client);

  Client? get client => super.value;

  void _setClient(Client client) {
    _logger.info('setClient called with ${client.runtimeType}');
    super.value = client;
    notifyListeners();
  }

  void login(AuthorizedClient authClient) async {
    const secureStorage = FlutterSecureStorage();
    await secureStorage.write(
        key: secure_storage_constants.credentialKey,
        value: json.encode(authClient.credential.toJson()),
        iOptions: secure_storage_constants.iOSOptions,
        aOptions: secure_storage_constants.androidOptions
    ).catchError(catchFlutterSecureStorageError);
    _setClient(authClient);
  }

  void logout(Client client) async {
    const secureStorage = FlutterSecureStorage();
    await secureStorage.delete(
        key: secure_storage_constants.credentialKey,
        iOptions: secure_storage_constants.iOSOptions
    ).catchError(catchFlutterSecureStorageError);
    _setClient(client);
  }

  static late final _logger = Logger('App.ClientManager');

  static String? catchFlutterSecureStorageError(dynamic error){
    _logger.severe('Error while reading secureStorage', error);
    return null;
    //TODO: the error should be shown to the user before continuing. Maybe add a Handler in ClientProvider?
  }
}

class ClientProvider extends InheritedNotifier<ClientManager> {
  ClientProvider({Key? key, required Widget child})
      : super(key: key, child: child, notifier: clientManager);

  static void depend(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ClientProvider>();
}
