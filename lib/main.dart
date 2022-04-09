import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart' show Logger, Level;
import 'package:logging/logging.dart' as logging;
import 'package:dart_json_mapper/dart_json_mapper.dart' show JsonMapper;
import 'package:libreunitn/main.mapper.g.dart';
import 'providers/client/client_provider.dart';
import './providers/invocation_uri.dart';
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
    return ClientProvider(
      child: MaterialApp(
          title: 'LibreUniTn',
          theme: themes.lightTheme,
          home: const Main()
      )
    );
  }
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /* Hopefully, this call is not expensive. It shouldn't be, as
     * the constructor caches objects by name,
     * but I'm not sure whether the lookup is cheap enough */
    final logger = Logger('App.MainScaffold');
    final clientManager = ClientProvider.of(context);
    logger.finest(
        () => 'Rebuilding with client of type ${clientManager.client?.runtimeType.toString() ?? 'null'}'
    );
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: clientManager.client != null
              ? InvocationUriProvider(
                  child: (context) {
                    String invocationUri = InvocationUriProvider.of(context) ?? 'NULL';
                    logger.finer('Received URI $invocationUri');
                    return Text(invocationUri);
                  },
                )
              : const CircularProgressIndicator(),
        ),
        drawer: const NavigationDrawer());
  }
}
