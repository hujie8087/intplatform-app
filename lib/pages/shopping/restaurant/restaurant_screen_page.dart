import 'package:flutter/material.dart';
import 'package:logistics_app/pages/shopping/restaurant/components/restaurant_body.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:provider/provider.dart';

class RestaurantScreenPage extends StatefulWidget {
  const RestaurantScreenPage({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  _RestaurantScreenPageState createState() => _RestaurantScreenPageState();
}

class _RestaurantScreenPageState extends State<RestaurantScreenPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {},
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            Positioned.fill(
                child: RestaurantBody(
              id: widget.id,
            )),
            Positioned(
              child: AppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
              ),
              top: 0,
              left: 0,
              right: 0,
            )
          ],
        ),
      ),
    );
  }
}
