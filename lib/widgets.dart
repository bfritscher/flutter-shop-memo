import 'package:flutter/material.dart';

class PrimaryBlockButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const PrimaryBlockButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            minimumSize: const Size(double.infinity, 50)
            ),
        onPressed: onPressed,
        child: Text(text,
            style:
                TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
    );
  }
}
