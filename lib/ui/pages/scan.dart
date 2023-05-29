import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

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
  } //

  final _reference = FirebaseFirestore.instance.collection('images');

  // ajout detection
  Interpreter? interpreter;
  late List<String> labels;
  late Uint8List imageBytes;
  late ImageProvider imageProvider = _image as ImageProvider<Object>;
  List<dynamic>? outputs;

  @override
  void initState() {
    super.initState();
    loadModel();
    loadLabels();
    loadImage();
  }

  Future<void> loadModel() async {
    try {
      final interpreterOptions = InterpreterOptions();
      interpreter = await Interpreter.fromAsset('mobilenet_v1_1.0_224.tflite',
          options: interpreterOptions);
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<void> loadLabels() async {
    try {
      final labelData = await rootBundle.loadString('assets/labels.txt');
      labels = labelData.split('\n');
    } catch (e) {
      print('Error loading labels: $e');
    }
  }

  Future<void> loadImage() async {
    try {
      final imageFile = await getImageFile();
      imageBytes = await imageFile.readAsBytes();
      imageProvider = MemoryImage(imageBytes);
    } catch (e) {
      print('Error loading image: $e');
    }
  }

  Future<File> getImageFile() async {
    // Replace with your image loading logic
    // For simplicity, this example uses a test image included in the assets folder
    final path = _image;
    final byteData = await rootBundle.load(path as String);
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  Future<List<dynamic>> runInference() async {
    try {
      final inputs = <dynamic>[imageBytes];
      final outputs = List.filled(1, <List<dynamic>>[]);

      interpreter?.run(inputs, outputs);

      return outputs[0];
    } catch (e) {
      print('Error running inference: $e');
      return [];
    }
  }
  // fin ajout detection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F4E9),
      appBar: AppBar(
        title: Text('Scan'),
      ),
<<<<<<< HEAD
      body: SingleChildScrollView(
       // padding: const EdgeInsets.all(60.0),
=======
      body: Padding(
        padding: const EdgeInsets.all(60.0),
>>>>>>> a15e794943000d06604781b6e014ae58fd09bbdb
        child: Column(
          children: [
            SizedBox(height: 15),
            // scanner une image
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
           // Importer une image
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

            // champ code de l'image
            Container(
              width: 200, // Set the desired width here
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Code de l\'image',
                ),
                controller: _controllerCode,
              ),
            ),


            SizedBox(height: 15),


            // afficher resultat
            //Image(image: imageProvider),

            if (_image != null)
             Image.file(
                _image!,
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
              //outputs = await runInference();
              //setState(() {});

           /* ElevatedButton(
              onPressed: () async {
                // check



              },
              child: Text('Afficher résultat'),
            ),*/
            if (outputs != null)
              Column(
                children: [
                  Text('Inference Results:'),
                  for (var i = 0; i < outputs!.length; i++)
                    Text('${labels[i]}: ${outputs![i]}'),
                ],
              ),
            // enregistrement


            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                // check
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

           SizedBox(height: 365),
            Positioned(
              bottom: 0,
              left: 0,
              child: ClipPath(
                clipper: DoubleCurvedClipper(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  color: Color(0xFF16a1b1), // Replace with your desired color
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
class DoubleCurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.4);

    final firstControlPoint = Offset(size.width / 4, size.height * 0.3);
    final firstEndPoint = Offset(size.width / 2, size.height * 0.4);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    final secondControlPoint = Offset(size.width - (size.width / 4), size.height * 0.5);
    final secondEndPoint = Offset(size.width, size.height * 0.4);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height * 0.4);
    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}