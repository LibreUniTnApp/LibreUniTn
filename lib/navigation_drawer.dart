import 'package:flutter/material.dart';
import './providers/client_provider.dart';
import './API/authorized_client.dart';
import './dialogs/login_dialog.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(child: LayoutBuilder(
        builder: (context, layout) {
          final client = ClientProvider.getClient(context);
          final headerHeight = layout.maxHeight / 5;
          return Column(
            children: [
              SizedBox(
                  height: headerHeight,
                  child: FlexibleSpaceBar.createSettings(
                    currentExtent: headerHeight,
                    child: FlexibleSpaceBar(
                      background: Builder(
                          builder: (context) => Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Theme.of(context).colorScheme.primary,
                              )),
                    ),
                  )),
              if(client != null) ListTile(
                title: Text(client is AuthorizedClient ? "Logout" : "Login"),
                onTap: client is AuthorizedClient
                    ? () => _showLogoutDialog(context)
                    : () => _showLoginDialog(context),
              )
            ],
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
          );
        },
      ));

  void _showLoginDialog(BuildContext context) async {
    Navigator.pop(context);
    await showDialog(
        context: context,
        builder: (context) => ClientProvider(child: (_) => const LoginDialog()),
        barrierDismissible: false);
  }

  void _showLogoutDialog(BuildContext context) async {
    Navigator.pop(context);
    //TODO: spawn LogoutDialog
    /*
    await showDialog(
        context: context,
        builder: (context) => ClientProvider(child: (_) => const LoginDialog()),
        barrierDismissible: false);
    */
    throw UnimplementedError("Logout not yet implemented");
  }
}
