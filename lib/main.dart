import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart' show Logger, Level;
import 'package:logging/logging.dart' as logging;
import 'package:dart_json_mapper/dart_json_mapper.dart' show JsonMapper;
import 'package:libreunitn/main.mapper.g.dart';
import 'providers/client/client_provider.dart';
import './navigation_drawer.dart';
import './themes.dart' as themes;

late final Future<JsonMapper> jsonMapperInitialized = initializeJsonMapperAsync();

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  logging.hierarchicalLoggingEnabled = true;
  if(kReleaseMode){
    Logger('App').level = Level.SEVERE;
    Logger.root.onRecord.forEach(
            (event) => debugPrint("${event.time} [${event.loggerName}] ${event.level}: ${event.message}")
    );
  } else {
    Logger.root.level = Level.INFO;
    Logger('App').level = Level.ALL;
    Logger.root.onRecord.forEach(
            (event) {
          String message = "${event.time} [${event.loggerName}] ${event.level}: ${event.message}";
          if(event.error != null){
            message += " (${event.error})";
          }
          debugPrint(message);
        }
    );
  }
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /* final logger = Logger('App');
     * logger.finest(() => 'Building with theme $theme'); */
    return MaterialApp(
      title: 'LibreUniTn',
      theme: themes.lightTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('it', '')
      ],
      builder: (context, child) => ClientProvider(child: child),
      home: const Main()
    );
  }
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This call shouldn't be expensive
    final logger = Logger('App.MainScaffold');
    final clientManager = ClientProvider.of(context);
    logger.finest(
        () => 'Rebuilding with client of type ${clientManager.client?.runtimeType.toString() ?? 'null'}'
    );
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: clientManager.client != null
            ? Text(clientManager.client.runtimeType.toString())
            : const CircularProgressIndicator(),
      ),
      drawer: clientManager.client != null ? const NavigationDrawer() : null,
    );
  }
}
