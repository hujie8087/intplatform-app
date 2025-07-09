import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/hj_bottom_sheet.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

Future<String> uploadImages(AssetEntity selectedAsset) async {
  File? file = await selectedAsset.file;
  final formData = dio.FormData();
  if (file == null) {
    return '';
  }
  ;
  if (file != null) {
    formData.files.add(
      MapEntry(
        'file',
        await dio.MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      ),
    );
  }
  // 使用 Completer 处理异步回调
  final completer = Completer<Map<String, dynamic>>();
  // 上传图片
  DataUtils.uploadFacePhoto(
    formData,
    success: (data) {
      completer.complete(data);
    },
    fail: (code, msg) {
      ProgressHUD.showError(msg);
      completer.completeError('Upload failed with code: $code, message: $msg');
    },
  );
  try {
    final data = await completer.future;
    if (data != null) {
      return data['data']['url'];
    } else {
      return '';
    }
  } catch (e) {
    print(e);
    return '';
  }
}

class FaceCollectionPage extends StatefulWidget {
  const FaceCollectionPage({Key? key}) : super(key: key);

  @override
  State<FaceCollectionPage> createState() => _FaceCollectionPageState();
}

class _FaceCollectionPageState extends State<FaceCollectionPage> {
  // 选择的图片
  List<AssetEntity> selectedAssets = [];
  // 用户人脸图片
  String? userFaceImage = null;
  UserInfoModel? userInfo;

  Future<void> _fetchData() async {
    DataUtils.getUserInfo(
      success: (res) async {
        UserInfoModel userInfoModel = UserInfoModel.fromJson(res['data']);
        await SpUtils.saveModel('userInfo', userInfoModel);
        await SpUtils.saveString(
          Constants.FACE_PHOTO,
          userInfoModel.user?.facePhoto ?? '',
        );
        userInfo = userInfoModel;
        setState(() {
          userFaceImage = userInfoModel.user?.facePhoto ?? '';
        });
      },
      fail: (code, msg) {
        ProgressHUD.showText(msg);
      },
    );
  }

  Future<void> _updateData(String url) async {
    userInfo?.user?.facePhoto = url;
    DataUtils.editUserInfo(
      userInfo!.user!.toJson(),
      success: (res) async {
        ProgressHUD.showText(S.of(context).changeSuccess);
        _fetchData();
        setState(() {});
      },
      fail: (code, msg) {
        ProgressHUD.showText(msg);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.faceCollection,
          style: TextStyle(fontSize: 16.px),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.px),
            height: 200.px,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            // child: Center(
            //   child: Text('请上传人脸照片', style: TextStyle(color: Colors.grey)),
            // ),
            child:
                userFaceImage == null || userFaceImage == ''
                    ? Container(
                      width: 300.px,
                      child: Center(
                        child: Text(
                          S.current.uploadFacePhoto,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                    : Image.network(
                      APIs.imagePrefix + '/' + userFaceImage!,
                      fit: BoxFit.contain,
                    ),
          ),
          SizedBox(height: 10.px),
          Text(
            S.current.faceCollectionTips,
            style: TextStyle(color: secondaryColor, fontSize: 12.px),
          ),
          // 人脸采集说明
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(30.px),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.current.faceCollectionTipsTitle,
                  style: TextStyle(
                    fontSize: 14.px,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.px),
                Text(
                  S.current.faceCollectionTips1,
                  style: TextStyle(fontSize: 12.px),
                ),
                SizedBox(height: 5.px),
                Text(
                  S.current.faceCollectionTips2,
                  style: TextStyle(fontSize: 12.px),
                ),
                SizedBox(height: 5.px),
                Text(
                  S.current.faceCollectionTips3,
                  style: TextStyle(fontSize: 12.px),
                ),
                SizedBox(height: 5.px),
                Text(
                  S.current.faceCollectionTips4,
                  style: TextStyle(fontSize: 12.px),
                ),
                SizedBox(height: 5.px),
                Text(
                  S.current.faceCollectionTips5,
                  style: TextStyle(fontSize: 12.px),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30.px),
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(
                  Size(double.infinity, 26.px),
                ),
                backgroundColor: MaterialStateProperty.all(primaryColor[500]),
                textStyle: MaterialStateProperty.all(
                  TextStyle(fontSize: 14.px, color: Colors.white),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.px),
                  ),
                ),
              ),
              onPressed: () async {
                final result = await HJBottomSheet.wxPicker(
                  context,
                  selectedAssets,
                  1,
                );
                if (result != null) {
                  final res = await uploadImages(result[0]);
                  if (res != '') {
                    await _updateData(res);
                  }
                  setState(() {});
                }
              },
              child: Text(
                S.current.uploadNewFacePhoto,
                style: TextStyle(fontSize: 14.px, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
