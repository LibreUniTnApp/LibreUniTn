import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:libreunitn/providers/client/client_manager.dart';
import 'package:libreunitn/providers/client/client_provider.dart';
import 'package:libreunitn/API/api.dart';
import './circular_progress_dialog.dart';

class LoginDialog extends StatefulWidget {

  const LoginDialog({Key? key}) : super(key: key);

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  late final Logger _logger = Logger('App.LoginDialog');
  late final ClientManager _manager;

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

  void _scheduleLoginFuture(BuildContext context, ClientManager clientManager) {
    _loginFuture ??= Future(() async {
      try {
        final authClient = await _login(clientManager.client!);
        clientManager.login(authClient);
      } catch (error) {
        _logger.severe('Received error(s) while logging in', error);
      } finally {
        Navigator.pop(context);
      }
    });
  }

  Future<AuthorizedClient> _login(Client client) async {
    final appAuth = FlutterAppAuth();
    //TODO: Maybe wrap in try{} to handle exceptions?
    final tokenResponse = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
            OpenIDConstants.clientId,
            OpenIDConstants.authorizationRedirectUri,
            clientSecret: OpenIDConstants.clientSecret,
            discoveryUrl: OpenIDConstants.discoveryUrl,
            scopes: OpenIDConstants.scopes
        )
    );
    if(tokenResponse != null){
      _logger.fine(()=>'Received $tokenResponse');
      final credentials = Credentials.fromTokenResponse(tokenResponse);
      return AuthorizedClient(client, credentials);
    } else {
      //TODO: Handle error
      throw "No Response";
    }
  }
}