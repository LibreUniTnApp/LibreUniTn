import 'package:flutter/material.dart';
import 'package:openid_client/openid_client.dart' show UserInfo;
import 'package:logging/logging.dart';
import 'providers/client/client_provider.dart';
import './API/authorized_client.dart';
import './dialogs/login_dialog.dart';
import './dialogs/logout_dialog.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logger = Logger('App.MainScaffold.Drawer');
    return Drawer(
        child: LayoutBuilder(
            builder: (context, layout) {
              final clientManager = ClientProvider.of(context);
              logger.finest(
                  () => 'Building with client ${clientManager.client?.runtimeType.toString() ?? 'null'}'
              );

              final headerHeight = layout.maxHeight / 5;
              logger.finer('Building with headerHeight $headerHeight');

              return Column(
                children: [
                  DrawerHeader(headerHeight: headerHeight),
                  if (clientManager.client != null)
                    clientManager.client is AuthorizedClient ? _logoutTile(
                        context) : _loginTile(context)
                ],
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
              );
            }
        )
    );
  }

  ListTile _dialogTile(BuildContext context, String title, Widget dialog) => ListTile(
      title: Text(title),
      onTap: () async {
        Navigator.pop(context);
        await showDialog(
            context: context,
            builder: (context) => dialog,
            barrierDismissible: false
        );
      }
  );

  ListTile _loginTile(BuildContext context) => _dialogTile(
      context,
      "Login",
      const LoginDialog()
  );

  ListTile _logoutTile(BuildContext context) => _dialogTile(
      context,
      "Logout",
      const LogoutDialog()
  );
}

class DrawerHeader extends StatelessWidget {
  final double headerHeight;

  const DrawerHeader({Key? key, required this.headerHeight}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final logger = Logger('App.MainScaffold.Drawer.Header');
    final clientManager = ClientProvider.of(context);
    logger.finest(
            () => 'Building with client ${clientManager.client?.runtimeType.toString() ?? 'null'}'
    );

    Widget? userNameWidget;
    if(clientManager.client is AuthorizedClient){
      userNameWidget = FutureBuilder<UserInfo>(
        future: (clientManager.client as AuthorizedClient)
            .credential
            .getUserInfo(),
        builder: (context, userInfoFuture) {
          if (userInfoFuture.hasData && userInfoFuture.data!.name != null) {
            return Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  userInfoFuture.data!.name!,
                  style: Theme.of(context).textTheme.headline6,
                )
            );
          } else {
            return Container();
          }
        }
      );
    }

    return SizedBox(
      height: headerHeight,
      child: FlexibleSpaceBar.createSettings(
        currentExtent: headerHeight,
        child: FlexibleSpaceBar(
          background: Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).colorScheme.primary,
            child: userNameWidget
          ),
        ),
      )
    );
  }
}