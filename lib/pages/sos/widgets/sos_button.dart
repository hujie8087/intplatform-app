import 'package:flutter/material.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class SOSButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isDisabled;

  const SOSButton({
    super.key,
    required this.onPressed,
    this.isDisabled = false,
  });

  @override
  State<SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    if (!widget.isDisabled) {
      _pulseController.repeat(reverse: true);
    }

    _rippleController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );
    if (!widget.isDisabled) {
      _rippleController.repeat();
    }
  }

  @override
  void didUpdateWidget(SOSButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDisabled != oldWidget.isDisabled) {
      if (widget.isDisabled) {
        _pulseController.stop();
        _rippleController.stop();
      } else {
        _pulseController.repeat(reverse: true);
        _rippleController.repeat();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160.px,
      height: 160.px,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!widget.isDisabled)
            AnimatedBuilder(
              animation: _rippleAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: 1 - _rippleAnimation.value,
                  child: Container(
                    width: 160 + (40 * _rippleAnimation.value),
                    height: 160 + (40 * _rippleAnimation.value),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFFff1744), width: 2),
                    ),
                  ),
                );
              },
            ),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isDisabled ? 1.0 : _pulseAnimation.value,
                child: Container(
                  width: 160.px,
                  height: 160.px,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors:
                          widget.isDisabled
                              ? [Colors.grey, Colors.grey[600]!]
                              : [
                                const Color(0xFFff1744),
                                const Color(0xFFd32f2f),
                                const Color(0xFFc62828),
                              ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (widget.isDisabled
                                ? Colors.grey
                                : const Color(0xFFff1744))
                            .withOpacity(0.5),
                        blurRadius: 30.px,
                        spreadRadius: 10.px,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(100.px),
                      onTap: widget.isDisabled ? null : widget.onPressed,
                      splashColor: Colors.white.withOpacity(0.3),
                      highlightColor: Colors.white.withOpacity(0.1),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2.px,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                widget.isDisabled
                                    ? Icons.check_circle
                                    : Icons.emergency,
                                size: 48.px,
                                color: Colors.white,
                              ),
                              SizedBox(height: 10.px),
                              Text(
                                widget.isDisabled ? '已报警' : 'SOS',
                                style: TextStyle(
                                  fontSize: 24.px,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 4.px,
                                ),
                              ),
                              SizedBox(height: 4.px),
                              Text(
                                widget.isDisabled ? '请选择联系方式' : '按下报警',
                                style: TextStyle(
                                  fontSize: 12.px,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
