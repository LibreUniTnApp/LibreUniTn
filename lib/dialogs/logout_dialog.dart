import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libreunitrentoapp/API/authorized_client.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:libreunitrentoapp/providers/client_provider.dart';
import 'package:libreunitrentoapp/providers/invocation_uri.dart';
import 'package:libreunitrentoapp/secure_storage_constants.dart'
    as secure_storage_constants;
import './circular_progress_dialog.dart';
import './constants.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //This will be called only when client is AuthorizedClient
    final logger = Logger('App.LogoutDialog');
    logger.finest(() => 'client is ${clientManager.client?.runtimeType?.toString() ?? 'null'}');
    final client = clientManager.client as AuthorizedClient;
    _scheduleLogoutFuture(context, client, logger);
    return CircularProgressDialog(text: Text('Logging out...', style: Theme.of(context).textTheme.headline6));
  }

  void _scheduleLogoutFuture(
      BuildContext context,
      AuthorizedClient client,
      Logger logger
    ) {
    Future(() async {
      final logoutRequest = client.logout();
      logger.fine('LogoutURL is ${logoutRequest.logoutUrl?.toString() ?? 'null'}');
      if (logoutRequest.logoutUrl != null) {
        launch(
            logoutRequest.logoutUrl.toString(),
            customTabsOption: customTabOptions
        );
        final response = await invocationUriStream.take(1).single;
        logger.fine('LogoutRequest response is ${response ?? 'null'}');
        if (response != null) {
          final client = logoutRequest.respond(response);
          const secureStorage = FlutterSecureStorage();
          await secureStorage.delete(
              key: secure_storage_constants.credentialKey,
              iOptions: secure_storage_constants.iOSOptions
          );
          clientManager.logout(client);
          logger.info('Succesfully Logged out');
        }
      }
      Navigator.pop(context);
    });
  }
}
