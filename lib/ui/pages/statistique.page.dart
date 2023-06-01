import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Statistique extends StatefulWidget {
  Statistique({Key? key}) : super(key: key);

  @override
  _StatistiqueState createState() => _StatistiqueState();
}

class _StatistiqueState extends State<Statistique> {
  final CollectionReference _imageCollection =
  FirebaseFirestore.instance.collection('images');

  late double nbPantalon;
  late double nbJupe;
  late double nbTshirt;
  late double nbRobe;
  late double nbPiecesDefaillantes;
  late double nbPiecesNonDefaillantes;

  Future<double> getNbPantalonDefaillants() async {
    QuerySnapshot querySnapshot = await _imageCollection
        .where('type', isEqualTo: 'pantalon')
        .where('etat', isEqualTo: 'défaillante')
        .get();
    // Print the querySnapshot
    print('Query Snapshot Pantalon:');
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Object? data = doc.data();
      print('Document ID: ${doc.id}');
      print('Data: $data');
    }
    double count = querySnapshot.size.toDouble();
    return count;
  }

  Future<double> getNbJupeDefaillantes() async {
    QuerySnapshot querySnapshot = await _imageCollection
        .where('type', isEqualTo: 'jupe')
        .where('etat', isEqualTo: 'défaillante')
        .get();
    // Print the querySnapshot
    print('Query Snapshot jupe:');
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Object? data = doc.data();
      print('Document ID: ${doc.id}');
      print('Data: $data');
    }
    double count = querySnapshot.size.toDouble();
    return count;
  }

  Future<double> getNbTshirtDefaillants() async {
    QuerySnapshot querySnapshot = await _imageCollection
        .where('type', isEqualTo: 't-shirt')
        .where('etat', isEqualTo: 'défaillante')
        .get();
    // Print the querySnapshot
    print('Query Snapshot t-shirt:');
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Object? data = doc.data();
      print('Document ID: ${doc.id}');
      print('Data: $data');
    }
    double count = querySnapshot.size.toDouble();
    return count;
  }

  Future<double> getNbRobeDefaillantes() async {
    QuerySnapshot querySnapshot = await _imageCollection
        .where('type', isEqualTo: 'robe')
        .where('etat', isEqualTo: 'défaillante')
        .get();
    // Print the querySnapshot
    print('Query Snapshot robe:');
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Object? data = doc.data();
      print('Document ID: ${doc.id}');
      print('Data: $data');
    }
    double count = querySnapshot.size.toDouble();
    return count;
  }

  Future<double> getNbPiecesNonDefaillantes() async {
    QuerySnapshot querySnapshot = await _imageCollection
        .where('etat', isEqualTo: 'non défaillante')
        .get();
    // Print the querySnapshot
    print('Query Snapshot  Pieces Non Defaillantes:');
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Object? data = doc.data();
      print('Document ID: ${doc.id}');
      print('Data: $data');
    }
    double count = querySnapshot.size.toDouble();
    return count;
  }


  Future<double> getNbPiecesDefaillantes() async {
    QuerySnapshot querySnapshot =
    await _imageCollection.where('etat', isEqualTo: 'défaillante').get();
    print('Query Snapshot  Pieces Defaillantes:');
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Object? data = doc.data();
      print('Document ID: ${doc.id}');
      print('Data: $data');
    }
    double count = querySnapshot.size.toDouble();
    return count;
  }

  Future<void> loadData() async {
    // pantalon
    nbPantalon = await getNbPantalonDefaillants();
    // jupe
    nbJupe = await getNbJupeDefaillantes();
    // t-shirt
    nbTshirt = await getNbTshirtDefaillants();
    // robe
    nbRobe = await getNbRobeDefaillantes();
    // piece défaillante
    nbPiecesDefaillantes = await getNbPiecesDefaillantes();
    // piece non défaillante
    nbPiecesNonDefaillantes = await getNbPiecesNonDefaillantes();
    }


  @override
  void initState() {
    super.initState();
    /*getNbPantalonDefaillants();
    getNbJupeDefaillantes();
    getNbTshirtDefaillants();
    getNbRobeDefaillantes();
    getNbPiecesNonDefaillantes();
    getNbPiecesDefaillantes();*/
    loadData(); // Call the loadData method when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Pantalon": nbPantalon,
      "Jupe": nbJupe,
      "T-shirt": nbTshirt,
      "Robe": nbRobe,
    };

    Map<String, double> dataMap2 = {
      "Pièces défaillantes": nbPiecesDefaillantes,
      "Pièces non défaillantes": nbPiecesNonDefaillantes,
    };

    List<Color> colorList = [
      const Color(0xffD95AF3),
      const Color(0xff3EE094),
      const Color(0xff3398F6),
      const Color(0xffFA4A42),
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF7F4E9),
      appBar: AppBar(
        title: Text('Statistiques'),
      ), //AppBar
      body: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Adjust the positioning here
        children: [
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(9),
            child: Text(
              'Pièces totales',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ), // TextStyle
            ), //Text
          ), //Padding
          Container(
            height: 280, // Set the desired height of the PieChart
            child: Center(
              child: PieChart(
                dataMap: dataMap2,
                colorList: colorList,
                chartRadius: MediaQuery.of(context).size.width / 2.5,
                chartValuesOptions: ChartValuesOptions(
                  showChartValueBackground: false,
                  showChartValues: true,
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: true,
                ),
                legendOptions: LegendOptions(
                  showLegends: true,
                  legendShape: BoxShape.rectangle,
                  showLegendsInRow: true,
                  legendPosition: LegendPosition.bottom,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ), //Container
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(0.5),
            child: Text(
              'Pièces défaillantes',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            height: 280,
            child: Center(
              child: PieChart(
                dataMap: dataMap,
                colorList: colorList,
                chartRadius: MediaQuery.of(context).size.width / 2.5,
                chartValuesOptions: ChartValuesOptions(
                  showChartValueBackground: false,
                  showChartValues: true,
                  //
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: true,
                ),
                legendOptions: LegendOptions(
                  showLegends: true,
                  legendShape: BoxShape.rectangle,
                  showLegendsInRow: true,
                  legendPosition: LegendPosition.bottom,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
