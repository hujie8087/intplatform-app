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

  Future<void> getLostFoundModelList(bool isRefresh) async {
    try {
      if (isRefresh) {
        list = null;
        pageNum = 1;
        isLoadComplete = false;
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

      final completer = Completer<void>();

      DataUtils.getPageList(
        '/other/found/list',
        params,
        success: (data) {
          try {
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
            completer.complete();
          } catch (e) {
            print('数据处理错误: $e');
            completer.completeError('数据处理失败: $e');
          } finally {
            Loading.dismissAll();
          }
        },
        fail: (code, msg) {
          print('接口请求失败: [$code] $msg');
          completer.completeError('获取失败: $msg');
          Loading.dismissAll();
        },
      );

      await completer.future;
    } catch (e) {
      print('获取失物招领列表异常: $e');
      // 确保加载状态被清除
      Loading.dismissAll();
      // 如果是刷新操作且发生错误，重置页码
      if (isRefresh) {
        pageNum = 1;
      } else {
        pageNum = pageNum > 1 ? pageNum - 1 : 1;
      }
      // 通知UI更新
      notifyListeners();
      // 重新抛出异常，让调用方处理
      rethrow;
    }
  }

  // 获取我的发布列表
  Future<void> getMyLostFoundList(bool isRefresh) async {
    try {
      if (isRefresh) {
        list = null;
        pageNum = 1;
        isLoadComplete = false;
      } else {
        pageNum++;
      }

      var params = {
        'pageNum': pageNum,
        'pageSize': pageSize,
        'createBy': createBy,
      };

      Loading.showLoading();

      final completer = Completer<void>();

      DataUtils.getPageList(
        '/other/found/listByUser',
        params,
        success: (data) {
          try {
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
            completer.complete();
          } catch (e) {
            print('数据处理错误: $e');
            completer.completeError('数据处理失败: $e');
          } finally {
            Loading.dismissAll();
          }
        },
        fail: (code, msg) {
          print('接口请求失败: [$code] $msg');
          completer.completeError('获取失败: $msg');
          Loading.dismissAll();
        },
      );

      await completer.future;
    } catch (e) {
      print('获取失物招领列表异常: $e');
      // 确保加载状态被清除
      Loading.dismissAll();
      // 如果是刷新操作且发生错误，重置页码
      if (isRefresh) {
        pageNum = 1;
      } else {
        pageNum = pageNum > 1 ? pageNum - 1 : 1;
      }
      // 通知UI更新
      notifyListeners();
      // 重新抛出异常，让调用方处理
      rethrow;
    }
  }

  // 删除失物招领
  Future<void> deleteLostFound(String id) async {
    try {
      Loading.showLoading();

      final completer = Completer<void>();

      DataUtils.deleteData(
        '/other/found/$id',
        null,
        success: (data) {
          try {
            Loading.dismissAll();
            ProgressHUD.showSuccess('删除成功');
            getLostFoundModelList(true);
            completer.complete();
          } catch (e) {
            print('删除成功后的操作异常: $e');
            completer.completeError(e);
          }
        },
        fail: (code, msg) {
          print('删除失败: [$code] $msg');
          Loading.dismissAll();
          ProgressHUD.showError('删除失败: $msg');
          completer.completeError('删除失败: $msg');
        },
      );

      await completer.future;
    } catch (e) {
      print('删除失物招领异常: $e');
      Loading.dismissAll();
      ProgressHUD.showError('删除操作异常');
      rethrow;
    }
  }

  // 领取物品
  Future<void> receiveLostFound(FoundModel found) async {
    try {
      Loading.showLoading();
      found.isFound = '1';

      final completer = Completer<void>();

      DataUtils.editData(
        '/other/found',
        found,
        success: (data) {
          try {
            Loading.dismissAll();
            ProgressHUD.showSuccess('领取成功');
            getLostFoundModelList(true);
            completer.complete();
          } catch (e) {
            print('领取成功后的操作异常: $e');
            completer.completeError(e);
          }
        },
        fail: (code, msg) {
          Loading.dismissAll();
          ProgressHUD.showError('领取失败: $msg');
          completer.completeError('领取失败: $msg');
        },
      );

      await completer.future;
    } catch (e) {
      Loading.dismissAll();
      ProgressHUD.showError('领取操作异常');
      rethrow;
    }
  }

  // 获取详情
  Future<FoundModel?> getDetail(String id) async {
    try {
      final completer = Completer<Map<String, dynamic>>();

      DataUtils.getData(
        '/other/found/$id',
        null,
        success: (data) {
          try {
            completer.complete(data['data']);
          } catch (e) {
            completer.completeError('数据处理失败: $e');
          }
        },
        fail: (code, msg) {
          completer.completeError('获取详情失败: $msg');
        },
      );

      final data = await completer.future;
      return FoundModel.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  // 上传失物招领图片
  Future<List<String>> uploadImages(List<AssetEntity> selectedAssets) async {
    try {
      List<String> fileUrls = [];
      final formData = dio.FormData();

      // 获取临时目录
      final tempDir = await getTemporaryDirectory();

      for (var asset in selectedAssets) {
        try {
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
        } catch (e) {
          print('上传图片异常: $e');
          continue;
        }
      }

      if (formData.files.isEmpty) {
        throw Exception('没有有效的图片文件可上传');
      }

      final completer = Completer<Map<String, dynamic>>();

      DataUtils.uploadFile(
        formData,
        success: (data) {
          try {
            completer.complete(data);
          } catch (e) {
            completer.completeError('数据处理失败: $e');
          }
        },
        fail: (code, msg) {
          completer.completeError('上传失败: $msg');
        },
      );

      final data = await completer.future;
      final response = UploadImageModel.fromJson(data);

      if (response.data != null) {
        for (var item in response.data!) {
          if (item.url != null) {
            fileUrls.add(item.url!);
          }
        }
      }

      return fileUrls;
    } catch (e) {
      rethrow;
    }
  }
}
