import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  CardItem({
    required this.cardText,
    required this.cardColor,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.textSize,
    required this.textWeight,
    required this.textColor,
    required this.verticalPadding,
    super.key,
  });

  final String cardText;
  final Color cardColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double textSize;
  final FontWeight textWeight;
  final Color textColor;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: cardColor, // Warna latar belakang card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius), // Radius sudut card
        side: BorderSide(
          color: borderColor, // Warna border
          width: borderWidth, // Ketebalan border
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: Text(
            cardText,
            style: TextStyle(
              fontSize: textSize,
              fontWeight: textWeight,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
