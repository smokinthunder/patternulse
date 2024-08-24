import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patternpulse/Data/Models/upload_model.dart';
import 'package:patternpulse/config/theme.dart';
import 'package:flutter/services.dart'; // For rootBundle

class UploadPageView extends StatefulWidget {
  const UploadPageView({super.key});

  @override
  State<UploadPageView> createState() => _UploadPageViewState();
}

class _UploadPageViewState extends State<UploadPageView> {
  late File _imageFile;
  final picker = ImagePicker();

  Future<Uint8List> _getImageBytes(File imageFile) async {
    final Uint8List byteData = await imageFile.readAsBytes();
    return byteData.buffer.asUint8List();
  }

  Future<String> uploadImageFirebase(
      String enteredName, Uint8List imageData) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('uploads/$enteredName.png');
      await storageRef.putData(
          imageData, SettableMetadata(contentType: 'image/png'));
      final downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      return "Image Not Uploaded";
    }
  }

  Future<void> uploadImageDataFirebase(
      bool isNormalKid, String enteredName, File imageFile) async {
    try {
      final imageData = await _getImageBytes(imageFile);
      final imageUrl = await uploadImageFirebase(enteredName, imageData);
      final uploadModel = UploadModel(
        name: enteredName,
        normal: isNormalKid,
        imageUrl: imageUrl,
      );

      await FirebaseFirestore.instance
          .collection('UploadsData')
          .doc(enteredName)
          .set(uploadModel.toJson());
    } catch (e) {
      //
    }
  }

  void buildSaveDialog(BuildContext context, File imageFile) {
    String enteredName = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Save and Upload data",
            style: titleTextStyle,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                    maxWidth: 300,
                  ),
                  child: Image.file(imageFile)),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  enteredName = value;
                },
                decoration: InputDecoration(
                  hintText: "Enter name",
                  border: const OutlineInputBorder(),
                  hintStyle: addressTextStyle,
                ),
              ),
              const SizedBox(height: 20),
              Text("Is this drawn by a normal kid", style: subTitleTextStyle),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                uploadImageDataFirebase(false, enteredName, imageFile);
                Navigator.of(context).pop();
              },
              child: Text(
                "No, It is a special kid",
                style: facilityTextStyle.copyWith(
                  color: Colors.blue,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                uploadImageDataFirebase(true, enteredName, imageFile);
                Navigator.of(context).pop();
              },
              child: Text(
                "Yes, It is a normal kid",
                style: facilityTextStyle.copyWith(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image",
            style: greetingTextStyle.copyWith(color: Colors.white)),
        backgroundColor: darkBlue500,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
                backgroundColor:
                    const MaterialStatePropertyAll(darkBlue300),
              ),
              onPressed: () async {
                final pickedImage =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  setState(() {
                    _imageFile = File(pickedImage.path);
                  });
                  buildSaveDialog(context, _imageFile);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  'Upload from Gallery',
                  style: subTitleTextStyle.copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
                backgroundColor:
                    const MaterialStatePropertyAll(darkBlue300),
              ),
              onPressed: () async {
                final pickedImage =
                    await picker.pickImage(source: ImageSource.camera);
                if (pickedImage != null) {
                  setState(() {
                    _imageFile = File(pickedImage.path);
                  });
                  buildSaveDialog(context, _imageFile);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  'Upload from Camera',
                  style: subTitleTextStyle.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
