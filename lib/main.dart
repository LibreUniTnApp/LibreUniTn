import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libreunitrentoapp/API/authorized_client.dart';
import './providers/client_provider.dart';
import './providers/invocation_uri.dart';
import './dialogs/login_dialog.dart';
import './themes.dart' as themes;

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'LibreUniTn',
        theme: themes.lightTheme,
        home: ClientProvider(child: (_) => const Main()),
      );
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: InvocationUriProvider(
            child: (cntxt) =>
                Text(InvocationUriProvider.getInvocationUri(cntxt) ?? 'NULL'),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text('Login'),
                  onTap: () async {
                    final authClient = await showDialog<AuthorizedClient>(
                        context: context,
                        builder: (cntxt) => const LoginDialog(),
                        barrierDismissible: false);
                    if (authClient != null) {
                      ClientProvider.login(context, authClient);
                    }
                  })
            ],
          ),
        ),
      );
}
