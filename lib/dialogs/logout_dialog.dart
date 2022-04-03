import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:libreunitn/API/authorized_client.dart';
import 'package:libreunitn/API/client.dart';
import 'package:libreunitn/providers/client/client_provider.dart';
import 'package:libreunitn/providers/client/client_manager.dart';
import 'package:libreunitn/providers/invocation_uri.dart';
import './circular_progress_dialog.dart';
import './utils.dart';

class LogoutDialog extends StatefulWidget {

  const LogoutDialog({Key? key}) : super(key: key);

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  late final Logger _logger = Logger('App.LogoutDialog');

  Future? _logoutFuture;

  @override
  Widget build(BuildContext context) {
    final clientManager = ClientProvider.of(context);
    _logger.finest(() => 'client is ${clientManager.client?.runtimeType.toString() ?? 'null'}');

    //This will be called only when client is AuthorizedClient
    _scheduleLogoutFuture(context, clientManager);
    return CircularProgressDialog(
        text: Text(
            'Logging out...',
            style: Theme.of(context).textTheme.headline6
        )
    );
  }

  void _scheduleLogoutFuture(
      BuildContext context,
      ClientManager clientManager
    ) {
    if(_logoutFuture != null) {
      _logoutFuture = Future(() async {
        try {
          final logoutRequest = (clientManager.client as AuthorizedClient)
              .logout();
          _logger.fine(
              'LogoutURL is ${logoutRequest.logoutUrl?.toString() ?? 'null'}');
          if (logoutRequest.logoutUrl != null) {
            launch(logoutRequest.logoutUrl.toString());
            final response = await invocationUriStream
                .take(1)
                .single;
            _logger.fine('LogoutRequest response is ${response ?? 'null'}');
            if (response != null) {
              final client = logoutRequest.respond(Uri.parse(response));
              clientManager.logout(client);
              _logger.info('Successfully Logged out');
            }
          } else {
            clientManager.logout(Client());
          }
        } catch (error) {
          _logger.severe('Received error while logging out', error);
        } finally {
          Navigator.pop(context);
        }
      });
    }
  }
}
