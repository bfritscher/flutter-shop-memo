import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class DetailSnapScreen extends StatelessWidget {
  final String id;
  final dynamic data;
  const DetailSnapScreen({super.key, required this.id, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed:() {
          context.go('/');
        } ,color: Theme.of(context).colorScheme.onPrimary),
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
              children: [
                Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        data?.get('title') ?? '',
                        style: GoogleFonts.anton(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Hero(
                        tag: id,
                        child: data != null
                            ? Image.network(data.get('url'), fit: BoxFit.contain)
                            : const Placeholder()),
                  ),
                )
              ],
            );
          }),
    );
  }
}
