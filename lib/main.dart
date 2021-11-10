import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openid_client/openid_client.dart' show Client;
import './invocation_uri.dart' show getInvocationUriString;
import './auth.dart' as auth;
import './themes.dart' as themes;

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LibreUniTn',
      theme: themes.lightTheme,
      home: const Main(),
    );
  }
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext cntxt) {
    return Scaffold(
      appBar: AppBar(),
        body: Center(
            child: FutureBuilder(
      future: auth.getClient(),
      builder: (cntxt, client) {
        if (client.hasData) {
          return Text(auth.getAuthorizationFlow(client.data! as Client).authenticationUri.toString());
        } else {
          return Text(client.toString());
        }
      },
    )));
  }
}
