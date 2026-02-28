import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/upload_image_model.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:dio/dio.dart' as dio;
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class SignaturePage extends StatefulWidget {
  const SignaturePage({super.key});

  @override
  State<SignaturePage> createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  // 初始化控制器
  late final SignatureController _controller;

  @override
  void initState() {
    super.initState();
    // 强制横屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _controller = SignatureController(
      penStrokeWidth: 3, // 画笔粗细
      penColor: Colors.black, // 画笔颜色
      exportBackgroundColor: Colors.transparent, // 导出背景透明
    );
  }

  @override
  void dispose() {
    // 恢复竖屏
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controller.dispose(); // 务必销毁控制器防止内存泄漏
    super.dispose();
  }

  Future<String> uploadFacePhoto(File file) async {
    String fileUrl = '';
    final formData = dio.FormData();
    formData.files.add(
      MapEntry(
        'files',
        await dio.MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      ),
    );
    // 使用 Completer 处理异步回调
    final completer = Completer<Map<String, dynamic>>();
    // 上传图片
    DataUtils.uploadFile(
      formData,
      success: (data) {
        completer.complete(data);
      },
      fail: (code, msg) {
        completer.completeError(
          'Upload failed with code: $code, message: $msg',
        );
      },
    );
    final data = await completer.future;
    final response = UploadImageModel.fromJson(data);
    if (response.data != null && response.data!.isNotEmpty) {
      for (var item in response.data!) {
        if (item.url != null) {
          fileUrl = item.url!;
        }
      }
    }

    if (fileUrl.isEmpty) {
      throw Exception('图片上传成功但未返回有效的URL');
    }

    return fileUrl;
  }

  /// 保存并上传签名
  Future<void> uploadSignature(Uint8List pngBytes) async {
    try {
      // 1. 获取临时目录并创建文件
      final tempDir = await getTemporaryDirectory();
      // 使用时间戳命名，防止文件重名
      final fileName = 'sign_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(p.join(tempDir.path, fileName));

      // 2. 将 Uint8List 写入文件
      await file.writeAsBytes(pngBytes);
      String url = await uploadFacePhoto(file);
      print(url);
      DataUtils.uploadSignature(
        {'signImageUrl': url, 'signLabel': '在线充值'},
        success: (data) {
          print(data);
          // 可以在这里给个提示或者返回
          if (mounted) {
            Navigator.pop(context, true);
          }
        },
        fail: (code, msg) {
          if (mounted) {
            Navigator.pop(context, false);
          }
          print(msg);
        },
      );
    } catch (e) {
      if (mounted) {
        Navigator.pop(context, false);
      }
      print("上传失败: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // 签名区域
            Expanded(
              child: Container(
                margin: EdgeInsets.all(8.px),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8.px),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 提示语 (水印)
                    Text(
                      '请输入姓名',
                      style: TextStyle(
                        fontSize: 40.px,
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // 签名画布
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.px),
                      child: Signature(
                        controller: _controller,
                        width: double.infinity,
                        height: double.infinity,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 操作按钮栏 (侧边栏)
            Container(
              width: 80.px,
              padding: EdgeInsets.symmetric(vertical: 20.px),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    icon: Icons.undo,
                    color: Colors.blue,
                    label: '撤销',
                    onTap: () => _controller.undo(),
                  ),
                  _buildActionButton(
                    icon: Icons.delete,
                    color: Colors.red,
                    label: '清除',
                    onTap: () => _controller.clear(),
                  ),
                  Column(
                    children: [
                      FloatingActionButton(
                        onPressed: () async {
                          if (_controller.isNotEmpty) {
                            final Uint8List? data =
                                await _controller.toPngBytes();
                            if (data != null) {
                              uploadSignature(data);
                            }
                          }
                        },
                        backgroundColor: primaryColor,
                        child: const Icon(Icons.check, color: Colors.white),
                        elevation: 4,
                      ),
                      SizedBox(height: 4.px),
                      Text('保存', style: TextStyle(fontSize: 12.px)),
                    ],
                  ),
                  _buildActionButton(
                    icon: Icons.close,
                    color: Colors.grey,
                    label: '关闭',
                    onTap: () => Navigator.pop(context, false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: color, size: 28.px),
          onPressed: onTap,
        ),
        Text(label, style: TextStyle(fontSize: 12.px)),
      ],
    );
  }
}
