import 'dart:async';
import 'dart:convert' show jsonEncode;
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libreunitrentoapp/API/client.dart';
import 'package:libreunitrentoapp/providers/client_provider.dart';
import 'package:libreunitrentoapp/providers/invocation_uri.dart';
import 'package:libreunitrentoapp/secure_storage_constants.dart'
    as secure_storage_constants;
import './circular_progress_dialog.dart';
import './constants.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //This will be called only if client is Client
    final client = clientManager.client as Client;
    _scheduleLoginFuture(context, client);
    return CircularProgressDialog(text: Text('Logging in...', style: Theme.of(context).textTheme.headline6));
  }

  Future<void> _scheduleLoginFuture(BuildContext context, Client client) => 
    Future(() async {
      final loginRequest = await client.login();
      launch(loginRequest.authenticationUri.toString(),
        customTabsOption: customTabOptions,
        safariVCOption: safariViewControllerOptions
      );
      final response = await invocationUriStream.take(1).single;
      if (response != null) {
        final authClient =
            await loginRequest.respondWithCustomUri(Uri.parse(response));
        const secureStorage = FlutterSecureStorage();
        await secureStorage.write(
            key: secure_storage_constants.credentialKey,
            value: jsonEncode(authClient.credential.toJson()),
            iOptions: secure_storage_constants.iOSOptions,
            aOptions: secure_storage_constants.androidOptions
        );
        clientManager.login(authClient);
      }
      Navigator.pop(context);
    });
}
