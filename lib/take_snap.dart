import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'widgets.dart';

class TakeSnapScreen extends StatelessWidget {
  const TakeSnapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Take Snap",
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      body: const TakeSnap(),
    );
  }
}

class TakeSnap extends StatefulWidget {
  const TakeSnap({Key? key}) : super(key: key);

  @override
  State<TakeSnap> createState() => _TakeSnapState();
}

class _TakeSnapState extends State<TakeSnap> {
  final picker = ImagePicker();
  File? _image;
  bool _isUploading = false;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
        _image = null;
      }
    });
  }

  Future uploadImage() async {
    setState(() {
      _isUploading = true;
    });

    final fileRef = 'snaps/${DateTime.now().millisecondsSinceEpoch}.png';
    final Reference storageReference =
        FirebaseStorage.instance.ref().child(fileRef);

    final UploadTask uploadTask = storageReference.putFile(_image!);

    await uploadTask.whenComplete(() => null);

    final imageUrl = await storageReference.getDownloadURL();

    FirebaseFirestore.instance.collection('snaps').add({
      'url': imageUrl,
      'fileRef': fileRef,
      'title': titleController.text,
      'expireAt': DateTime.now().add(const Duration(minutes: 5)),
      'createdAt': FieldValue.serverTimestamp(),
    });

    setState(() {
      _isUploading = false;
    });
  }

  final titleController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isUploading)
          Stack(alignment: Alignment.center, children: [
            Image.file(_image!),
            const SizedBox(
                height: 200, width: 200, child: CircularProgressIndicator()),
          ]),
        if (!_isUploading && _image == null)
          PrimaryBlockButton(onPressed: getImage, text: "Snap!"),
        if (!_isUploading && _image != null) ...[
          Expanded(child: Image.file(_image!)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
          ),
        ],
        PrimaryBlockButton(
          onPressed: _image != null
              ? () async {
                  await uploadImage();
                  if (context.mounted) {
                    context.go('/');
                    _image = null;
                  }
                }
              : null,
          text: 'Upload',
        )
      ],
    );
  }
}
