import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:patternpulse/config/theme.dart';
import 'package:scribble/scribble.dart';
import 'package:patternpulse/Data/Models/drawing_model.dart';
import 'package:patternpulse/Data/Models/drawing_point_model.dart';

Widget saveButton(
    BuildContext context, ScribbleNotifier notifier, String expectedWord) {
  return IconButton(
    iconSize: 35,
    color: darkBlue300,
    icon: const Icon(Icons.save),
    tooltip: "Save",
    onPressed: () {


      final json = notifier.currentSketch.toJson();
      if (json['lines'] == [] ||
          json['lines'] == null ||
          json['lines'].isEmpty) {
        const ScaffoldMessenger(
          child: Text("Nothing Has been Drawn"),
        );
        AlertDialog(
          title: const Text("Nothing has been drawn"),
          content: const Text("Please draw something before saving"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok"),
            ),
          ],
        );
      } else {
        List<DrawingPointModel> points = [];
        for (var i in json['lines'][0]['points']) {
          points.add(DrawingPointModel(
            x: i['x'],
            y: i['y'],
            timeStamp: DateTime.timestamp(),
            pressure: i['pressure'],
          ));
        }
        late DrawingModel drawing;
        void uploadDrawingFirebase(bool normal, String enteredName) {
          notifier.renderImage().then(
            (image) {
              // final  img = image.buffer.asUint8List();
              uploadImage(notifier, enteredName, expectedWord)
              // uploadImage(img, enteredName, expectedWord)
                  .then(
                (imageUrl) {
                  drawing = DrawingModel(
                    imageUrl: imageUrl,
                    drawingPoints: points,
                    normal: normal,
                    expectedWord: expectedWord,
                  );
                  FirebaseFirestore.instance
                      .collection('DrawingData')
                      .doc("${enteredName}_$expectedWord")
                      .set(drawing.toJson())
                      .then((value) => const SnackBar(content: Text("Data Uploaded"))
                      );
                },
              );
            },
          );
        }

        showDialog(
          context: context,
          builder: (context) {
            String enteredName = '';

            return AlertDialog(
              title: Text(
                "Save and Upload data",
                style: titleTextStyle,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        enteredName = value;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter name",
                        border: const OutlineInputBorder(),
                        hintStyle: addressTextStyle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text("Is this drawn by a normal kid",
                      style: subTitleTextStyle),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    uploadDrawingFirebase(false, enteredName);
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
                    uploadDrawingFirebase(true, enteredName);
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
    },
  );
}

Future<String> uploadImage(
    ScribbleNotifier notifier, String imageName, String expectedWord) async {
  try {
    final image = await notifier.renderImage();
    final imageData =  image.buffer.asUint8List();
    
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('images/${imageName}_$expectedWord.png');
    await storageRef.putData(
        imageData, SettableMetadata(contentType: 'image/png'));
    final downloadURL = await storageRef.getDownloadURL();
    return downloadURL;
  } catch (e) {
    return "Image Not Uploaded";
  }
}

Future<void> displayImage(ByteData imageData,context ) async {
  final image = Image.memory(imageData.buffer.asUint8List());
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: image,
    ),
  );
}

void _showImage(BuildContext context, ScribbleNotifier notifier) async {
    final image = notifier.renderImage();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Generated Image"),
        content: SizedBox.expand(
          child: FutureBuilder(
            future: image,
            builder: (context, snapshot) => snapshot.hasData
                ? Image.memory(snapshot.data!.buffer.asUint8List())
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

