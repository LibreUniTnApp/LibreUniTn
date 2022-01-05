import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:libreunitn/API/authorized_client.dart';
import 'package:libreunitn/API/client.dart';
import 'package:libreunitn/providers/client_provider.dart';
import 'package:libreunitn/providers/invocation_uri.dart';
import './circular_progress_dialog.dart';
import './utils.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //This will be called only when client is AuthorizedClient
    final logger = Logger('App.LogoutDialog');
    logger.finest(() => 'client is ${clientManager.client?.runtimeType.toString() ?? 'null'}');
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
      try {
        final logoutRequest = client.logout();
        logger.fine('LogoutURL is ${logoutRequest.logoutUrl?.toString() ?? 'null'}');
        if (logoutRequest.logoutUrl != null) {
          launch(logoutRequest.logoutUrl.toString());
          final response = await invocationUriStream.take(1).single;
          logger.fine('LogoutRequest response is ${response ?? 'null'}');
          if (response != null) {
            final client = logoutRequest.respond(Uri.parse(response));
            clientManager.logout(client);
            logger.info('Successfully Logged out');
          }
        } else {
          clientManager.logout(Client());
        }
      } catch (error) {
        logger.severe('Received error while logging out', error);
      } finally {
        Navigator.pop(context);
      }
    });
  }
}
