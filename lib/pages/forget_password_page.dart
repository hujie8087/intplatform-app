
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/forgetPassword_bg.png'),
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              margin: EdgeInsets.only(top:100,bottom: 50),
              width: SizedBox.expand().width,
              child: Text('重置密码', style: TextStyle(fontSize: 36, color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextField(
                      autofocus: true,
                      cursorColor: Colors.blue,
                      style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: '请输入您的工号',
                        prefixIcon: Icon(Icons.person_2_outlined,color: Colors.blue,),
                        border: InputBorder.none,
                      ),
                      onChanged: (value){
                        print(value);
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextField(
                      cursorColor: Colors.blue,
                      style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: '请输入新密码',
                        prefixIcon: Icon(Icons.lock,color: Colors.blue,),
                        border: InputBorder.none,
                      ),
                      obscureText:true,
                      onChanged: (value){
                        print(value);
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextField(
                      cursorColor: Colors.blue,
                      style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: '请再次输入新密码',
                        prefixIcon: Icon(Icons.lock,color: Colors.blue,),
                        border: InputBorder.none,
                      ),
                      obscureText:true,
                      onChanged: (value){
                        print(value);
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: (){},
                      child: Text('确认重置',style: TextStyle(fontSize: 16,color: Colors.white),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        minimumSize: MaterialStateProperty.all(Size(double.infinity, 40)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),),
    );
  }

}
 