import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libreunitn/providers/client/client_manager.dart';
import 'package:logging/logging.dart';
import 'package:libreunitn/providers/client/client_provider.dart';
import './circular_progress_dialog.dart';

class LoginDialog extends StatefulWidget {

  const LoginDialog({Key? key}) : super(key: key);

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  late final Logger _logger = Logger('App.LoginDialog');

  Future? _loginFuture;

  @override
  Widget build(BuildContext context) {
    final clientManager = ClientProvider.of(context);

    //This will be called only if client is Client
    _logger.finest(() => 'client is ${clientManager.client?.runtimeType.toString() ?? 'null'}');
    _scheduleLoginFuture(context, clientManager);
    return CircularProgressDialog(
        text: Text(
            'Logging in...',
            style: Theme.of(context).textTheme.headline6
        )
    );
  }

  void _scheduleLoginFuture(
      BuildContext context,
      ClientManager clientManager
      ) {
    if(_loginFuture != null) {
      _loginFuture = Future(() async {
        try {
          final authClient = await (clientManager.client)!.login();
          clientManager.login(authClient);
        } catch (error) {
          _logger.severe('Received error(s) while logging in', error);
        } finally {
          Navigator.pop(context);
        }
      });
    }
  }
}
