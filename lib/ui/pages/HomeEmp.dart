import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/authentification/SignUp.dart';

import '../../authentification/SignIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeEmp extends StatefulWidget {
  final String email;

  HomeEmp({required this.email});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeEmp> {
  bool RcanAccessScan = false; // Declare RcanAccessScan variable
  bool RcanAccessStatistics = false;
  bool RcanAccessGallery = false;
  String userName = '';

  @override
  void initState() {
    super.initState();
    fetchEmployeValues(); // Call the function to fetch employee values and update RcanAccessScan
  }

  void fetchEmployeValues() async {
    CollectionReference employeesCollection =
    FirebaseFirestore.instance.collection('employes');
    QuerySnapshot snapshot = await employeesCollection
        .where('email', isEqualTo: widget.email)
        .get();
    if (snapshot.docs.isNotEmpty) {
        setState(() {
         RcanAccessGallery = snapshot.docs[0]['canAccessGallery'];
         RcanAccessStatistics = snapshot.docs[0]['canAccessStatistics'];
         RcanAccessScan = snapshot.docs[0]['canAccessScan'];
         userName = snapshot.docs[0]['nom'];
      });

    } else {
      // Handle the case when the document does not exist for the given email
      setState(() {
        RcanAccessGallery = false;
        RcanAccessStatistics = false;
        RcanAccessScan = false;
      });
    }
  }


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
      drawer: MyDrawer(userName: userName, onLogout: _logout),
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
              ),
            ),
            SizedBox(height: 20),
            if (RcanAccessScan)
              CustomButton(
                title: 'Scan',
                icon: Icons.photo_camera,
                onClick: () {
                  Navigator.pushNamed(context, "/scan");
                },
              ),
            SizedBox(height: 30),
            if (RcanAccessGallery)
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
            if (RcanAccessStatistics)
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
                  color: Color(0xFF16a1b1),
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
  double iconSize = 28.0,
  double fontSize = 25.0,
}) {
  return Container(
    width: 300,
    child: ElevatedButton(
      onPressed: onClick,
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: iconSize,
          ),
          SizedBox(
            width: 35,
            height: 65,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
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
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    final secondControlPoint =
    Offset(size.width - (size.width / 4), size.height * 0.5);
    final secondEndPoint = Offset(size.width, size.height * 0.4);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

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
              backgroundColor: Color(0xFFF7F4E9),
              child: Icon(
                Icons.account_circle_sharp,
                size: 150.0,
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
                // Call the logout callback
                child: Text(
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
