
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage() ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: ListView(
          children: [

            ListTile(
              title: Text('Commencer le scan',style: TextStyle(fontSize: 30),),
              leading: Icon(Icons.photo_camera,color: Colors.teal,size: 40),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              onTap: (){
                Navigator.pushNamed(context, "/camera");
              },
            ),
            ListTile(
              title: Text('Statistiques',style: TextStyle(fontSize: 30),),
              leading: Icon(Icons.assessment,color: Colors.teal,size: 40),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              onTap: (){
                Navigator.pushNamed(context, "/statistique");
              },
            ),
            ListTile(
              title: Text('Galerie',style: TextStyle(fontSize: 30),),
              leading: Icon(Icons.photo_library,color: Colors.teal,size: 40),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              onTap: (){
                Navigator.pushNamed(context, "/galerie");
              },
            ),
            ListTile(
              title: Text('Employés',style: TextStyle(fontSize: 30),),
              leading: Icon(Icons.supervised_user_circle,color: Colors.teal,size: 40),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              onTap: (){
                Navigator.pushNamed(context, "/employe");
              },
            ),
          ],
        ),
      ),
    );


  }
}

