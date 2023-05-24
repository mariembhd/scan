import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';



class MyAppState extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppState> {
  Interpreter? interpreter;
  late List<String> labels;
  late Uint8List imageBytes;
  late ImageProvider imageProvider = AssetImage('assets/placeholder_image.jpg');
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
      interpreter = await Interpreter.fromAsset('mobilenet_v1_1.0_224.tflite', options: interpreterOptions);
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
    final path = 'assets/test_image.jpg';
    final byteData = await rootBundle.load(path);
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TFLite Flutter Example'),
        ),
        body: Column(
          children: [
            Image(image: imageProvider),
            ElevatedButton(
              onPressed: () async {
                outputs = await runInference();
                setState(() {});
              },
              child: Text('Run Inference'),
            ),
            if (outputs != null)
              Column(
                children: [
                  Text('Inference Results:'),
                  for (var i = 0; i < outputs!.length; i++)
                    Text('${labels[i]}: ${outputs![i]}'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}


/*

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
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
      appBar: AppBar(
        title: Text('Scan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          children: [
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

            // champ code de l'image
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Code de l\'image',
              ),
              controller: _controllerCode,
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

                outputs = await runInference();
                setState(() {});
              },
              child: Text('Afficher résultat'),
            ),
            if (outputs != null)
              Column(
                children: [
                  Text('Inference Results:'),
                  for (var i = 0; i < outputs!.length; i++)
                    Text('${labels[i]}: ${outputs![i]}'),
                ],
              ),
            // enregistrement

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
          ],
        ),
      ),
    );
  }
}

 */