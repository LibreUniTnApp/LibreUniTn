# LibreUniTn

Free and Open Source Reimplementation of UniTnApp

## Contributing
Currently, only the login and logout flow are implemented and mostly working, help is needed not only to implement other features, but also to improve comments, logging, tests, documentation

If you want to signal a problem or talk about a feature, just open an issue. If you want to send in a patch, fork the repo, commit your changes and then open a pull request. Both English and Italian are accepted

I plan to set up a `git-send-email` server in order to receive "anonymous" (not connected to a GitHub account) pull request, but for right now, you can commit to your fork changing `user.name` and `user.email` using `git config user.name` and `git config user.name`, therefore changing what will be added to the repository's history.

## [Help Reverse Engineering](./REVENG.md)

# Building
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter build <your-target>
```
