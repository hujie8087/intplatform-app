
import 'package:flutter/material.dart';
import 'package:logistics_app/utils/color.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage>{
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/images/login_bg1_1.png'),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter
                ),
              )
            ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login_bg2_1.png'),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // 自适应键盘弹起不遮挡
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    margin: EdgeInsets.only(bottom: 40),
                    width: SizedBox.expand().width,
                    child: Text('修改密码', style: TextStyle(fontSize: 36, color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: _ChangePasswordForm(),
                  )
                ],
              ),
            ),
            // 返回按钮
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            )
          ],
        )
        // 居中显示
      ),
    );
  }

  Widget _ChangePasswordForm() {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: '请输入旧密码',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.lock_outlined, color: primaryColor),
              suffixIcon: IconButton(
                icon: Icon(Icons.remove_red_eye, color: primaryColor),
                onPressed: (){
                  print('点击了眼睛');
                },
              )
            ),
          ),
          SizedBox(height: 30,),
          TextFormField(
            decoration: InputDecoration(
              hintText: '请输入新密码',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.lock_outlined, color: primaryColor),
              suffixIcon: IconButton(
                icon: Icon(Icons.remove_red_eye, color: primaryColor),
                onPressed: (){
                  print('点击了眼睛');
                },
              )
            ),
          ),
          SizedBox(height: 30,),
          TextFormField(
            decoration: InputDecoration(
              hintText: '请再次输入新密码',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.lock_outlined, color: primaryColor),
              suffixIcon: IconButton(
                icon: Icon(Icons.remove_red_eye, color: primaryColor),
                onPressed: (){
                  print('点击了眼睛');
                },
              )
            ),
          ),
          SizedBox(height: 20,),
          // 提示信息
          Padding(padding: EdgeInsets.only(left: 15,right: 15),child: 
            Row(
              children: [
                Icon(Icons.info, color: primaryColor,size: 14,),
                Text('密码长度为6-16位，必须包含数字、字母、特殊字符', style: TextStyle(color: Colors.grey, fontSize: 12),),
              ],
            ),
          ),
          SizedBox(height: 30,),
          Padding(padding: EdgeInsets.only(left: 15,right: 15),child: 
            ElevatedButton(
              onPressed: (){},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primaryColor),
                minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)))
              ),
              child: Text('确认修改', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),),
            )
          ),
        ],
      ),
    );
  }

}
