import 'package:flutter/material.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/utils/color.dart';

class PersonInfoPage extends StatefulWidget {
  @override
  _PersonInfoPageState createState() => _PersonInfoPageState();
}

class _PersonInfoPageState extends State<PersonInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            '个人信息',
            style: TextStyle(fontSize: 18),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // 自适应键盘弹起不遮挡
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _PersonInfoForm(),
                  ),
                  _PersonInfoFormButton(() => {})
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _PersonInfoForm() {
    return Column(
      children: [
        // 头像
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                  image: AssetImage('assets/images/userImage.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.centerLeft)),
        ),
        _PersonInfoItem('姓名', '张三', Icons.person),
        // 工号
        _PersonInfoItem('工号', '123456', Icons.workspace_premium),
        _PersonInfoItem('性别', '男', Icons.wc),
        _PersonInfoItem('年龄', '25', Icons.cake),
        _PersonInfoItem('电话', '12345678901', Icons.phone),
        _PersonInfoItem('邮箱', '123456@qq.com', Icons.email),
        // 公司
        _PersonInfoItem('公司', 'XXX公司', Icons.business),
        // 部门
        _PersonInfoItem('部门', '技术部', Icons.work),
        // 职位
        _PersonInfoItem('职位', '工程师', Icons.work_outline),
      ],
    );
  }

  Widget _PersonInfoItem(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(width: 1, color: Colors.grey.withOpacity(0.2)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // 图标
              Icon(
                icon,
                color: primaryColor,
                size: 18,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          )
        ],
      ),
    );
  }

  ///修改信息按钮
  Widget _PersonInfoFormButton(GestureTapCallback? onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 70, right: 70, top: 50),
            decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Text("修改信息",
                style: TextStyle(color: Colors.white, fontSize: 16))));
  }
}
