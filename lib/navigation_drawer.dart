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
      Drawer(child: LayoutBuilder(builder: (context, layout) {
        ClientProvider.depend(context);
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
                            child: clientNotifier.client is AuthorizedClient
                                ? FutureBuilder<UserInfo>(
                                    future: (clientNotifier.client
                                            as AuthorizedClient)
                                        .credentials
                                        .getUserInfo(),
                                    builder: (context, userInfoFuture) {
                                      if (userInfoFuture.hasData &&
                                          userInfoFuture.data!.name != null) {
                                        return Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Text(
                                              userInfoFuture.data!.name!,
                                              style: Theme.of(context).textTheme.headline6,
                                          ));
                                      }
                                      return Container();
                                    })
                                : null)),
                  ),
                )),
            if (clientNotifier.client != null)
              ListTile(
                title: Text(clientNotifier.client is AuthorizedClient
                    ? "Logout"
                    : "Login"),
                onTap: clientNotifier.client is AuthorizedClient
                    ? () => _showLogoutDialog(context)
                    : () => _showLoginDialog(context),
              )
          ],
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
        );
      }));

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
