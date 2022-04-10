import 'package:flutter/foundation.dart' show Key;
import 'package:flutter/widgets.dart'
    show InheritedWidget, StatefulWidget, State, Widget, BuildContext, WidgetsBinding;
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
    _manager = ClientManager.fromSecureStorage(
        setState,
        _ClientProviderState._getLanguageCodeOfCurrentLocale
    );
  }

  @override
  Widget build(BuildContext context) => _ClientInherited(
    child: widget.child,
    manager: _manager,
  );

  static String _getLanguageCodeOfCurrentLocale() {
    /* The instance should have been built during runApp(),
     * so it is to be considered non-null during most of the Application's lifetime,
     * including here.
     * We get the locale the same way WidgetsApp does, without listening for
     * changes, as we do not care about them.
     * This should be called only once, during the first launch, when
     * there couldn't possibly be a language set in the Application's settings.
     * We do it here and not in ClientManager as it follows the separation of concerns rule */
    final locale = WidgetsBinding.instance!.window.locale;
    return locale.languageCode;
  }
}

class _ClientInherited extends InheritedWidget {
  final ClientManager _manager;
  //TODO: Dart should stabilize WeakRef, for now Expando is the only thing that exposes a similar API
  /* When _weakClientRef is null, then _manager.client is null too,
   * otherwise _weakClientRef[client] returns true.
   * If _manager.client changes (because we logged in
   * and the old Client instance got dropped), then _weakClientRef won't
   * keep it alive and it will be collected by the GC as soon as possible.
   * When the key is dropped, then the value is deleted too.
   * The idea is that, if this were a Client?, then it wouldn't be dropped
   * as soon as we change the type and we would have a moment where the two clients
   * are both in memory with at least a reference each. With a Weak Reference,
   * we can drop it before */
  late final Expando<bool>? _weakClientRef;

  _ClientInherited({
    Key? key,
    required Widget child,
    required ClientManager manager,
  }): _manager = manager, super(key: key, child: child) {
    if(_manager.client != null){
      _weakClientRef = Expando();
      _weakClientRef![_manager.client!] = true;
    } else {
      _weakClientRef = null;
    }
  }

  @override
  bool updateShouldNotify(_ClientInherited oldWidget) {
    final bool oldWasNull = oldWidget._weakClientRef == null;
    final bool newIsNull = _manager.client == null;
    if(!oldWasNull && !newIsNull) {
      /* If the new client is the same as the old one, then _weakClientRef will return true
       * Otherwise, we haven't registered it to the old Expando and it will return null */
      final isSameAsOldClient = oldWidget._weakClientRef![_manager.client!] ?? false;
      return !isSameAsOldClient;
    } else {
      /* Theoretically, the only other case that might happen is that
       * the old is null and the new is not. In that case, the first clause
       * of the || is true and, since the logical operators are short circuiting,
       * true will be returned immediately.
       * The other case is added for safety */
      return (oldWasNull && !newIsNull) || (!oldWasNull && newIsNull);
    }
  }
}