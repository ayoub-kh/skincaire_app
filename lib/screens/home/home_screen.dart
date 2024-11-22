// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:skincaire_app/constants/constants.dart';
import 'package:skincaire_app/model/conseil.dart';
import 'package:skincaire_app/screens/report/report_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Conseil> conseils = [
      Conseil(title: 'Utilisez un nettoyant doux'),
      Conseil(title: 'Hydratez votre peau'),
      Conseil(title: 'Protégez votre peau du soleil'),
      Conseil(title: 'Mangez sainement'),
      Conseil(title: 'Dormez suffisamment'),
      Conseil(title: 'Buvez de l\'eau'),
      Conseil(title: 'Faites de l\'exercice'),
      Conseil(title: 'Évitez le stress'),
      Conseil(title: 'Utilisez des produits adaptés à votre peau'),
      Conseil(title: 'Consultez un dermatologue régulièrement'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Image.asset('assets/images/logo_horizental.png')),
        backgroundColor: peach,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: peach,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/hands_home.png'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PRENONS SOINS DE \n'
                            'VOTRE PEAU!',
                            style: TextStyle(
                              color: brown,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 10.0),
                          ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
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
                              'Daily Routine',
                              style: TextStyle(
                                color: brown,
                                fontSize: 16.0,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 8.0),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Conseils quotidiens',
                style: TextStyle(
                  color: black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: conseils.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 200,
                    margin: EdgeInsets.only(left: 16.0),
                    decoration: BoxDecoration(
                      color: peach.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          conseils[index].title,
                          style: TextStyle(
                            color: brown,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Les meilleurs produits',
                style: TextStyle(
                  color: black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio:
                    1.5, // Adjusted the aspect ratio to reduce height
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: peach.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 120, // Reduced height
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/produit.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10.0)),
                        ),
                      ),
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
        currentIndex: 0,
        selectedItemColor: brown,
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(color: brown),
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ReportScreen()));
          }
          // Handle other navigation if needed
        },
      ),
    );
  }
}
