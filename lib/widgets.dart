import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                GoogleFonts.anton(color: Theme.of(context).colorScheme.onPrimary)),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: SizedBox(
                      width: double.infinity,
                      child: Center(
                          child: Text(
                        'Snap!',
                        style: GoogleFonts.anton(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ))),
                );
  }
}