import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/widgets.dart';
import 'package:logistics_app/common_ui/loading.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/found_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';
import 'package:logistics_app/http/model/upload_image_model.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class LostFoundViewModel with ChangeNotifier {
  List<FoundModel?>? list = [];
  int pageNum = 1;
  int pageSize = 5;
  int? reviewStatus = 1;
  String type = '';
  String createBy = '';
  // 数据加载完成
  bool isLoadComplete = false;

  Future getLostFoundModelList(bool isRefresh) async {
    final completer = Completer<void>();
    if (isRefresh) {
      list = null;
      pageNum = 1;
    } else {
      pageNum++;
    }
    var params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'reviewStatus': reviewStatus,
      'def2': type,
      'createBy': createBy,
    };
    Loading.showLoading();
    DataUtils.getPageList(
      '/other/found/list',
      params,
      success: (data) {
        RowsModel rowsModel = RowsModel.fromJson(
          data,
          (json) => FoundModel.fromJson(json),
        );
        if (rowsModel.rows != null) {
          var foundList = data['rows'] as List;
          List<FoundModel> rows =
              foundList.map((i) => FoundModel.fromJson(i)).toList();
          if (list == null) {
            list = rows;
          } else {
            list?.addAll(rows);
          }
          if (rowsModel.total == list?.length) {
            isLoadComplete = true;
          }
        }
        notifyListeners();
        Loading.dismissAll();
        completer.complete();
      },
      fail: (code, msg) {
        Loading.dismissAll();
        completer.completeError('获取失败');
      },
    );
    return completer.future;
  }

  // 删除失物招领
  Future<void> deleteLostFound(String id) async {
    Loading.showLoading();
    DataUtils.deleteData(
      '/other/found/$id',
      null,
      success: (data) {
        Loading.dismissAll();
        ProgressHUD.showSuccess('删除成功');
        getLostFoundModelList(true);
      },
      fail: (code, msg) {
        Loading.dismissAll();
        ProgressHUD.showError('删除失败');
      },
    );
  }

  // 领取物品
  Future<void> receiveLostFound(FoundModel found) async {
    Loading.showLoading();
    found.isFound = '1';
    DataUtils.editData(
      '/other/found',
      found,
      success: (data) {
        Loading.dismissAll();
        ProgressHUD.showSuccess('领取成功');
        getLostFoundModelList(true);
      },
      fail: (code, msg) {
        Loading.dismissAll();
        ProgressHUD.showError('领取失败');
      },
    );
  }

  // 获取详情
  Future<FoundModel?> getDetail(String id) async {
    final completer = Completer<Map<String, dynamic>>();
    DataUtils.getData(
      '/other/found/$id',
      null,
      success: (data) {
        completer.complete(data['data']);
      },
      fail: (code, msg) {
        completer.completeError('获取失败');
      },
    );
    return FoundModel.fromJson(await completer.future);
  }

  // 上传失物招领图片
  Future<List<String>> uploadImages(List<AssetEntity> selectedAssets) async {
    List<String> fileUrls = [];
    final formData = dio.FormData();

    // 获取临时目录
    final tempDir = await getTemporaryDirectory();

    for (var asset in selectedAssets) {
      final file = await asset.file;
      if (file == null) continue;

      // 构造 WebP 文件路径
      final webpFileName = p.setExtension(p.basename(file.path), '.webp');
      final webpFilePath = p.join(tempDir.path, webpFileName);

      // 压缩并转换为 WebP
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        webpFilePath,
        format: CompressFormat.webp,
        quality: 80,
      );

      if (result != null) {
        formData.files.add(
          MapEntry(
            'files',
            await dio.MultipartFile.fromFile(
              result.path,
              filename: webpFileName,
            ),
          ),
        );
      }
    }

    final completer = Completer<Map<String, dynamic>>();

    DataUtils.uploadFile(
      formData,
      success: (data) => completer.complete(data),
      fail:
          (code, msg) => completer.completeError('Upload failed: [$code] $msg'),
    );

    try {
      final data = await completer.future;
      final response = UploadImageModel.fromJson(data);

      if (response.data != null) {
        for (var item in response.data!) {
          if (item.url != null) {
            fileUrls.add(item.url!);
          }
        }
      }
    } catch (e) {
      print('上传失败: $e');
    }

    return fileUrls;
  }
}
