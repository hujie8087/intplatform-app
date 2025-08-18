import 'package:flutter/material.dart';
import 'package:logistics_app/http/model/meal_delivery_model.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class AddButton extends StatefulWidget {
  final MealDeliveryOrderModel order;
  final String title;
  final Color? color;
  const AddButton({
    Key? key,
    required this.order,
    required this.title,
    this.color,
  }) : super(key: key);

  @override
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  void initState() {
    super.initState();
    // Initialization code goes here
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.px, right: 10.px, top: 15.px),
      height: 36.px,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.px),
        ),
        shadows: [
          BoxShadow(
            color: Color.fromRGBO(223, 224, 224, 1),
            blurRadius: 20.px,
            offset: Offset(0, 8.px),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: widget.color ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.px),
          ),
        ),
        child: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.px,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
