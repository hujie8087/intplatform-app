import 'package:flutter/material.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/sp_utils.dart';

class AvatarWidget extends StatefulWidget {
  const AvatarWidget({super.key, this.width = 40});

  final double? width;

  @override
  State<AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  String avatar = '';
  String imagePrefix = '';
  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    // 模拟异步数据获取
    var userInfo = await SpUtils.getModel('userInfo');
    imagePrefix =
        await SpUtils.getString(Constants.SP_IMAGE_PREFIX) ?? APIs.imagePrefix;
    avatar = userInfo != null ? userInfo['user']['avatar'] : '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return avatar.isNotEmpty
        ? Container(
            width: widget.width,
            height: widget.width,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(imagePrefix + avatar),
                  fit: BoxFit.fill,
                ),
                color: primaryColor),
          )
        : Container();
  }
}
