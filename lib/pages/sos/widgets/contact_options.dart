import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class ContactOptions extends StatelessWidget {
  final VoidCallback onPhoneCall;
  final VoidCallback onChat;
  final VoidCallback onVoiceMessage;

  const ContactOptions({
    super.key,
    required this.onPhoneCall,
    required this.onChat,
    required this.onVoiceMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20.px,
            offset: Offset(0, 10.px),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.px),
                decoration: BoxDecoration(
                  color: Color(0xFFFFEBEE),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.support_agent,
                  color: Color(0xFFd32f2f),
                  size: 24.px,
                ),
              ),
              SizedBox(width: 12.px),
              Text(
                S.current.select_contact_method,
                style: TextStyle(
                  fontSize: 16.px,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1a1a2e),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.px),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildContactOption(
                icon: Icons.phone,
                label: S.current.call_phone,
                onTap: onPhoneCall,
              ),
              _buildContactOption(
                icon: Icons.chat_bubble,
                label: S.current.emergency_chat,
                onTap: onChat,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110.px,
        padding: EdgeInsets.symmetric(vertical: 20.px, horizontal: 16.px),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFd32f2f), Color(0xFFc62828)],
          ),
          borderRadius: BorderRadius.circular(16.px),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFd32f2f).withOpacity(0.3),
              blurRadius: 12.px,
              offset: Offset(0, 6.px),
              spreadRadius: -3,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.px),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24.px, color: Colors.white),
            ),
            SizedBox(height: 16.px),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.px,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5.px,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
