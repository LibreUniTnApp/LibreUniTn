import 'package:flutter/material.dart';

class CircularProgressDialog extends StatelessWidget {
  final String text;

  const CircularProgressDialog({Key? key, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Dialog(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              const CircularProgressIndicator(),
              Text(text, style: Theme.of(context).textTheme.headline6)
            ],
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )));
}
