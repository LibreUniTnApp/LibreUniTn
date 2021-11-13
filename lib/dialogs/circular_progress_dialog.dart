import 'package:flutter/material.dart';

class CircularProgressDialog extends StatelessWidget {
  final Widget text;

  const CircularProgressDialog({Key? key, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Dialog(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              const CircularProgressIndicator(),
              text
            ],
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )));
}
