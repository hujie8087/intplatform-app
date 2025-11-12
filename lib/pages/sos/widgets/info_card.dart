import 'package:flutter/material.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 40.px),
      padding: EdgeInsets.all(16.px),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFFAFAFA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20.px,
            offset: Offset(0, 10.px),
            spreadRadius: -5.px,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.px),
            decoration: BoxDecoration(
              color: Color(0xFFFFEBEE),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFd32f2f).withOpacity(0.2),
                  blurRadius: 10.px,
                  spreadRadius: 2.px,
                ),
              ],
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              size: 36.px,
              color: Color(0xFFd32f2f),
            ),
          ),
          SizedBox(height: 16.px),
          Text(
            '紧急报警系统',
            style: TextStyle(
              fontSize: 20.px,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1a1a2e),
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 8.px),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 6.px),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(16.px),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.security, size: 14.px, color: Color(0xFFd32f2f)),
                SizedBox(width: 8.px),
                Text(
                  '24小时响应',
                  style: TextStyle(
                    fontSize: 12.px,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFd32f2f),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.px),
          Text(
            '遇到紧急情况请立即按下报警按钮\n安全团队将在第一时间为您提供帮助',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.px,
              color: Color(0xFF757575),
              height: 1.4.px,
              letterSpacing: 0.2.px,
            ),
          ),
        ],
      ),
    );
  }
}
