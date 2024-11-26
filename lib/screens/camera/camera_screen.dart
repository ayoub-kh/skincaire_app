// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, prefer_const_constructors, unused_import

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skincaire_app/screens/camera/results_popup.dart';
import 'package:skincaire_app/screens/home/home_screen.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  XFile? _imageFile;
  bool _isCameraInitialized = false;
  final ImagePicker _picker = ImagePicker();
  int _currentCameraIndex = 0; // Index to track the current camera

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _cameraController =
          CameraController(_cameras![_currentCameraIndex], ResolutionPreset.high);
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras != null && _cameras!.length > 1) {
      setState(() {
        _isCameraInitialized = false;
      });

      // Toggle the camera index between 0 and 1 (or between available cameras)
      _currentCameraIndex = (_currentCameraIndex + 1) % _cameras!.length;

      _cameraController =
          CameraController(_cameras![_currentCameraIndex], ResolutionPreset.high);
      await _cameraController!.initialize();

      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  // Capture image using the camera
  Future<void> _captureImage() async {
    try {
      final XFile file = await _cameraController!.takePicture();
      setState(() {
        _imageFile = file;
      });
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview or Loader
          _isCameraInitialized
              ? CameraPreview(_cameraController!)
              : Center(child: CircularProgressIndicator()),

          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Download Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: _pickImage,
                      icon: Icon(Icons.download, color: Colors.black),
                      label: Text(
                        "Télécharger",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),

                // Middle Dashed Frame and Instruction
                Column(
                  children: [
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.orange[200]!,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DottedBorder(),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Positionnez la partie de peau concernée dans le cadre",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                // Bottom Buttons
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Cancel Button
                      IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
                        },
                        icon: Icon(Icons.close, color: Colors.white, size: 30),
                      ),
                      SizedBox(width: 40),
                      // Camera Button
                      FloatingActionButton(
                        onPressed: _captureImage,
                        backgroundColor: Colors.orange[200],
                        child: Icon(Icons.camera_alt, color: Colors.black),
                      ),
                      SizedBox(width: 40),
                      // Rotate Camera Button
                      IconButton(
                        onPressed: _switchCamera, // Use the switch camera function
                        icon: Icon(Icons.refresh, color: Colors.white, size: 30),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Display the image if captured or picked from gallery
          // if (_imageFile != null)
          //   Center(
          //     child: Image.file(
          //       File(_imageFile!.path),
          //       width: 250,
          //       height: 250,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          if (_imageFile != null) 
          FutureBuilder(
            future: Future.delayed(Duration(seconds: 5)),
            builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultsScreen(diagnosticResult: 'Resultssss',),
                ),
                // MaterialPageRoute(
                //   builder: (context) => HomeScreen(),
                // ),
              );
              });
            }
            return Center(
              child: Image.file(
              File(_imageFile!.path),
              width: 250,
              height: 250,
              fit: BoxFit.cover,
              ),
            );
            },
          ),
        ],
      ),
    );
  }
}

// Custom Dashed Border (Optional Widget)
class DottedBorder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        4,
            (index) => Positioned(
          top: index == 0 || index == 1 ? 0 : null,
          bottom: index == 2 || index == 3 ? 0 : null,
          left: index == 0 || index == 2 ? 0 : null,
          right: index == 1 || index == 3 ? 0 : null,
          child: Container(
            width: index % 2 == 0 ? 250 : 2,
            height: index % 2 == 1 ? 250 : 2,
            color: Colors.orange[200],
          ),
        ),
      ),
    );
  }
}
