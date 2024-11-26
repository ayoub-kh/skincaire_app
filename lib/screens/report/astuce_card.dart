// ignore_for_file: unused_element
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:skincaire_app/constants/constants.dart';


class AstuceWidget extends StatelessWidget {
  const AstuceWidget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: peach.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: brown, width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: brown,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Description de l\'astuce',
            style: TextStyle(
              color: brown,
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                // Add your link action here
              },
              child: Text(
                'Lire plus',
                style: TextStyle(
                  color: brown,
                  fontSize: 14.0,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}