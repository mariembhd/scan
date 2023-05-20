import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Home.widget.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Scan extends StatefulWidget {

  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  TextEditingController _controllerCode = TextEditingController();

  XFile? file;
  File? _image;
  String imageUrl = '';
    Future<void> getImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile == null) return;

    final imageTemporary = File(pickedFile.path);

    setState(() {
      _image = imageTemporary;
    });

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    // télécharger sur le firebase storage
    // get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');


    // create a reference for the image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);


    try {
      // store the file
      await referenceImageToUpload.putFile(File(pickedFile.path));
      // success: get the download URL
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {}

  }//

  final _reference = FirebaseFirestore.instance.collection('images');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Column(
              children: [
              SizedBox(height: 50),

          // afficher l'image
          if (_image != null)
             Image.file(
                _image!,
                width: 250,
                height: 250,
                fit: BoxFit.cover,
             ),

    SizedBox(height: 15),

    // code de l'image
    TextFormField(
      decoration: InputDecoration(
        labelText: 'Code de l\'image',
         ),
       controller: _controllerCode,

    ),

    SizedBox(height: 15),
    // scanner une image
    CustomButton(
    title: 'Scanner une pièce ',
    icon: Icons.photo_camera,
    onClick: () {
    getImage(ImageSource.camera);
    },
    ),

    SizedBox(height: 15),
    // Importer une image
    CustomButton(
    title: 'Importer une image',
    icon: Icons.photo_library,
    onClick: () {
    getImage(ImageSource.gallery);
    },
    ),
    SizedBox(height: 15),

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


      String  itemCode = _controllerCode.text ;
      Map<String, String> dataToSend = {
        'code': itemCode,
        'image': imageUrl,
      };

      // Add a new item
      await _reference.add(dataToSend);

    // clear form after submission
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