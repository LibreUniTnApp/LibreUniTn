import 'dart:async';
import 'dart:convert' show jsonEncode;
import 'dart:ui' show VoidCallback;
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libreunitrentoapp/API/client.dart';
import 'package:libreunitrentoapp/providers/client_pubsub.dart';
import 'package:libreunitrentoapp/providers/invocation_uri.dart';
import 'package:libreunitrentoapp/secure_storage_constants.dart'
    as secure_storage_constants;
import './circular_progress_dialog.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = clientNotifier.client;
    if (client != null) {
      _scheduleLoginFuture(context, client);
    } else {
      late final VoidCallback onClientChange;
      onClientChange = () {
        final client = clientNotifier.client;
        if (client != null) {
          clientNotifier.removeListener(onClientChange);
          _scheduleLoginFuture(context, client);
        }
      };
      clientNotifier.addListener(onClientChange);
    }
    return const CircularProgressDialog(text: 'Logging in...');
  }

  void _scheduleLoginFuture(BuildContext context, Client client) {
    Future(() async {
      final loginRequest = await client.login();
      url_launcher.launch(loginRequest.authenticationUri.toString());
      final response = await invocationUriStream.take(1).single;
      if (response != null) {
        final authClient =
            await loginRequest.respondWithCustomUri(Uri.parse(response));
        const secureStorage = FlutterSecureStorage();
        await secureStorage.write(
            key: secure_storage_constants.credentialKey,
            value: jsonEncode(authClient.credentials.toJson()),
            iOptions: secure_storage_constants.iOSOptions);
        clientNotifier.login(authClient);
      }
      Navigator.pop(context);
    });
  }
}
