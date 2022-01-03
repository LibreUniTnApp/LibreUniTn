import 'package:flutter/material.dart';
import 'package:openid_client/openid_client.dart' show UserInfo;
import './providers/client_provider.dart';
import './API/authorized_client.dart';
import './dialogs/login_dialog.dart';
import './dialogs/logout_dialog.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
    Drawer(
      child: LayoutBuilder(
        builder: (context, layout) {
          ClientProvider.depend(context);
          final headerHeight = layout.maxHeight / 5;
          return Column(
            children: [
              DrawerHeader(headerHeight: headerHeight),
              if (clientManager.client != null)
                ListTile(
                  title: Text(clientManager.client is AuthorizedClient
                      ? "Logout"
                      : "Login"),
                  onTap: clientManager.client is AuthorizedClient
                      ? () => _showLogoutDialog(context)
                      : () => _showLoginDialog(context),
                )
            ],
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
          );
        }
      )
    );

  void _showLoginDialog(BuildContext context) async {
    Navigator.pop(context);
    await showDialog(
        context: context,
        builder: (context) => const LoginDialog(),
        barrierDismissible: false);
  }

  void _showLogoutDialog(BuildContext context) async {
    Navigator.pop(context);
    await showDialog(
        context: context,
        builder: (context) => const LogoutDialog(),
        barrierDismissible: false);
  }
}

class DrawerHeader extends StatelessWidget {
  final double headerHeight;

  const DrawerHeader({Key? key, required this.headerHeight}): super(key: key);

  @override
  Widget build(BuildContext context) {
    ClientProvider.depend(context);

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