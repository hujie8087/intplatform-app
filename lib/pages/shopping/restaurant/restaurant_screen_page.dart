import 'package:flutter/material.dart';
import 'package:logistics_app/pages/shopping/restaurant/components/restaurant_body.dart';
import 'package:provider/provider.dart';
import 'package:logistics_app/pages/shopping/food_view_model.dart';

class RestaurantScreenPage extends StatefulWidget {
  const RestaurantScreenPage({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  _RestaurantScreenPageState createState() => _RestaurantScreenPageState();
}

class _RestaurantScreenPageState extends State<RestaurantScreenPage> {
  final foodViewModel = FoodViewModel();

  @override
  void initState() {
    super.initState();
    // 初始化购物车数据
    foodViewModel.initCartData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: foodViewModel,
      child: Scaffold(
        body: SafeArea(
          top: false,
          bottom: false,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/restaurant-bg.jpg'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter)),
            child: RestaurantBody(
              id: widget.id,
            ),
          ),
        ),
      ),
    );
  }
}
