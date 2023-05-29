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
    //  backgroundColor: Colors.white70,
      drawer : MyDrawer(),
      appBar: AppBar(title: Text('Accueil'),),
      body:  Center(
        child: Column(

          children: [
            SizedBox(height: 70),
           ListTile(
              leading: Icon(Icons.photo_camera,color: Colors.teal,size: 100),
              contentPadding: EdgeInsets.symmetric(horizontal: 145),
              onTap: (){
                Navigator.pushNamed(context, "/scan");
              },
            ),
            SizedBox(height: 70),
            CustomButton(
              title:'Scan',
              icon : Icons.photo_camera,
              onClick: (){
                Navigator.pushNamed(context, "/scan");
              },
            ),


            SizedBox(height: 30),
            CustomButton(
              title:'Galerie',
              icon : Icons.image_outlined,
              onClick: (){
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
              title:'Mesures',
              icon : Icons.straighten,
              onClick: (){
                Navigator.pushNamed(context, "/mesure");
              },
            ),

            SizedBox(height: 30),
            CustomButton(
              title:'Statistiques',
              icon : Icons.assessment,
              onClick: (){
                Navigator.pushNamed(context, "/statistique");
              },
            ),




            SizedBox(height: 30),
            CustomButton(
              title:'Employés',
              icon : Icons.supervised_user_circle,
              onClick: (){
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

Widget CustomButton ({
  required String title,
  required IconData icon,
  required VoidCallback onClick,
  Color? backgroundColor, }) {
  return Container(
    width: 250,
    child: ElevatedButton(
            onPressed: onClick,
      style: ElevatedButton.styleFrom(
        primary: backgroundColor, // Use the provided backgroundColor
      ),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 30,
            height: 60,
          ),
          Text(title) ,
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
          SizedBox(height: 30),
          ListTile(
            title: Text('Scan',style: TextStyle(fontSize: 30),),
            leading: Icon(Icons.photo_camera,color: Colors.teal,size: 40),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            onTap: (){
              Navigator.pushNamed(context, "/scan");
            },
          ),

          SizedBox(height: 15),
          ListTile(
            title: Text('Mesures',style: TextStyle(fontSize: 30),),
            leading: Icon(Icons.straighten,color: Colors.teal,size: 40),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            onTap: (){
              Navigator.pushNamed(context, "/mesure");
            },
          ),

          SizedBox(height: 15),
          ListTile(
            title: Text('Statistiques',style: TextStyle(fontSize: 30),),
            leading: Icon(Icons.assessment,color: Colors.teal,size: 40),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            onTap: (){
              Navigator.pushNamed(context, "/statistique");
            },
          ),

          SizedBox(height: 15),
          ListTile(
            title: Text('Galerie',style: TextStyle(fontSize: 30),),
            leading: Icon(Icons.image_outlined,color: Colors.teal,size: 40),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            onTap: (){
              Navigator.pushNamed(context, "/galerie");
            },
          ),

          SizedBox(height: 15),
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

    );
  }
}