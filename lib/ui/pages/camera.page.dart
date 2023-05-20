import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:opencv_4/factory/pathfrom.dart';
import 'package:opencv_4/opencv_4.dart';

class CameraPage extends StatefulWidget {
  //  const CameraPage({super.key});
    @override

    State<CameraPage> createState() => _CameraPage();
}


class _CameraPage extends State<CameraPage > {
  late List<CameraDescription> cameras;
  late CameraController cameraController;

  @override
  void initState() {
    startCamera();
    super.initState();
  }

  void startCamera() async {
    // get camera description
    cameras = await availableCameras();

    cameraController = CameraController(
         cameras[0],
         ResolutionPreset.high,
         enableAudio: false,
    );
    // initialise camera controller
    await cameraController.initialize().then((value){
      if(!mounted) {
        return ;
      }
      setState(() {});  // to refresh widget
     }).catchError((e){
       print(e);
    });
  }

  @override
  void dispose(){
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
        if (cameraController.value.isInitialized)
      return Scaffold(
          appBar: AppBar(title: Text('Scanneur')),
          body: Stack(
            children: [
              CameraPreview(cameraController),
              GestureDetector(
                  onTap: (){
                    cameraController.takePicture().then((XFile file) async {
                        if(mounted){
                          if(file != null){
                            print("picture saves to ${file.path}");
                            // fnct send picture to phython file (take file.path in paramétre )
                         }
                        }
                    }
                    );
                  },
                  child: button(Icons.photo_camera, Alignment.bottomCenter),
              ),
         ],
       ),
      );
    else return const SizedBox();
  }

  Widget button (IconData icon, Alignment alignment) {
    return  Align(
      alignment: alignment,
      child: Container(
        margin: EdgeInsets.only(
          left: 20,
          bottom: 20,
        ),
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color : Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 10,
            ),],
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

}