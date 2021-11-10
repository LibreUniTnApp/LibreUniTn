import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './invocation_uri.dart' show getInvocationUriString;
import './oauth/oauth.dart';
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
      body: Center(
        child: Text(getClient().toString())
      )
    );
  }
}
