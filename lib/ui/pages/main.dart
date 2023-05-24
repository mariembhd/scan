import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:scan/ui/pages/camera.page.dart';
import 'package:scan/ui/pages/employe.page.dart';
import 'package:scan/ui/pages/galerie.page.dart';
import 'package:scan/ui/pages/resultat.dart';
import 'package:scan/ui/pages/scan.dart';
import 'package:scan/ui/pages/statistique.page.dart';
import 'package:scan/ui/pages/HomeAdmin.dart';
import 'package:scan/ui/pages/ajouter_ou_modifier_emp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ajouter_ou_modifier_mesure.dart';
import 'detection.dart';
import 'mesure.dart';

void main()  async
{
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();

   WidgetsFlutterBinding.ensureInitialized();

   // Obtain a list of available cameras on the device.
   final List<CameraDescription> cameras = await availableCameras();

   // Get a specific camera from the list of available cameras.
   final CameraController cameraController = CameraController(
     cameras[0],
     ResolutionPreset.medium,
   );

   // Run the app with the camera controller as an argument.
   runApp(MyApp());
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {

 final MaterialColor customColor = MaterialColor(
   0xFF3FA4BE,
   <int, Color>{
     50: Color(0xFFC7E3EA),
     100: Color(0xFFA4CFDA),
     200: Color(0xFF7FBBCA),
     300: Color(0xFF5CA7BA),
     400: Color(0xFF4492AA),
     500: Color(0xFF2E8FA8),
     600: Color(0xFF287B94),
     700: Color(0xFF226780),
     800: Color(0xFF1C536C),
     900: Color(0xFF163F58),
   },
 );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/camera":(context)=>CameraPage(),
        "/statistique":(context)=>Statistique(),
        "/galerie":(context)=>GaleriePage(),
        "/employe":(context)=>EmployePage(),
        "/ajouter_ou_modifier_emp":(context)=>ManageEmploye(),
        "/scan":(context)=>Scan(),
        "/mesure":(context)=>Mesure(),
        "/mesureJupe":(context)=>MesureJupe(),
        "/mesurePantalon":(context)=>MesurePantalon(),
        "/Managejupe":(context)=>Managejupe(),
        "/Managepantalon":(context)=>Managepantalon(),
        "/detection":(context)=>MyAppState(),
        "/resultat":(context)=>Resultat(),


      },
      title: 'Flutter Demon',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.

        primarySwatch: customColor,
      ),
      home: HomePage(),
    );
  } //   Widget
} // class


