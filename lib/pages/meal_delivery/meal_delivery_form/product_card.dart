import 'package:flutter/material.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final bool isSelected;
  final VoidCallback onTap;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.productName,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.px, vertical: 12.px),
        decoration: ShapeDecoration(
          color: Color(0xFFFFFFF2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.px),
            side: BorderSide(
              color: isSelected ? primaryColor : Colors.transparent,
              width: 2.0,
            ),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x66D6D3C0),
              blurRadius: 20.px,
              offset: Offset(0, 8.px),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 92.px,
              height: 100.px,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 12.px),
            Text(
              productName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? primaryColor : Colors.black,
                fontSize: 14.px,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
