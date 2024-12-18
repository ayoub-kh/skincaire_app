import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:skincaire_app/constants/constants.dart';
import 'package:skincaire_app/screens/camera/camera_screen.dart';
import 'package:skincaire_app/screens/home/home_screen.dart';
import 'package:skincaire_app/screens/report/maladie_card.dart';
import 'package:skincaire_app/screens/report/cause_card.dart';
import 'package:skincaire_app/screens/report/astuce_card.dart';
import 'package:http/http.dart' as http;

class ResultsScreen extends StatefulWidget {
  final int imageId;

  ResultsScreen({required this.imageId});

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<dynamic> diagnosticResult = [];
  bool isLoading = true;
  List<String> causesList = []; // List to store fetched causes
  List<String> treatmentList = []; // List to store fetched treatment
  String conditionDescription = ''; // Variable to store fetched condition description

  @override
  void initState() {
    super.initState();
    fetchPredictions();
    fetchCauses();
    fetchTreatment();
    fetchDescription();
  }

  Future<void> fetchPredictions() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/get-predictions/${widget.imageId}'));

      if (response.statusCode == 200) {
        final List<dynamic> results = jsonDecode(response.body);

        // Ensure all confidence values are treated as doubles
        for (var result in results) {
          if (result['probability_score'] is int) {
            result['probability_score'] = (result['probability_score'] as int).toDouble();
          }
        }

        // Sort by probability_score in descending order
        results.sort((a, b) => b['probability_score'].compareTo(a['probability_score']));

        // Take the top 4 predictions
        final diagnosticResults = results.take(4).toList();

        setState(() {
          diagnosticResult = diagnosticResults;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch predictions: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching predictions: $error');
    }
  }

  Future<void> fetchCauses() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/get-causes/${widget.imageId}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        String causesString = result['causes'];

        // Split the causes string by commas to create a list
        setState(() {
          causesList = causesString.split(','); // Update causesList
          print('Causes: $causesList');
        });
      } else {
        throw Exception('Failed to fetch causes: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching causes: $error');
    }
  }

  Future<void> fetchTreatment() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/get-treatment/${widget.imageId}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        String treatmentString = result['treatment'];

        setState(() {
          treatmentList = treatmentString.split(','); // Split the treatment string by commas
          print('Treatment: $treatmentList');
        });
      } else {
        throw Exception('Failed to fetch treatment: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching treatment: $error');
    }
  }

  Future<void> fetchDescription() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/get-condition-description/${widget.imageId}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        String description = result['description'];

        // Set the state with the fetched description
        setState(() {
          conditionDescription = description; // Update your conditionDescription variable
          print('Condition Description: $conditionDescription');
        });
      } else {
        throw Exception('Failed to fetch condition description: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching condition description: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: peach,
        title: Text(
          'Resultats',
          style: TextStyle(
            color: black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close, color: black),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen()));
          },
        ),
      ),
      floatingActionButton: Container(
        height: 50.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(bottom: 20.0),
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          backgroundColor: peach,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: brown, width: 1.0),
          ),
          child: Text(
            'Terminer',
            style: TextStyle(
              color: brown,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: peach.withOpacity(0.3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Maladies statistiques',
                      style: TextStyle(
                        color: black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    GridView.builder(
                      itemCount: diagnosticResult.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 1.2,
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var result = diagnosticResult[index];
                        return MaladieWidget(
                          title: result['condition_name'],
                          percentage: result['probability_score'],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Causes possibles',
                      style: TextStyle(
                        color: black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    // Show causes dynamically
                    causesList.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: causesList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (context, index) {
                        return CauseWidget(
                          title: causesList[index],

                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: brown,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A propos de maladie 1',
                      style: TextStyle(
                        color: white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      conditionDescription.isEmpty
                          ? 'Loading description...'  // This is a placeholder while the description is being fetched
                          : conditionDescription,     // This displays the fetched description
                      style: TextStyle(
                        color: Colors.grey[50],
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          // Add your link action here
                        },
                        child: Text(
                          'Lire plus',
                          style: TextStyle(
                            color: white,
                            fontSize: 14.0,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                margin: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Astuces',
                      style: TextStyle(
                        color: black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    // Show treatment dynamically
                    treatmentList.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: treatmentList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 2.5,
                      ),
                      itemBuilder: (context, index) {
                        return AstuceWidget(
                          title: treatmentList[index],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Function to show the results popup
void showResultsPopup(BuildContext context, int imageId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ResultsScreen(imageId: imageId),
  );
}
