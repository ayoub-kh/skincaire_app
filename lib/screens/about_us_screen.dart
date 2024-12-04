// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  final List<Map<String, String>> members = [
    {
      'name': 'Ayoub',
      'role': 'UI/UX Designer Développeur',
      'image': '' // Replace with actual paths
    },
    {
      'name': 'Manel',
      'role': 'Développpeuse Full Stack',
      'image': '' // Replace with actual paths
    },
    {
      'name': 'Tarkhan',
      'role': 'Data Scientist',
      'image': '' // Replace with actual paths
    },
    {
      'name': 'Ibrahim',
      'role': 'Data Scientist',
      'image': '' // Replace with actual paths
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous page
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'SkincAlre',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Arial',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png', // Replace with your logo asset
                    height: 100,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'À propos de Nous',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Nous facilitons l accès à une première analyse rapide des problèmes cutanés grâce à une application innovante basée sur l intelligence artificielle. En quelques clics, obtenez une probabilité des pathologies possibles à partir d une simple photo, pour mieux évaluer l urgence d une consultation médicale. Notre mission est d accompagner les utilisateurs dans un contexte de désert médical, en réduisant l attente et en priorisant les besoins.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 32),
            Text(
              'Les membres',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 4,
              ),
              itemCount: members.length, // Dynamically based on members list
              itemBuilder: (context, index) {
                final member = members[index];
                return MemberCard(
                  name: member['name']!,
                  role: member['role']!,
                  image: member['image']!,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String image;

  const MemberCard({
    required this.name,
    required this.role,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(image), // Use the provided image path
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            role,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
