import 'dart:async';

import 'package:flutter/services.dart' show EventChannel;
import 'package:flutter/widgets.dart';

const _channel = EventChannel("xyz.libreunitn.invocationUri");
late final Stream<String?> invocationUriStream =
    _channel.receiveBroadcastStream().cast<String?>();

class InvocationUriProvider extends StatefulWidget {
  const InvocationUriProvider({Key? key, required this.child})
      : super(key: key);

  final WidgetBuilder child;

  @override
  State<InvocationUriProvider> createState() => _InvocationUriProviderState();

  static String? getInvocationUri(BuildContext cntxt) => cntxt
      .dependOnInheritedWidgetOfExactType<_InvocationUriInherited>()!
      .invocationUri;
}

class _InvocationUriProviderState extends State<InvocationUriProvider> {
  String? invocationUri;
  late final StreamSubscription<String?> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = invocationUriStream.listen(
      (invocationUri) => setState(() => this.invocationUri = invocationUri));
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext cntxt) => _InvocationUriInherited(
      child: Builder(builder: widget.child), invocationUri: invocationUri);
}

class _InvocationUriInherited extends InheritedWidget {
  const _InvocationUriInherited(
      {Key? key, required child, required this.invocationUri})
      : super(key: key, child: child);

  final String? invocationUri;

  @override
  bool updateShouldNotify(covariant _InvocationUriInherited oldWidget) =>
      oldWidget.invocationUri != invocationUri;
}
