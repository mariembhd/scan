import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

import 'HomeAdmin.dart';

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  TextEditingController _controllerCode = TextEditingController();
  XFile? file;
  File? _image;
  String imageUrl = '';
  String finalResponse = '';

  Future<void> getImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile == null) return;

    final imageTemporary = File(pickedFile.path);

    setState(() {
      _image = imageTemporary;
    });

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Upload to Firebase storage
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(pickedFile.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {}
  }

  final _reference = FirebaseFirestore.instance.collection('images');

  Future<String> callFlaskAPI(File imageFile) async {
    final url = 'http://127.0.0.1:5000/detect';
    final imageBytes = await imageFile.readAsBytes();
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/octet-stream'},
      body: imageBytes,
    );
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F4E9),
      appBar: AppBar(
        title: Text('Scan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(100.0),
        child: Column(
          children: [
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                getImage(ImageSource.camera);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.photo_camera),
                  SizedBox(width: 10),
                  Text('Scanner une image'),
                ],
              ),
            ),
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                getImage(ImageSource.gallery);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.photo_library),
                  SizedBox(width: 10),
                  Text('Importer une image'),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: 200,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Code de l\'image',
                ),
                controller: _controllerCode,
              ),
            ),
            SizedBox(height: 15),
            if (_image != null)
              Image.file(
                _image!,
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
            ElevatedButton(
              onPressed: () async {
                if (_image == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Scanner ou importer une image')),
                  );
                  return;
                }
                final response = await callFlaskAPI(_image!);

                setState(() {
                  finalResponse = response;
                });
              },
              child: Text('Afficher résultat'),
            ),
            Text(
              finalResponse,
              style: TextStyle(fontSize: 24),
            ),



            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (imageUrl.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Scanner ou importer une image')),
                  );
                  return;
                }

                if (_controllerCode.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Le champ code est requis')),
                  );
                  return;
                }

                String itemCode = _controllerCode.text;
                Map<String, String> dataToSend = {
                  'code': itemCode,
                  'image': imageUrl,
                };

                await _reference.add(dataToSend);

                _controllerCode.clear();
                setState(() {
                  _image = null;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Enregistrement effectué')),
                );
              },
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
