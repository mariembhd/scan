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

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  TextEditingController _controllerCode = TextEditingController();
  XFile? file;
  File? _image;
  String imageUrl = '';
  double nW = 0.0;
  double nH = 0.0;
  String etat = '';
  String? message = "";
  String itemCode = "";


  Future<void> sendImageToPython() async {
    if (_image == null) {
      return;
    }

    final request = http.MultipartRequest(
        "POST", Uri.parse("http://192.168.1.17:8080/detect"));
    final headers = {"Content-type": "multipart/form-data"};
    request.files.add(http.MultipartFile(
        'image', _image!.readAsBytes().asStream(), _image!.lengthSync(),
        filename: _image!.path.split("/").last));
    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);
    message = resJson['message'];
    setState(() {});
  }


  Future<void> fetchImageDetails() async {
    // Send the captured image to Python
    await sendImageToPython();

    // Retrieve updated nH and nW values from Python
    final response = await http.get(Uri.parse('http://192.168.1.17:8080/detect'));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      setState(() {
        nW = double.parse(decodedData['nW'].toString());
        nH = double.parse(decodedData['nH'].toString());
      });
    } else {
      // Handle error
    }
  }


/*
  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.17:8080/detect'));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      setState(() {
        nW = double.parse(decodedData['nW'].toString());
        nH = double.parse(decodedData['nH'].toString());
      });
    } else {
      // Handle error
    }
  }*/

  Future<String> comparaison(
      String codeSaisi, double largeur, double longueur) async {
    final CollectionReference _mesure =
        FirebaseFirestore.instance.collection('mesure');
    QuerySnapshot querySnapshot =
        await _mesure.where('code', isEqualTo: codeSaisi).get();
    String etat = '';

    if (querySnapshot.docs.isNotEmpty) {
      double largeurRef = (querySnapshot.docs[0].data()
          as Map<String, dynamic>)['largeur'] as double;
      double longueurRef = (querySnapshot.docs[0].data()
          as Map<String, dynamic>)['longueur'] as double;
      double tolerance = 0.5;

      if ((largeurRef - largeur).abs() <= tolerance &&
          (longueurRef - longueur).abs() <= tolerance)
        etat = "défaillante";
      else
        etat = "non défaillante";
    } else {
      etat = "Code non trouvé";
    }

    return etat;
  }

  // getImage
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


  @override
  void initState() {
    print('initState');
    super.initState();
   //fetchData();
    fetchImageDetails();

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
            ElevatedButton(
              onPressed: () async {
                if (_image != null) {
                  await fetchImageDetails();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Veuillez d abord scanner ou importer une image.')),
                  );
                }
                if (_controllerCode.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Le champ code est requis')),
                  );
                  return;
                }


                String itemCode = _controllerCode.text;
                comparaison(itemCode, nW, nH).then((value) {
                  setState(() {
                    etat = value;
                  });
                });
              },
              child: Text('Afficher résultat'),

            ),

            // ...

            if (_image != null)
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
              ),



            // enregistrement
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
                  'largeur': nW.toString(),
                  'longueur': nH.toString(),
                  'etat': etat,
                  'type': itemCode.substring(0, itemCode.length - 3),
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
