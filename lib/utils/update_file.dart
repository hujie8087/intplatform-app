import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/upload_image_model.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

Future<List<String>> uploadFile(List<dynamic> files, String fileName) async {
  List<String> fileUrl = [];
  final formData = dio.FormData();

  try {
    for (var file in files) {
      if (file is AssetEntity) {
        final assetFile = await file.file;
        if (assetFile != null) {
          formData.files.add(
            MapEntry('files', await dio.MultipartFile.fromFile(assetFile.path)),
          );
        }
      } else if (file is File) {
        formData.files.add(
          MapEntry('files', await dio.MultipartFile.fromFile(file.path)),
        );
      }
      formData.fields.add(MapEntry('fName', fileName));
    }

    // 使用 Completer 处理异步回调
    final completer = Completer<Map<String, dynamic>>();

    // 上传图片
    DataUtils.uploadByfName(
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
          fileUrl.add(item.url!);
        }
      }
    }

    if (fileUrl.isEmpty) {
      throw Exception('图片上传成功但未返回有效的URL');
    }

    return fileUrl;
  } catch (e) {
    print('图片上传异常: $e');
    rethrow; // 重新抛出异常，让调用方知道上传失败
  }
}
