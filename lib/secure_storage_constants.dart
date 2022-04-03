import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    show IOSOptions, AndroidOptions;

const iOSOptions = IOSOptions(accountName: 'libreunitn');
const androidOptions = AndroidOptions(
  encryptedSharedPreferences: true,
  resetOnError: false
);
//const webOptions =  WebOptions(dbName: 'libreunitn', publicKey: 'something')
const credentialKey = 'credentials';
