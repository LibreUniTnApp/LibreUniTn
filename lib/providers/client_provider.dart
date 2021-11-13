import 'dart:async';
import 'dart:convert' show jsonDecode;
import 'package:flutter/foundation.dart' show ValueNotifier, Key;
import 'package:flutter/widgets.dart'
    show InheritedNotifier, Widget, BuildContext;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:openid_client/openid_client.dart' show Credential;
import 'package:http/http.dart' as http show Client;
import 'package:libreunitrentoapp/API/client.dart';
import 'package:libreunitrentoapp/API/authorized_client.dart';
import 'package:libreunitrentoapp/secure_storage_constants.dart'
    as secure_storage_constants;

late final clientNotifier = ClientNotifier._fromSecureStorage();

class ClientNotifier extends ValueNotifier<Client?> {
  factory ClientNotifier._fromSecureStorage() {
    final notifier = ClientNotifier._(null);
    Future(() async {
      const secureStorage = FlutterSecureStorage();
      final credentialJson = await secureStorage.read(
          key: secure_storage_constants.credentialKey,
          iOptions: secure_storage_constants.iOSOptions);
      late Client client;
      if (credentialJson != null) {
        final credential = Credential.fromJson(jsonDecode(credentialJson));
        client = AuthorizedClient(http.Client(), credential);
      } else {
        client = Client();
      }
      notifier._setClient(client);
    });
    return notifier;
  }

  ClientNotifier._(Client? client) : super(client);

  Client? get client => super.value;

  void _setClient(Client client) {
    super.value = client;
    notifyListeners();
  }

  void login(AuthorizedClient authClient) => _setClient(authClient);

  void logout(Client client) => _setClient(client);
}

class ClientProvider extends InheritedNotifier<ClientNotifier> {
  ClientProvider({Key? key, required Widget child})
      : super(key: key, child: child, notifier: clientNotifier);

  static void depend(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ClientProvider>();
}
