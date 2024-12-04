// Flutter imports remain unchanged
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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
  int _currentCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Initialize the camera
  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _cameraController = CameraController(
            _cameras![_currentCameraIndex], ResolutionPreset.high);
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
        print('Camera initialized');
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  // Switch between the front and back camera
  Future<void> _switchCamera() async {
    if (_cameras != null && _cameras!.length > 1) {
      setState(() {
        _isCameraInitialized = false;
      });

      // Dispose the current camera controller before switching
      await _cameraController?.dispose();

      _currentCameraIndex = (_currentCameraIndex + 1) % _cameras!.length;

      _cameraController = CameraController(
          _cameras![_currentCameraIndex], ResolutionPreset.high);

      try {
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      } catch (e) {
        print('Error initializing camera: $e');
      }
    }
  }

  // Capture image using the camera
  Future<void> _captureImage() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final XFile file = await _cameraController!.takePicture();
        setState(() {
          _imageFile = file;
        });
        print('Image captured: ${file.path}');
      } catch (e) {
        print('Error capturing image: $e');
      }
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

  // Upload the captured or picked image to the server
  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      try {
        // Prepare the request
        final uri = Uri.parse('http://10.0.2.2:3000/upload-image');
        print('Uploading image to $uri');
        var request = http.MultipartRequest('POST', uri);

        // Attach the image file
        request.files.add(
            await http.MultipartFile.fromPath('image', _imageFile!.path));

        // Send the request
        var response = await request.send();
        print('Response: $response');

        if (response.statusCode == 200) {
          // Get response body and parse the URL from response
          final responseBody = await http.Response.fromStream(response);
          print('Response body: ${responseBody.body}');
          final data = jsonDecode(responseBody.body);
          String imageUrl = data['imageUrl'];

          // Log success
          print('Image uploaded successfully, URL: $imageUrl');

          // You may show the URL to the user or take further action
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image uploaded successfully!'),
            ),
          );
        } else {
          print('Failed to upload image, status code: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image upload failed. Try again.'),
            ),
          );
        }
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image.'),
          ),
        );
      }
    } else {
      print('No image selected to upload.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please capture or select an image first.'),
        ),
      );
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
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _isCameraInitialized
              ? CameraPreview(_cameraController!)
              : Center(child: CircularProgressIndicator()),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close, color: Colors.white, size: 30),
                      ),
                      SizedBox(width: 40),
                      FloatingActionButton(
                        onPressed: () async {
                          await _captureImage();
                          await _uploadImage(); // Upload image after capture
                        },
                        backgroundColor: Colors.orange[200],
                        child: Icon(Icons.camera_alt, color: Colors.black),
                      ),
                      SizedBox(width: 40),
                      IconButton(
                        onPressed: _switchCamera,
                        icon: Icon(Icons.refresh, color: Colors.white, size: 30),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_imageFile != null)
            Center(
              child: Image.file(
                File(_imageFile!.path),
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }
}

// Custom Dashed Border
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
