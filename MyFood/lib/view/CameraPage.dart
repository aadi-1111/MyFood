import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';

class CameraSetup{
  static Future<void> runCamera(context) async{
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage(camera: firstCamera,)));
  }
}


class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.camera}) : super(key: key);

  final CameraDescription camera;

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Take a photo"),backgroundColor: Colors.orange,),
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  return CameraPreview(_controller);
                }
                else{
                  return const Center(child: CircularProgressIndicator(),);
                }
              }
          ),
          Positioned(
            bottom: 10,
            child: Container(
              height: 75,
              width: 75,
              child: FloatingActionButton(
                backgroundColor: Colors.orange,
                onPressed: () async {
                  // Take the Picture in a try / catch block. If anything goes wrong,
                  // catch the error.
                  try {
                  // Ensure that the camera is initialized.
                    await _initializeControllerFuture;
                    // Attempt to take a picture and get the file `image`
                    // where it was saved.
                    final image = await _controller.takePicture();
                    // If the picture was taken, display it on a new screen.
                    await Navigator.of(context).push(
                    MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(imagePath: image.path),),);
                  } catch (e) {
                    // If an error occurs, log the error to the console.
                    print(e);
                  }
                },
                child: const Icon(Icons.camera_alt),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Taken'), backgroundColor: Colors.orange,),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
          ),
          Positioned(
            bottom: 10,
            child: FloatingActionButton(
              onPressed: () async {
                await uploadFile(imagePath);
                //bad code but gets the job done lol
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Icon(Icons.check),
            ),
          )
        ],
      )
    );
  }
}

Future<void> uploadFile(String filePath) async {
  File file = File(filePath);
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await firebase_storage.FirebaseStorage.instance
        .ref('profilePics/' + auth.currentUser!.uid)
        .putFile(file);
  } catch (e) {
    print(e);
  }
}
