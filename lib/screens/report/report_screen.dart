// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:skincaire_app/constants/constants.dart';
import 'package:skincaire_app/screens/camera/camera_screen.dart';
import 'package:skincaire_app/screens/home/home_screen.dart';
import 'package:skincaire_app/screens/report/maladie_card.dart';
import 'package:skincaire_app/screens/report/cause_card.dart';
import 'package:skincaire_app/screens/report/astuce_card.dart';
//import 'package:skincaire_app/model/conseil.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Image.asset('assets/images/logo_horizental.png')),
        backgroundColor: peach,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: peach,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Résultats du \n' 
                        'diagnostic',
                        style: TextStyle(
                          color: brown,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        alignment: Alignment.centerLeft,
                        // fixedSize: Size(400, 40.0),
                        backgroundColor: white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 16.0,
                        ),
                      ),
                      icon: Icon(
                        Icons.calendar_today,
                        color: brown,
                      ),
                      label: Text(
                        'Date du diagnostic',
                        style: TextStyle(
                          color: brown,
                          fontSize: 16.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
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
                  GridView.count(
                    childAspectRatio: 1.8,
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      MaladieWidget(title: 'Maladie 1', percentage: 0.75),
                      MaladieWidget(title: 'Maladie 2', percentage: 0.50),
                      MaladieWidget(title: 'Maladie 3', percentage: 0.30),
                      MaladieWidget(title: 'Maladie 4', percentage: 0.90),
                    ],
                  ),
                ],
              ),
            ),
            // SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(10.0),
              //   color: peach.withOpacity(0.3),
              // ),
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
                    childAspectRatio: 1,
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                // color: peach.withOpacity(0.3),
              ),
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
            Container(
              padding: EdgeInsets.only(left: 16.0),
              margin: EdgeInsets.only(left: 16.0, bottom: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                // color: peach.withOpacity(0.3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Produits recommandés',
                    style: TextStyle(
                      color: black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16,),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(right: 16.0),
                          decoration: BoxDecoration(
                            color: peach.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 120, // Reduced height
                                width: 130,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/produit.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10.0)),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Produit ${index + 1}',
                                style: TextStyle(
                                  color: brown,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Rapport',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: brown,
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(color: brown),
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }
          else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CameraScreen()));
          }
        },
      ),
    );
  }
}






