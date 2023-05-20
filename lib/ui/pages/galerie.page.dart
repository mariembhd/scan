import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scan/ui/pages/scan.dart';

class ImageModel {
  final String? id;
  final String code;
  final String? image;
  final Timestamp? createdAt;

  ImageModel({
    this.id,
    required this.code,
    this.image,
    this.createdAt,
  });

  // Convert data to map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'image': image,
      'createdAt': createdAt,
    };
  }
}

class GaleriePage extends StatelessWidget {
  final CollectionReference _imageCollection =
  FirebaseFirestore.instance.collection('images');

  Future<void> deleteImage(String imageId) async {
    await _imageCollection.doc(imageId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/scan');
        },
        child: Icon(Icons.photo_camera),
      ),
      appBar: AppBar(title: Text('Galerie')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _imageCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    );
                  }

                  if (snapshot.hasData) {
                    List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> thisItem =
                        documents[index].data() as Map<String, dynamic>;
                        ImageModel imageModel = ImageModel(
                          id: documents[index].id,
                          code: thisItem['code'],
                          image: thisItem['image'],
                          createdAt: thisItem['createdAt'],
                        );
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    deleteImage(imageModel.id!);
                                  },
                                  icon: Icons.delete,
                                  backgroundColor: Colors.teal,
                                ),
                              ],
                            ),
                            child: ListTile(
                              tileColor: Colors.white70,
                              title: Text('${imageModel.code}'),
                              /*subtitle: Text(
                                'Date: ${imageModel.createdAt?.toDate().toString()}',
                              ),*/
                              leading: Container(
                                height: 80,
                                width: 80,
                                child: imageModel.image != null
                                    ? Image.network(imageModel.image!) // Image from URL
                                    : Container(),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ItemDetails(imageModel.id!),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemDetails extends StatelessWidget {
  final String itemId;
  final CollectionReference _imageCollection =
  FirebaseFirestore.instance.collection('images');

  ItemDetails(this.itemId);

  @override
  Widget
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'élément'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _imageCollection.doc(itemId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }

          if (snapshot.hasData) {
            Map<String, dynamic> itemData = snapshot.data!.data() as Map<String, dynamic>;
            ImageModel imageModel = ImageModel(
              id: snapshot.data!.id,
              code: itemData['code'],
              image: itemData['image'],
            );

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    child: imageModel.image != null
                        ? Image.network(imageModel.image!) // Image from URL
                        : Container(),
                  ),
                  SizedBox(height: 20),
                  Text('Code : ${imageModel.code}'),
                  SizedBox(height: 10),
                  Text('Date: ${imageModel.createdAt?.toDate().toString()}'),
                ],
              ),
            );
          } else {
            return Center(
              child: Text('Erreur lors du chargement des données'),
            );
          }
        },
      ),
    );
  }
}



