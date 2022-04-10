import 'dart:async';
import 'package:flutter/material.dart';
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
        clientManager.logout(Client());
        _logger.severe('Received error while logging out', error);
      } finally {
        Navigator.pop(context);
      }
    });
  }

  Future<Client> _logout(AuthorizedClient client) async {
    final appAuth = FlutterAppAuth();
    /* Fun fact: The application (clientId) registered to the Shibboleth identity server
     * is set up not to support ending the session, but the official application
     * still tries to do it. If you try to log out the application
     * briefly shows a Custom Tab and then closes it. Disabling the connection
     * while the page is loading will stop the application from automatically closing it
     * and leave you the time to see that the request is Unsupported.
     * The code is here because this might be needed in the future, but
     * right now it's useless, even if the official app still does the same request*/
    /*await appAuth.endSession(
        EndSessionRequest(
            idTokenHint: client.credentials.idToken,
            postLogoutRedirectUrl: OpenIDConstants.logoutRedirectUri,
            discoveryUrl: OpenIDConstants.discoveryUrl
        )
    );*/
    //TODO: Maybe wrap in a try{}
    await appAuth.endSession(
        EndSessionRequest(discoveryUrl: OpenIDConstants.discoveryUrl)
    );
    return Client.fromClient(client);
  }
}
