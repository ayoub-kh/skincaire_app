// ignore_for_file: prefer_const_constructors, unused_import, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:skincaire_app/constants/constants.dart';
import 'package:skincaire_app/screens/camera/camera_screen.dart';
import 'package:skincaire_app/screens/home/home_screen.dart';
import 'package:skincaire_app/screens/report/maladie_card.dart';
import 'package:skincaire_app/screens/report/cause_card.dart';
import 'package:skincaire_app/screens/report/astuce_card.dart';

class ResultsScreen extends StatelessWidget {
  final List<dynamic> diagnosticResult;

  ResultsScreen({required this.diagnosticResult});

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
            Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(),));
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
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
      body: SingleChildScrollView(
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
                            title: result['label'].split('-')[1],
                          percentage: result['confidence'],
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
                    GridView.count(
                      childAspectRatio: 0.9,
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        CauseWidget(title: 'Cause 1', percentage: 0.60),
                        CauseWidget(title: 'Cause 2', percentage: 0.45),
                        CauseWidget(title: 'Cause 3', percentage: 0.80),
                        CauseWidget(title: 'Cause 4', percentage: 0.55),
                      ],
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
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.',
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
                    GridView.count(
                      childAspectRatio: 2.5,
                      crossAxisCount: 1,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        AstuceWidget(title: 'Astuce 1'),
                        AstuceWidget(title: 'Astuce 2'),
                        AstuceWidget(title: 'Astuce 3'),
                      ],
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
void showResultsPopup(BuildContext context, List<dynamic> result) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ResultsScreen(diagnosticResult: result),
  );
}
