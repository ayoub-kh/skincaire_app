import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:skincaire_app/screens/camera/results_popup.dart';
import 'package:tflite_v2/tflite_v2.dart';

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
  String? _result; // For storing the result of prediction
  List<dynamic> output = [];
  int imageId = -1;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    loadModel();
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
        classifyImage(file.path);
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
      classifyImage(pickedFile.path);
    }
  }

  Future<void> loadModel() async {
    String? res = await Tflite.loadModel(
      model: "assets/model_test.tflite",
      labels: "assets/labels.txt",
    );
    print("Model loaded: $res");
  }

  Future<void> classifyImage(String imagePath) async {
    try {
      // First, upload the image to the server
      final uri = Uri.parse('http://10.0.2.2:3000/upload-image');
      print('Uploading image to $uri');
      var request = http.MultipartRequest('POST', uri);

      // Attach the image file
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      // Send the request
      var response = await request.send();
      print('Response: $response');

      if (response.statusCode == 200) {
        final responseBody = await http.Response.fromStream(response);
        print('Response body: ${responseBody.body}');
        final data = jsonDecode(responseBody.body);

        // Ensure 'imageId' is returned by the server
        if (data['imageId'] == null) {
          print('Error: Image ID is null');
          return;
        }

        imageId = data['imageId'];  // Extract imageId from the response
        print('Image uploaded successfully with Image ID: $imageId');

        // Now run image classification after image upload
        var output = await Tflite.runModelOnImage(
          path: imagePath,
          imageMean: 127.5,
          imageStd: 127.5,
          numResults: 4,
          threshold: 0.0,
        );

        print("Output: $output");

        if (output == null || output.isEmpty) {
          print('No predictions found');
          return;
        }

        setState(() {
          _result = output != null && output.isNotEmpty
              ? output.map((e) => "${e['label']} (${(e['confidence'] * 100).toStringAsFixed(2)}%)").join("\n")
              : "Aucun résultat trouvé.";
        });

        // Send predictions to the backend
        if (imageId != null && output.isNotEmpty) {
          sendPrediction(imageId, output);
        } else {
          print('Failed to get valid imageId or predictions');
        }

      } else {
        print('Failed to upload image, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during image upload and classification: $e');
    }
  }

  Future<void> sendPrediction(int imageId, List<dynamic> predictions) async {
    try {
      for (var prediction in predictions) {
        // Extract the label from the prediction and use it as condition_name
        String conditionName = prediction['label'];

        // Fetch the condition_id based on the condition_name
        final url = Uri.parse('http://10.0.2.2:3000/get-condition-id/$conditionName');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          // Parse the response to get the condition_id
          final data = jsonDecode(response.body);
          int conditionId = data['conditionId'];

          // Send the prediction to save it in the database
          final savePredictionUrl = Uri.parse('http://10.0.2.2:3000/save-prediction');
          final saveResponse = await http.post(
            savePredictionUrl,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              'image_id': imageId,
              'condition_id': conditionId, // Send the valid condition_id
              'probability_score': prediction['confidence'],
            }),
          );

          if (saveResponse.statusCode == 200) {
            print('Prediction for $conditionName saved successfully');
          } else {
            print('Failed to save prediction for $conditionName: ${saveResponse.body}');
          }
        } else {
          print('Error fetching condition_id for $conditionName: ${response.body}');
        }
      }

      // After all predictions are processed, notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Predictions saved successfully')),
      );
    } catch (e) {
      print('Error sending predictions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending predictions')),
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    Tflite.close();
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
            FutureBuilder(
              future: Future.delayed(Duration(seconds: 10)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultsScreen(imageId: imageId),
                      ),
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
