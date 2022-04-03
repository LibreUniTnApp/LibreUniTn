import 'package:flutter/foundation.dart' show Key;
import 'package:flutter/widgets.dart'
    show InheritedWidget, StatefulWidget, State, Widget, BuildContext;
import 'package:libreunitn/API/client.dart' show Client;
import './client_manager.dart' show ClientManager;

class ClientProvider extends StatefulWidget {
  final Widget child;

  const ClientProvider({Key? key, required this.child})
      : super(key: key);

  @override
  _ClientProviderState createState() => _ClientProviderState();

  static ClientManager? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ClientInherited>()?._manager;

  //TODO: Maybe throw a custom error in case maybeOf returns null??
  static ClientManager of(BuildContext context) => maybeOf(context)!;
}

class _ClientProviderState extends State<ClientProvider> {
  late final ClientManager _manager;

  _ClientProviderState(): super();

  @override
  void initState() {
    super.initState();
    //This should set it before build is called/before anything accesses the object
    _manager = ClientManager.fromSecureStorage(setState);
  }

  @override
  Widget build(BuildContext context) => _ClientInherited(
    child: widget.child,
    manager: _manager,
  );
}

class _ClientInherited extends InheritedWidget {
  final ClientManager _manager;
  late final Client? _clientPtr;

  _ClientInherited({
    Key? key,
    required Widget child,
    required ClientManager manager,
  }): _manager = manager, super(key: key, child: child) {
    _clientPtr = _manager.client;
  }

  @override
  bool updateShouldNotify(_ClientInherited oldWidget) =>
      _clientPtr != oldWidget._clientPtr;
}