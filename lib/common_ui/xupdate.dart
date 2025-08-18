import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatefulWidget {
  final String version; // 新版本号
  final String content; // 更新内容
  final bool forceUpdate; // 是否强制更新
  final Function? onConfirm; // 确认更新回调
  final Function? onCancel; // 取消更新回调
  final double progress; // 下载进度

  const UpdateDialog({
    Key? key,
    required this.version,
    required this.content,
    this.forceUpdate = false,
    this.onConfirm,
    this.onCancel,
    this.progress = 0.0,
  }) : super(key: key);

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !widget.forceUpdate,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题
              Text(
                '发现新版本 v${widget.version}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // 更新内容
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: Text(
                    widget.content,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 进度条
              if (widget.progress > 0)
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: widget.progress,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('${(widget.progress * 100).toStringAsFixed(1)}%'),
                    const SizedBox(height: 16),
                  ],
                ),

              // 按钮区域
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!widget.forceUpdate) ...[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onCancel?.call();
                      },
                      child: const Text('暂不更新'),
                    ),
                    const SizedBox(width: 16),
                  ],
                  ElevatedButton(
                    onPressed:
                        widget.progress > 0
                            ? null
                            : () => widget.onConfirm?.call(),
                    child: const Text('立即更新'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> downloadApk(String apkUrl) async {
  try {
    // 获取存储路径
    Directory? dir = await getExternalStorageDirectory();
    String savePath = '${dir?.path}/update.apk';

    // 开始下载
    await Dio().download(
      apkUrl,
      savePath,
      onReceiveProgress: (count, total) {
        double progress = count / total * 100;
        print('下载进度: ${progress.toStringAsFixed(1)}%');
      },
    );

    print("下载完成: $savePath");

    // 下载完成后打开 APK
    launchUrl(Uri.parse(savePath));
  } catch (e) {
    print("下载失败: $e");
  }
}

// 使用示例
void showUpdateDialog(
  BuildContext context,
  String version,
  String content,
  String apkUrl,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => UpdateDialog(
          version: version,
          content: content,
          forceUpdate: true,
          onConfirm: () {
            // 处理更新逻辑
            print('开始更新');
            downloadApk(apkUrl);
          },
          onCancel: () {
            print('取消更新');
          },
        ),
  );
}
