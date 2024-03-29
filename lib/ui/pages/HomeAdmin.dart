import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../authentification/SignIn.dart';

class HomeAdmin extends StatefulWidget {
  final String userName;

  HomeAdmin({required this.userName});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeAdmin> {
  // Method to handle the logout action
  void _logout() {
    print('logout');
    // Implement your logout logic here
    // For example, clear the user session and navigate to the signup screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignIn()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F4E9),
      drawer: MyDrawer(userName: widget.userName, onLogout: _logout),
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //SizedBox(height: 10),

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

            SizedBox(height: 10),
            CustomButton(
              title: 'Scan',
              icon: Icons.photo_camera,
              onClick: () {
                Navigator.pushNamed(context, "/scan");
              },
            ),
            SizedBox(height: 20),
            CustomButton(
              title: 'Galerie',
              icon: Icons.image_outlined,
              onClick: () {
                Navigator.pushNamed(context, "/galerie");
              },
            ),

            SizedBox(height: 20),
            CustomButton(
              title: 'Mesures',
              icon: Icons.straighten,
              onClick: () {
                Navigator.pushNamed(context, "/mesure");
              },
            ),
            SizedBox(height: 20),
            CustomButton(
              title: 'Statistiques',
              icon: Icons.assessment,
              onClick: () {
                Navigator.pushNamed(context, "/statistique");
              },
            ),
            SizedBox(height: 20),
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
  final String userName;
  final VoidCallback onLogout;

  const MyDrawer({
    required this.userName,
    required this.onLogout,
  });

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
                userName,
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
              GestureDetector(
                child:Text(
                'Déconnexion',
                style: TextStyle(
                  fontFamily: 'Source Sans Pro',
                  color: Color(0xFF46494C),
                  fontSize: 15.0,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: onLogout,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
