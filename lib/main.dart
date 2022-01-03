import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './providers/client_provider.dart';
import './providers/invocation_uri.dart';
import './navigation_drawer.dart';
import './themes.dart' as themes;

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'LibreUniTn',
      theme: themes.lightTheme,
      home: ClientProvider(child: const Main()));
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ClientProvider.depend(context);
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: clientManager.client != null
              ? InvocationUriProvider(
                  child: (context) => Text(
                      InvocationUriProvider.getInvocationUri(context) ??
                          'NULL'),
                )
              : const CircularProgressIndicator(),
        ),
        drawer: const NavigationDrawer());
  }
}
