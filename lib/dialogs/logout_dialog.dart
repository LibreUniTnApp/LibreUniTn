import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:libreunitn/API/api.dart';
import 'package:libreunitn/providers/client/client_provider.dart';
import 'package:libreunitn/providers/client/client_manager.dart';
import './circular_progress_dialog.dart';

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
    _logoutFuture ??= Future(() async {
      try {
        final client = await _logout(clientManager.client!.forceDowncast());
        clientManager.logout(client);
      } catch (error) {
        //clientManager.logout(Client());
        _logger.severe('Received error while logging out', error);
      } finally {
        Navigator.pop(context);
      }
    });
  }

  Future<Client> _logout(AuthorizedClient client) async {
    final appAuth = FlutterAppAuth();
    try {
      //TODO: add Securely Randomly generated state
      await appAuth.endSession(
          EndSessionRequest(
              idTokenHint: client.credentials.idToken,
              postLogoutRedirectUrl: OpenIDConstants.logoutRedirectUri,
              discoveryUrl: OpenIDConstants.discoveryUrl
          )
      );
    } on PlatformException catch (error) {
      /* Apparently, the first request might fail even on the official application.
       * If the user or something else quits the Custom Tab in a failed state,
       * we try again, as the second request might (and probably will) succeed. */
      //If error.message contains 'User cancelled flow', then it is the user who closed the Custom Tab
      if(error.code == 'end_session_failed'){
        await appAuth.endSession(
            EndSessionRequest(
                idTokenHint: client.credentials.idToken,
                postLogoutRedirectUrl: OpenIDConstants.logoutRedirectUri,
                discoveryUrl: OpenIDConstants.discoveryUrl
            )
        );
      } else {
        //Bubble up the error if it's not what we expected
        rethrow;
      }
    }
    return Client.fromClient(client);
  }
}
