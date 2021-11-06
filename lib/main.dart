import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './invocation_uri.dart' show getInvocationUriString;
import './oauth.dart';
import './themes.dart' as Themes;

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
      title: 'Flutter Demo',
      theme: Themes.lightTheme,
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
