import 'dart:convert' show jsonDecode;
import 'package:flutter/foundation.dart' show Key;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:openid_client/openid_client.dart' show Credential;
import 'package:http/http.dart' as http show Client;
import 'package:libreunitrentoapp/API/client.dart';
import 'package:libreunitrentoapp/API/authorized_client.dart';
import 'package:libreunitrentoapp/secure_storage_constants.dart'
    as secure_storage_constants;

class ClientProvider extends StatefulWidget {
  const ClientProvider({Key? key, required this.child}) : super(key: key);

  final WidgetBuilder child;

  @override
  State<ClientProvider> createState() => _ClientProviderState();

  static Client? getClient(BuildContext cntxt) =>
      _ClientInherited.of(cntxt).client;

  static void _setClient(BuildContext cntxt, Client client) =>
      cntxt.findAncestorStateOfType<_ClientProviderState>()!._setClient(client);

  static void login(BuildContext cntxt, AuthorizedClient authClient) =>
      _setClient(cntxt, authClient);

  static void logout(BuildContext cntxt, Client client) =>
      _setClient(cntxt, client);
}

class _ClientProviderState extends State<ClientProvider> {
  //TODO: Check whether FlutterSecureStorage has credentials and return AuthorizedClient if that's the case, otherwise just create normal client
  static Client? _client;

  @override
  void initState() {
    super.initState();
    _initClient();
  }

  @override
  Widget build(BuildContext cntxt) => _ClientInherited(client: _client, child: Builder(builder: widget.child));

  void _setClient(Client client) => setState(() => _client = client);
  void _initClient() async {
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
    setState(() => _client = client);
  }
}

class _ClientInherited extends InheritedWidget {
  @override
  const _ClientInherited(
      {Key? key, required Widget child, required this.client})
      : super(key: key, child: child);

  final Client? client;

  @override
  bool updateShouldNotify(covariant _ClientInherited oldWidget) =>
      oldWidget.client != client;

  static _ClientInherited of(BuildContext cntxt) =>
      cntxt.dependOnInheritedWidgetOfExactType<_ClientInherited>()!;
}
