import 'dart:ui' show Locale;
import 'package:flutter/foundation.dart' show Key;
import 'package:flutter/widgets.dart'
    show InheritedWidget, StatefulWidget, State, Widget, BuildContext, WidgetsBinding;
import 'package:logging/logging.dart';

class LanguageProvider extends StatefulWidget {
  final Widget child;

  const LanguageProvider({Key? key, required this.child})
      : super(key: key);

  @override
  _LanguageProviderState createState() => _LanguageProviderState();

  static Locale? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_LanguageInherited>()
          ?.currentLocale;

  //TODO: Maybe throw a custom error in case maybeOf returns null??
  static Locale of(BuildContext context) => maybeOf(context)!;
}

class _LanguageProviderState extends State<LanguageProvider> {
  late final _logger = Logger('LanguageProvider');

  Locale? _locale;

  _LanguageProviderState(): super();

  @override
  void initState() {
    super.initState();
    _scheduleLanguageResolvingFuture();
  }

  @override
  Widget build(BuildContext context) => _LanguageInherited(
    child: widget.child,
    currentLocale: _locale,
  );

  void _scheduleLanguageResolvingFuture() {
    Future(() async {
      setState(() => _locale = WidgetsBinding.instance!.window.locale);
    });
  }
}

class _LanguageInherited extends InheritedWidget {
  final Locale? currentLocale;

  const _LanguageInherited({
    Key? key,
    required Widget child,
    required this.currentLocale,
  }): super(key: key, child: child);

  @override
  bool updateShouldNotify(_LanguageInherited oldWidget) =>
      oldWidget.currentLocale != currentLocale;
}
