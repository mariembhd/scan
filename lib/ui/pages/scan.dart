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
import 'package:path/path.dart' as path;

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  TextEditingController _controllerCode = TextEditingController();
  bool _isTextVisible = false;
  bool visible = true;
  XFile? file;
  File? _image;
  String imageUrl = '';
  double nW = 0.0;
  double nH = 0.0;
  String etat = '';
  String? message = "";

  Future<void> sendImageToPython(_image) async {
    if (_image == null) {
      return;
    }
    String pathImage = _image.path;
    String imageName =  path.basename(pathImage);
    print('imageName: $imageName');
    var imageUrl = Uri.parse('http://192.168.1.17:8080/image');

// Read the image file as bytes
    List<int> imageBytes = File(pathImage).readAsBytesSync();

// Send the image bytes to the backend
    var imageResponse = await http.post(
      imageUrl,
      body: {'imageUrl': base64Encode(imageBytes),'imageName':imageName},
    );

    if (imageResponse.statusCode == 200) {
      final decodedData = json.decode(imageResponse.body);
      setState(() {
        nW = double.parse(decodedData['nW'].toString());
        nH = double.parse(decodedData['nH'].toString());
        visible = false;
      });
    } else {
      // Handle error
    }
   /* if (imageResponse.statusCode == 200) {
      print('Image envoyée avec succès');
    } else {
      print(
          'Échec de l envoi de l image. Code de réponse : ${imageResponse.statusCode}');
    }*/
    setState(() {});
  }

  Future<void> fetchImageDetails(_image, itemCode) async {
    // Send the captured image to Python
    print("fetchImageDetails");
    await sendImageToPython(_image);
  }

  Future<String> comparaison(
      String codeSaisi, double largeur, double longueur) async {
    final CollectionReference _mesure =
        FirebaseFirestore.instance.collection('mesure');
    QuerySnapshot querySnapshot =
        await _mesure.where('code', isEqualTo: codeSaisi).get();
    String etat = '';
    print('codeSaisi: $codeSaisi');
   print("querySnapshot.docs.isNotEmpty $querySnapshot.docs.isNotEmpty ");
    if (querySnapshot.docs.isNotEmpty) {
      String largeurRef = (querySnapshot.docs[0].data()
          as Map<String, dynamic>)['largeur'] ;
      String longueurRef = (querySnapshot.docs[0].data()
          as Map<String, dynamic>)['longueur'] ;
      double tolerance = 0.5;
      print("largeurRef $largeurRef");
      print("largeur $largeur");
      print("tolerance $tolerance");
      if ((double.parse(largeurRef) - largeur).abs() <= tolerance &&
          (double.parse(longueurRef)  - longueur).abs() <= tolerance)
        { print('non défaillante $etat');
          etat = "non défaillante";
          print('$etat');
        }
      else{
        print('défaillante $etat');
        etat = "défaillante";
        print('$etat');
      }
    } else {
      etat = "Code non trouvé";
      print('$etat');

    }

    return etat;
  }

  // getImage
  Future<void> getImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    _isTextVisible = false;
    visible = true;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F4E9),
      appBar: AppBar(
        title: Text('Scan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(90.0),
        child: Column(
          children: [
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

            // affichage

            if (_image != null)
              Column(
                children: [
                  Image.file(
                    _image!,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            SizedBox(height: 10),
            Visibility(
            visible :visible ,
            child : ElevatedButton(
              onPressed: () async {
                _isTextVisible = true;

                if (_controllerCode.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Le champ code est requis')),
                  );
                  return;
                }
                if (_image == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Scanner ou importer une image')),
                  );
                  return;
                }
                String itemCode = _controllerCode.text;
                await fetchImageDetails(_image, itemCode);
                comparaison(itemCode, nW, nH).then((value) {
                    setState(() {

                   etat = value;
                  });
                 });


                // Affichage des résultats
                if (_image != null) {
                  print("image non null");
                  Column(
                    children: [

                      SizedBox(height: 10),
                      Text(
                        'Largeur : $nW cm',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'Longueur : $nH cm',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'Etat :  $etat',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  );
                }
              },
              child: Text('Afficher résultat'),
            )),
            if (_isTextVisible)
              Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Largeur : $nW cm',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    'Longueur : $nH cm',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    'Etat :  $etat',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),

            // Affichage des résultats
            /* if (_image != null)
              Column(
                children: [
                  Image.file(
                    _image!,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                Text(
                    'Largeur : $nW cm',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    'Longueur : $nH cm',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    'Etat :  $etat',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),*/

            // enregistrement
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                _isTextVisible = false;
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
                  'largeur': nW.toString(),
                  'longueur': nH.toString(),
                  'etat': etat,
                  'type': itemCode.substring(0, itemCode.length - 3),
                };
                print('dataToSend $dataToSend');
                await _reference.add(dataToSend);
                print('after dataToSend');
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
