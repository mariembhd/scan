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


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/camera":(context)=>CameraPage(),
        "/statistique":(context)=>Statistique(),
        "/galerie":(context)=>GaleriePage(),
        "/employe":(context)=>EmployePage(),
        "/ajouter_ou_modifier_emp":(context)=>ManageEmploye(),
        "/scan":(context)=>Scan(),
        "/mesure":(context)=>Mesure(),
        "/MesurePantalon":(context)=>MesurePantalon(),
        "/Managemesure":(context)=>Managemesure(),
       // "/Managepantalon":(context)=>Managepantalon(),
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

        primarySwatch: MaterialColor(0xFF16a1b1, {
          50: Color(0xFFE0F3F4),
          100: Color(0xFFB3E3E8),
          200: Color(0xFF80D1DC),
          300: Color(0xFF4DBFCF),
          400: Color(0xFF26B3C7),
          500: Color(0xFF16a1b1),
          600: Color(0xFF1497A8),
          700: Color(0xFF10849A),
          800: Color(0xFF0D6D80),
          900: Color(0xFF095862),
        }),



      ),
      home: HomePage(),
    );
  } //   Widget
} // class


