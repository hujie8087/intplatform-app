import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/pages/sos/models/chart_model.dart';
import 'package:logistics_app/utils/update_file.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceMessageService {
  final AudioRecorder _audioRecorder = AudioRecorder();
  Timer? _recordingTimer;
  int _recordingDuration = 0;
  String? _currentRecordingPath;
  bool _isRecording = false;
  bool isVoiceInput = false;
  String recordingTime = '0:00';
  bool _isBusy = false; // 防止并发调用

  // 开始录音
  Future<void> startRecording(ChartModel chartModel) async {
    if (_isBusy) return;
    _isBusy = true;
    final tempDir = await getTemporaryDirectory();
    final filePath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';
    try {
      await _stopSafe(); // 停止旧的录音（如果有）

      // 请求麦克风权限
      PermissionStatus status = await Permission.microphone.status;

      // 如果权限未授予，则请求权限
      if (status != PermissionStatus.granted) {
        // 如果权限被永久拒绝，提示用户去设置
        if (status == PermissionStatus.permanentlyDenied) {
          ProgressHUD.showError('请在设置中授权麦克风权限');
          _isBusy = false;
          return;
        }

        // 请求权限
        status = await Permission.microphone.request();
        if (status != PermissionStatus.granted) {
          ProgressHUD.showError('请授权麦克风权限');
          _isBusy = false;
          return;
        }
      }

      // 额外检查 record 包的权限（iOS 上可能需要）
      if (Platform.isIOS && !await _audioRecorder.hasPermission()) {
        ProgressHUD.showError('麦克风权限未授权，请检查设置');
        _isBusy = false;
        return;
      }

      // 确保清理旧的计时器
      _stopTimer();
      // 确保目录存在
      if (!await Directory(tempDir.path).exists()) {
        await Directory(tempDir.path).create(recursive: true);
      }
      // 生成文件路径
      _currentRecordingPath = filePath;

      // 开始录音
      await _audioRecorder.start(
        RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 16000,
          numChannels: 1,
        ),
        path: _currentRecordingPath!,
      );

      _isRecording = true;
      _recordingDuration = 0;
      isVoiceInput = true;
      recordingTime = '0:00';

      _startTimer(chartModel);

      if (kDebugMode) print('🎙 开始录音: $_currentRecordingPath');
    } catch (e, s) {
      if (kDebugMode) print('❌ 录音启动错误: $e\n$s');
      ProgressHUD.showError('录音启动失败');
    } finally {
      _isBusy = false;
    }
  }

  // 停止录音
  Future<void> stopRecording(ChartModel chartModel) async {
    if (_isBusy) return;
    _isBusy = true;

    try {
      _stopTimer();

      if (await _audioRecorder.isRecording()) {
        String? filePath = await _audioRecorder.stop();
        if (filePath != null && await File(filePath).exists()) {
          if (_recordingDuration < 1) {
            await File(filePath).delete();
            ProgressHUD.showError('录音时间太短');
          } else {
            await _sendVoiceMessage(filePath, _recordingDuration, chartModel);
          }
        }
      }
    } catch (e, s) {
      if (kDebugMode) print('❌ 停止录音错误: $e\n$s');
      ProgressHUD.showError('录音停止失败');
    } finally {
      _resetRecordingState();
      _isBusy = false;
    }
  }

  // 取消录音
  Future<void> cancelRecording() async {
    if (_isBusy) return;
    _isBusy = true;

    try {
      _stopTimer();

      if (await _audioRecorder.isRecording()) {
        await _audioRecorder.stop();
      }

      if (_currentRecordingPath != null &&
          await File(_currentRecordingPath!).exists()) {
        await File(_currentRecordingPath!).delete();
        if (kDebugMode) print('🗑 已取消录音: $_currentRecordingPath');
      }

      ProgressHUD.showInfo('已取消录音');
    } catch (e) {
      if (kDebugMode) print('❌ 取消录音错误: $e');
    } finally {
      _resetRecordingState();
      _isBusy = false;
    }
  }

  // 发送语音消息
  Future<void> _sendVoiceMessage(
    String filePath,
    int duration,
    ChartModel chartModel,
  ) async {
    try {
      File audioFile = File(filePath);
      if (!await audioFile.exists()) {
        ProgressHUD.showError('录音文件不存在');
        return;
      }

      int fileSize = await audioFile.length();
      if (fileSize == 0) {
        ProgressHUD.showError('录音文件为空');
        return;
      }

      if (kDebugMode) {
        final fileUrl = await uploadFile([
          audioFile,
        ], chartModel.currentSession?.sessionId ?? '');
        if (fileUrl.isNotEmpty) {
          await chartModel.sendMediaMessage(
            fileUrl[0],
            'AUDIO',
            chartModel.currentSession?.sessionId,
          );
        }
        print(
          '📤 发送语音消息: $filePath, 时长: ${_formatDuration(duration)}, 大小: ${(fileSize / 1024).toStringAsFixed(2)}KB',
        );
      }

      ProgressHUD.showSuccess('语音消息发送成功');
    } catch (e) {
      if (kDebugMode) print('❌ 发送语音消息错误: $e');
      ProgressHUD.showError('语音消息发送失败');
    }
  }

  // 安全停止
  Future<void> _stopSafe() async {
    try {
      if (await _audioRecorder.isRecording()) {
        await _audioRecorder.stop();
      }
    } catch (_) {}
    _stopTimer();
  }

  // 计时器
  void _startTimer(ChartModel chartModel) {
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _recordingDuration++;
      recordingTime = _formatDuration(_recordingDuration);
      if (_recordingDuration >= 60) stopRecording(chartModel);
    });
  }

  void _stopTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
  }

  // 状态重置
  void _resetRecordingState() {
    _isRecording = false;
    _recordingDuration = 0;
    _currentRecordingPath = null;
    _stopTimer();
    isVoiceInput = false;
    recordingTime = '';
  }

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  bool get isRecording => _isRecording;
  int get recordingDuration => _recordingDuration;

  Future<void> dispose() async {
    _stopTimer();
    await _audioRecorder.dispose();
  }
}
