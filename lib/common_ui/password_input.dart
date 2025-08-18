import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class PasswordInput extends StatefulWidget {
  final int length; // 密码长度
  final ValueChanged<String>? onCompleted; // 输入完成回调
  final bool obscureText; // 是否隐藏密码

  const PasswordInput({
    Key? key,
    this.length = 6,
    this.onCompleted,
    this.obscureText = true,
  }) : super(key: key);

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    controllers =
        List.generate(widget.length, (index) => TextEditingController());
    focusNodes = List.generate(widget.length, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // 获取完整密码
  String _getFullPassword() {
    return controllers.map((controller) => controller.text).join();
  }

  Widget _buildPasswordInput(int index) {
    return Container(
      width: 40.px,
      height: 40.px,
      margin: EdgeInsets.symmetric(horizontal: 3.px),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.px),
      ),
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {
          if (event.logicalKey == LogicalKeyboardKey.backspace) {
            if (controllers[index].text.isEmpty && index > 0) {
              focusNodes[index - 1].requestFocus();
            }
          }
        },
        child: TextField(
          controller: controllers[index],
          focusNode: focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (index < widget.length - 1) {
                focusNodes[index + 1].requestFocus();
              } else {
                FocusScope.of(context).unfocus();
                // 输入完成时触发回调
                if (widget.onCompleted != null) {
                  widget.onCompleted!(_getFullPassword());
                }
              }
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return _buildPasswordInput(index);
      }),
    );
  }

  // 清空所有输入
  void clear() {
    controllers.forEach((controller) => controller.clear());
  }
}
