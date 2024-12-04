// ignore_for_file: unused_element
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:skincaire_app/constants/constants.dart';

class MaladieWidget extends StatelessWidget {
  const MaladieWidget({
    super.key,
    required this.title,
    required this.percentage,
  });

  final String title;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                color: brown,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            '${(percentage * 100).toStringAsFixed(1)}%',
            style: TextStyle(
              color: brown,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          LinearProgressIndicator(
            minHeight: 8.0,
            value: percentage,
            backgroundColor: peach.withOpacity(0.4),
            valueColor: AlwaysStoppedAnimation<Color>(peach),
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }
}