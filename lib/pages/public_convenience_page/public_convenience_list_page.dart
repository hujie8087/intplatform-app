import 'package:flutter/material.dart';
import 'package:logistics_app/utils/color.dart';

class PublicConvenienceListPage extends StatefulWidget {
  @override
  _PublicConvenienceListPage createState() => _PublicConvenienceListPage();
}

class _PublicConvenienceListPage extends State<PublicConvenienceListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '公共便利',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.left,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '请选择设施类型',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Icon(
                            Icons.arrow_downward,
                            size: 18,
                            color: primaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '请选择区域',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Icon(
                            Icons.arrow_downward,
                            size: 18,
                            color: primaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              child: _items(),
            )
          ],
        ),
      ),
    );
  }

  Widget _items() {
    return Text('');
  }
}
