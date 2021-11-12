import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:libreunitrentoapp/providers/client_provider.dart';
import 'package:libreunitrentoapp/providers/invocation_uri.dart';
import 'package:libreunitrentoapp/API/authorized_client.dart';
import './circular_progress_dialog.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ClientProvider(child: (context) {
        Future.microtask(() async {
          final loginRequest = await ClientProvider.getClient(context).login();
          url_launcher.launch(loginRequest.authenticationUri.toString());
          final response = await invocationUriStream.take(1).single;
          late final AuthorizedClient? authClient;
          if (response != null) {
            authClient =
                await loginRequest.respondWithCustomUri(Uri.parse(response));
          } else {
            authClient = null;
          }
          Navigator.pop<AuthorizedClient>(context, authClient);
        });
        return const CircularProgressDialog(text: 'Logging in...');
      });
}
