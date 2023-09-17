import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailSnapScreen extends StatelessWidget {
  final String id;
  final dynamic data;
  const DetailSnapScreen({super.key, required this.id, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: () {
              context.go('/');
            },
            color: Theme.of(context).colorScheme.onPrimary),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('snaps')
              .doc(id)
              .snapshots(),
          builder: (context, snapshot) {
            var data = snapshot.data ?? this.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          data?.get('title').toString() ?? '',
                          style: GoogleFonts.anton(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Hero(
                      tag: id,
                      child: data != null
                          ? AnimatedContainerDemo(
                              child: Image.network(data.get('url').toString(),
                                  fit: BoxFit.contain))
                          : Container()),
                )
              ],
            );
          }),
    );
  }
}

const _duration = Duration(milliseconds: 400);

double randomBorderRadius() {
  return Random().nextDouble() * 128;
}

double randomMargin() {
  return Random().nextDouble() * 64;
}

Color randomColor() {
  return Color(0xFFFFFFFF & Random().nextInt(0xFFFFFFFF));
}

class AnimatedContainerDemo extends StatefulWidget {
  final Widget child;
  const AnimatedContainerDemo({super.key, required this.child});

  @override
  State<AnimatedContainerDemo> createState() => _AnimatedContainerDemoState();
}

class _AnimatedContainerDemoState extends State<AnimatedContainerDemo> {
  late Color color;
  late double borderRadius;
  late double margin;

  @override
  void initState() {
    super.initState();
    color = randomColor();
    borderRadius = randomBorderRadius();
    margin = randomMargin();
  }

  void change() {
    setState(() {
      color = randomColor();
      borderRadius = randomBorderRadius();
      margin = randomMargin();
    });
  }

  @override
  Widget build(BuildContext context) {
    change();
    return GestureDetector(
      onTap: () => change(),
      child: AnimatedContainer(
        decoration: BoxDecoration(
          color: color,
        ),
        duration: _duration,
        curve: Curves.easeInOut,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              margin: EdgeInsets.all(margin),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              duration: _duration,
              curve: Curves.easeInOut,
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}
