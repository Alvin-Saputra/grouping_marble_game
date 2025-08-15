import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    required this.cardText,
    required this.cardColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.textSize,
    required this.textWeight,
    required this.textColor,
    required this.verticalPadding,
    this.shadowColor, // tidak required, bisa null
  });

  final String cardText;
  final Color cardColor;
  final double borderWidth;
  final double borderRadius;
  final double textSize;
  final FontWeight textWeight;
  final Color textColor;
  final double verticalPadding;
  final Color? shadowColor; // nullable

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadowColor != null
            ? [
                BoxShadow(
                  color: shadowColor!,
                  offset: const Offset(4, 4),
                  blurRadius: 0,
                  spreadRadius: 2,
                ),
              ]
            : [], // kalau null → tidak ada shadow
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: Center(
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
