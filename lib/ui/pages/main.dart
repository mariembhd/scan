import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:scan/ui/pages/camera.page.dart';
import 'package:scan/ui/pages/employe.page.dart';
import 'package:scan/ui/pages/galerie.page.dart';
import 'package:scan/ui/pages/statistique.page.dart';
import 'package:scan/widget/Home.widget.dart';
import 'package:scan/ui/pages/employe.ajouterEmp.dart';
import 'package:firebase_core/firebase_core.dart';

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
   runApp(MyApp(cameraController));
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp(CameraController cameraController, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/camera":(context)=>CameraPage(),
        "/statistique":(context)=>StatistiquePage(),
        "/galerie":(context)=>GaleriePage(),
        "/employe":(context)=>EmployePage(),
        "/ajouterEmp":(context)=>ajouterEmp(),

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

        primarySwatch: Colors.teal,
      ),
      home: HomePage(),
    );
  } //   Widget
} // class


/*class MyDrawer extends StatelessWidget {
    const MyDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [


        ],
      ),
    );
  }

}*/