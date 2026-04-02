import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/upload_image_model.dart';

Future<String> uploadMealDeliveryFile(File file) async {
  final formData = dio.FormData();
  String fileUrl = '';

  try {
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
    DataUtils.uploadMealDeliveryFile(
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

    return fileUrl;
  } catch (e) {
    print('图片上传异常: $e');
    rethrow; // 重新抛出异常，让调用方知道上传失败
  }
}
