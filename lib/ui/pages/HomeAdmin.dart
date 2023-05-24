import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F4E9),
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 15),

            Positioned(
              top: 0,
              child: Image.asset(
                'assets/logo2.png',
                width: 325,
                height: 200,
              ),
            ),

           SizedBox(height: 15),
            /* ListTile(
              leading: Icon(Icons.photo_camera, color: Colors.teal, size: 100),
              contentPadding: EdgeInsets.symmetric(horizontal: 145),
              onTap: () {
                Navigator.pushNamed(context, "/scan");
              },
            ),*/
            CustomButton(
              title: 'Scan',
              icon: Icons.photo_camera,
              onClick: () {
                Navigator.pushNamed(context, "/scan");
              },
            ),
            SizedBox(height: 30),
            CustomButton(
              title: 'Galerie',
              icon: Icons.image_outlined,
              onClick: () {
                Navigator.pushNamed(context, "/galerie");
              },
            ),

            /* SizedBox(height: 15),
            CustomButton(
              title:'Scan',
              icon : Icons.photo_camera,
              onClick: (){
                Navigator.pushNamed(context, "/scan");
              },
            ),*/

            SizedBox(height: 30),
            CustomButton(
              title: 'Mesures',
              icon: Icons.straighten,
              onClick: () {
                Navigator.pushNamed(context, "/mesure");
              },
            ),
            SizedBox(height: 30),
            CustomButton(
              title: 'Statistiques',
              icon: Icons.assessment,
              onClick: () {
                Navigator.pushNamed(context, "/statistique");
              },
            ),
            SizedBox(height: 30),
            CustomButton(
              title: 'Employés',
              icon: Icons.supervised_user_circle,
              onClick: () {
                Navigator.pushNamed(context, "/employe");
              },
            ),

            /*  SizedBox(height: 15),
            CustomButton(
              title:'ObjectDetectionScreen',
              icon : Icons.straighten,
              onClick: (){
                Navigator.pushNamed(context, "/detection");
              },
            ),*/
          ],
        ),
      ),
    );
  }
}

Widget CustomButton({
  required String title,
  required IconData icon,
  required VoidCallback onClick,
  Color? backgroundColor,
  double iconSize = 28.0, // Specify the desired icon size
  double fontSize = 25.0, // Specify the desired font size
}) {
  return Container(
    width: 280,
    child: ElevatedButton(
      onPressed: onClick,
      style: ElevatedButton.styleFrom(
        primary: backgroundColor, // Use the provided backgroundColor
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: iconSize, // Set the size of the icon
          ),
          SizedBox(
            width: 35,
            height: 60,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize, // Set the font size of the text
            ),
          ),
        ],
      ),
    ),
  );
}


class MyDrawer extends StatelessWidget {
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
}
