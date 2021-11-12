import 'dart:async';
import 'dart:convert' show jsonEncode;
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libreunitrentoapp/providers/client_provider.dart';
import 'package:libreunitrentoapp/providers/invocation_uri.dart';
import 'package:libreunitrentoapp/secure_storage_constants.dart'
    as secure_storage_constants;
import './circular_progress_dialog.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = ClientProvider.getClient(context);
    if (client != null) {
      Future.microtask(() async {
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
          ClientProvider.login(context, authClient);
        }
        Navigator.pop(context);
      });
    }
    return const CircularProgressDialog(text: 'Logging in...');
  }
}
