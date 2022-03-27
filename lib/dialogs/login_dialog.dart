import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:libreunitn/API/client.dart';
import 'package:libreunitn/providers/client/client_provider.dart';
import 'package:libreunitn/providers/invocation_uri.dart';
import './circular_progress_dialog.dart';
import './utils.dart';

//TODO: Depend on Inherited widget and schedule Future only once, maybe check whether login has been successful, show error message otherwise
class LoginDialog extends StatelessWidget {
  const LoginDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //This will be called only if client is Client
    final logger = Logger('App.LoginDialog');
    logger.finest(() => 'client is ${clientManager.client?.runtimeType.toString() ?? 'null'}');
    final client = clientManager.client as Client;
    _scheduleLoginFuture(context, client, logger);
    return CircularProgressDialog(text: Text('Logging in...', style: Theme.of(context).textTheme.headline6));
  }

  Future<void> _scheduleLoginFuture(BuildContext context, Client client, Logger logger) =>
    Future(() async {
      try {
        final loginRequest = await client.login();
        logger.fine('Created LoginRequest with authenticationUri ${loginRequest
            .authenticationUri}');
        launch(loginRequest.authenticationUri.toString());
        final response = await invocationUriStream
            .take(1)
            .single;
        logger.fine('LoginRequest Response is ${response ?? 'null'}');
        if (response != null) {
          final authClient =
          await loginRequest.respondWithCustomUri(Uri.parse(response));
          clientManager.login(authClient);
          logger.info('Successfully Logged in');
        }
      } catch (error) {
        logger.severe('Received error(s) while logging in', error);
      } finally {
        Navigator.pop(context);
      }
    });
}
