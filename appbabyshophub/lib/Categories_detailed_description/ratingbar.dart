import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingSection extends StatelessWidget {
  final double currentRating;
  final ValueChanged<double> onRatingUpdate;

  RatingSection({required this.currentRating, required this.onRatingUpdate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RatingBar.builder(
          initialRating: currentRating,
          minRating: 1,
          itemSize: 39,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
            size: 20,
          ),
          onRatingUpdate: onRatingUpdate,
        ),
        SizedBox(width: 10),
        Text(
          '(${currentRating.toStringAsFixed(1)})',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w600, color: Colors.red),
        ),
      ],
    );
  }
}