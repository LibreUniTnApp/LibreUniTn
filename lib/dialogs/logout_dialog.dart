import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:libreunitrentoapp/API/authorized_client.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libreunitrentoapp/providers/client_provider.dart';
import 'package:libreunitrentoapp/providers/invocation_uri.dart';
import 'package:libreunitrentoapp/secure_storage_constants.dart'
    as secure_storage_constants;
import './circular_progress_dialog.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //This will be called only when client is AuthorizedClient
    final client = clientNotifier.client as AuthorizedClient;
    _scheduleLogoutFuture(context, client);
    return const CircularProgressDialog(text: 'Logging out...');
  }

  void _scheduleLogoutFuture(BuildContext context, AuthorizedClient client) {
    Future(() async {
      final logoutRequest = client.logout();
      if (logoutRequest.logoutUrl != null) {
        await url_launcher.launch(logoutRequest.logoutUrl.toString(),
            forceSafariVC: null, forceWebView: false);
        final response = await invocationUriStream.take(1).single;
        if (response != null) {
          final client = logoutRequest.respond(response);
          const secureStorage = FlutterSecureStorage();
          await secureStorage.delete(
              key: secure_storage_constants.credentialKey,
              iOptions: secure_storage_constants.iOSOptions);
          clientNotifier.logout(client);
        }
      }
      Navigator.pop(context);
    });
  }
}
