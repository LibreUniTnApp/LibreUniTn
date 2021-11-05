import 'package:flutter/services.dart' show MethodChannel;

const _channel = MethodChannel("xyz.libreunitn.invocationUri");

Future<String?> getInvocationUriString() async => _channel.invokeMethod<String>("getInvocationUriString");
