import 'package:flutter/foundation.dart' show Key;
import 'package:flutter/widgets.dart';
import 'package:libreunitrentoapp/API/client.dart';
import 'package:libreunitrentoapp/API/authorized_client.dart';

class ClientProvider extends StatefulWidget {
  const ClientProvider({Key? key, required this.child}) : super(key: key);

  final WidgetBuilder child;

  @override
  State<ClientProvider> createState() => _ClientProviderState();

  static Client getClient(BuildContext cntxt) =>
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
  static late Client _client = Client();

  @override
  Widget build(BuildContext cntxt) =>
      _ClientInherited(client: _client, child: Builder(builder: widget.child));

  void _setClient(Client client) => setState(() => _client = client);
}

class _ClientInherited extends InheritedWidget {
  @override
  const _ClientInherited(
      {Key? key, required Widget child, required this.client})
      : super(key: key, child: child);

  final Client client;

  @override
  bool updateShouldNotify(covariant _ClientInherited oldWidget) =>
      oldWidget.client != client;

  static _ClientInherited of(BuildContext cntxt) =>
      cntxt.dependOnInheritedWidgetOfExactType<_ClientInherited>()!;
}
