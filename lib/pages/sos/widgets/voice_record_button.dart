import 'dart:math';
import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class VoiceRecordButton extends StatefulWidget {
  final Function startRecording;
  final Function stopRecording;
  final Function cancelRecording;

  const VoiceRecordButton({
    super.key,
    required this.startRecording,
    required this.stopRecording,
    required this.cancelRecording,
  });

  @override
  State<VoiceRecordButton> createState() => _VoiceRecordButtonState();
}

class _VoiceRecordButtonState extends State<VoiceRecordButton>
    with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  bool _isCancel = false;
  Offset _startPosition = Offset.zero;

  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _onLongPressStart(LongPressStartDetails details) {
    _startPosition = details.globalPosition;
    setState(() {
      _isRecording = true;
      _isCancel = false;
    });
    widget.startRecording();
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    double dy = details.globalPosition.dy - _startPosition.dy;
    if (dy < -50) {
      if (!_isCancel) setState(() => _isCancel = true);
    } else {
      if (_isCancel) setState(() => _isCancel = false);
    }
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    if (_isRecording) {
      if (_isCancel) {
        widget.cancelRecording();
      } else {
        widget.stopRecording();
      }
      setState(() {
        _isRecording = false;
        _isCancel = false;
      });
    }
  }

  void _onLongPressCancel() {
    if (_isRecording) {
      widget.cancelRecording();
      setState(() {
        _isRecording = false;
        _isCancel = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onLongPressStart: _onLongPressStart,
          onLongPressMoveUpdate: _onLongPressMoveUpdate,
          onLongPressEnd: _onLongPressEnd,
          onLongPressCancel: _onLongPressCancel,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: double.infinity,
            height: 44.px,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color:
                  _isRecording
                      ? (_isCancel ? Colors.grey[400] : Colors.red[400])
                      : Colors.white,
              borderRadius: BorderRadius.circular(8.px),
              border: Border.all(color: Colors.red),
            ),
            child: Text(
              _isRecording
                  ? (_isCancel
                      ? S.current.release_finger_to_cancel
                      : S.current.release_to_send)
                  : S.current.press_to_speak,
              style: TextStyle(
                color: _isRecording ? Colors.white : Colors.red,
                fontSize: 14.px,
              ),
            ),
          ),
        ),

        /// 录音提示浮层
        if (_isRecording)
          Positioned(top: -150, child: _buildRecordingOverlay()),
      ],
    );
  }

  Widget _buildRecordingOverlay() {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 160.px,
        padding: EdgeInsets.all(16.px),
        decoration: BoxDecoration(
          color: _isCancel ? Colors.red[400] : Colors.black87,
          borderRadius: BorderRadius.circular(12.px),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isCancel)
              Icon(Icons.delete_forever, color: Colors.white, size: 40.px)
            else
              _buildWaveformAnimation(),
            SizedBox(height: 8.px),
            Text(
              _isCancel
                  ? S.current.release_finger_to_cancel
                  : S.current.recording_audio,
              style: TextStyle(color: Colors.white, fontSize: 12.px),
            ),
          ],
        ),
      ),
    );
  }

  /// 波形动画
  Widget _buildWaveformAnimation() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return CustomPaint(
          size: Size(80.px, 40.px),
          painter: _WaveformPainter(_waveController.value),
        );
      },
    );
  }
}

/// 简单的音波绘制器
class _WaveformPainter extends CustomPainter {
  final double progress;
  _WaveformPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.greenAccent
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;

    final midY = size.height / 2;
    final barCount = 10;
    final spacing = size.width / (barCount - 1);
    final random = Random(progress.hashCode);

    for (int i = 0; i < barCount; i++) {
      double x = i * spacing;
      double height =
          (sin(progress * 2 * pi + i) + 1) / 2 * 20 + random.nextDouble() * 10;
      canvas.drawLine(
        Offset(x, midY - height / 2),
        Offset(x, midY + height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
