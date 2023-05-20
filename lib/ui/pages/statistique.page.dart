import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class ObjectDetectionScreen extends StatefulWidget {
  @override
  _ObjectDetectionScreenState createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
  List<dynamic>? _recognitions;
  bool _isDetecting = false;

  CameraController? _cameraController;
  CameraImage? _cameraImage;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    String? result;
    try {
      result = await Tflite.loadModel(
        model: 'assets/object_detection_model.tflite',
        labels: 'assets/object_detection_labels.txt',
      );
    } catch (e) {
      print('Failed to load the model: $e');
    }
    print('Model load result: $result');
  }

  Future<void> detectObjects() async {
    if (!_isDetecting) {
      _isDetecting = true;

      try {
        if (_cameraImage != null) {
          final recognitions = await Tflite.runModelOnFrame(
            bytesList: _cameraImage!.planes.map((plane) {
              return plane.bytes;
            }).toList(),
            imageHeight: _cameraImage!.height,
            imageWidth: _cameraImage!.width,
            imageMean: 127.5,
            imageStd: 127.5,
            rotation: 90,
            threshold: 0.3,
            numResults: 10,
          );

          setState(() {
            _recognitions = recognitions;
          });
        }
      } catch (e) {
        print('Failed to run object detection: $e');
      }

      _isDetecting = false;
    }
  }

  Future<void> processCameraImage(CameraImage image) async {
    _cameraImage = image;
    await detectObjects();
  }

  Future<void> pickImageFromGallery() async {
    final pickedFile =
    await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      await detectImageObjects(image);
    }
  }

  Future<void> detectImageObjects(File image) async {
    final recognitions = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 127.5,
      imageStd: 127.5,
      threshold: 0.3,
      numResults: 10,
    );

    setState(() {
      _recognitions = recognitions;
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Object Detection'),
      ),
      body: Column(
          children: [
          Expanded(
          child: _cameraPreviewWidget(),
    ),
    Container(
    height: 200,
    child: ListView.builder(itemCount: _recognitions?.length ?? 0,
      itemBuilder: (context, index) {
        final recognition = _recognitions?[index];
        return ListTile(
          title: Text('${recognition['label']}'),
          subtitle: Text('Confidence: ${recognition['confidence']}'),
        );
      },
    ),
    ),
          ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImageFromGallery,
        child: Icon(Icons.image),
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    final size = MediaQuery.of(context).size;
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Container();
    }
    final aspectRatio = size.width / size.height;
    return OverflowBox(
      alignment: Alignment.center,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: CameraPreview(_cameraController!),
      ),
    );
  }
}

