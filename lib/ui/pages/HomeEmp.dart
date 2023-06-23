import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeEmp extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeEmp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F4E9),
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
              Positioned(
              top: 0,
              child: Image.asset(
                'assets/logo2.png',
                width: 366,
                height: 216,
                /*width: 325,
                height: 200,
                width: 466,
                height: 192,*/
              ),
            ),

            SizedBox(height: 20),
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
            SizedBox(height: 35),

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

Widget CustomButton({
  required String title,
  required IconData icon,
  required VoidCallback onClick,
  Color? backgroundColor,
  double iconSize = 28.0, // Specify the desired icon size
  double fontSize = 25.0, // Specify the desired font size
}) {
  return Container(
    width: 300,
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
            height: 65,
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

class DoubleCurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.4);

    final firstControlPoint = Offset(size.width / 4, size.height * 0.3);
    final firstEndPoint = Offset(size.width / 2, size.height * 0.4);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    final secondControlPoint =
    Offset(size.width - (size.width / 4), size.height * 0.5);
    final secondEndPoint = Offset(size.width, size.height * 0.4);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

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

class MyDrawer extends StatelessWidget {
  const MyDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFF7F4E9),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFF7F4E9),
            ),
            child: CircleAvatar(
              radius: 30.0,
              backgroundColor:
              Color(0xFFF7F4E9), // Couleur d'arrière-plan souhaitée
              child: Icon(
                Icons.account_circle_sharp,
                size: 150.0,
                //  Color(0xFF16a1b1),
                color: Color(0xFF46494C),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Text(
                'Employé',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 30.0,
                  color: Color(0xFF46494C),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Responsable Qualité',
                style: TextStyle(
                  fontFamily: 'Source Sans Pro',
                  color: Colors.black54,
                  fontSize: 15.0,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 400),
              Text(
                'Déconnexion',
                style: TextStyle(
                  fontFamily: 'Source Sans Pro',
                  color: Color(0xFF46494C),
                  fontSize: 15.0,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.bold,
                ),
              ),


            ],
          ),
        ],
      ),
    );
  }
}
