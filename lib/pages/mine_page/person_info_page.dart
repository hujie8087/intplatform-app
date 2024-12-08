import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/dialog/dialog_factory.dart';
import 'package:logistics_app/common_ui/divider_widget.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/repair/repair_form_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/picker.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PersonInfoPage extends StatefulWidget {
  @override
  _PersonInfoPageState createState() => _PersonInfoPageState();
}

class _PersonInfoPageState extends State<PersonInfoPage> {
  String avatar = 'assets/images/userImage.png';
  UserInfoModel? userInfo;
  List<AssetEntity> selectedAssets = [];
  String? selectedValue;
  final List<DictModel> sexOptions = [
    DictModel(dictValue: '0', dictLabel: S.current.man),
    DictModel(dictValue: '1', dictLabel: S.current.woman),
    DictModel(dictValue: '2', dictLabel: S.current.secret),
  ];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    DataUtils.getUserInfo(
      success: (res) async {
        UserInfoModel userInfoModel = UserInfoModel.fromJson(res['data']);
        await SpUtils.saveModel('userInfo', userInfoModel);
        await SpUtils.saveString(
            Constants.SP_USER_NAME, userInfoModel.user?.nickName ?? '');
        await SpUtils.saveString(
            Constants.SP_USER_DEPT, userInfoModel.user?.dept?.deptName ?? '');
        if (userInfoModel.user?.avatar != '') {
          avatar = userInfoModel.user!.avatar!;
        }
        userInfo = userInfoModel;
        setState(() {});
      },
      fail: (code, msg) {
        ProgressHUD.showText(msg);
      },
    );
  }

  Future<void> _updateData() async {
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
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            S.of(context).userInfo,
            style: TextStyle(fontSize: 16.px),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // 自适应键盘弹起不遮挡
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(top: 10.px, left: 10.px, right: 10.px),
                    padding: EdgeInsets.only(
                        left: 20.px, right: 20.px, top: 10.px, bottom: 20.px),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.px),
                    ),
                    child: _PersonInfoForm(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _PersonInfoForm() {
    return Column(
      children: [
        // 头像
        GestureDetector(
          onTap: () async {
            final List<AssetEntity>? result = await AssetPicker.pickAssets(
                context,
                pickerConfig: AssetPickerConfig(
                    textDelegate: AssetPickerTextDelegate(), maxAssets: 1));
            if (result == null) {
              return;
            }
            final res = await uploadImages(result);
            if (res.isNotEmpty) {
              userInfo?.user?.avatar = res[0];
              print(userInfo);
              _updateData();
            }
          },
          child: Column(
            children: [
              Container(
                width: 72.px,
                height: 72.px,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.px),
                  image: DecorationImage(
                    image: avatar.startsWith('assets')
                        ? AssetImage(avatar) as ImageProvider
                        : NetworkImage(APIs.imagePrefix + avatar),
                    fit: BoxFit.cover,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
              Text(
                S.of(context).changeAvatar,
                style: TextStyle(color: secondaryColor, fontSize: 10.px),
              )
            ],
          ),
        ),
        _PersonInfoItem(
            S.of(context).name, userInfo?.user?.nickName ?? '', Icons.person,
            () async {
          _controller.text = '';
          DialogFactory.instance.showFieldDialog(
            context: context,
            title: S.of(context).inputMessage(S.of(context).name),
            customContentWidget: Container(
              child: TextField(
                controller: _controller,
                style: TextStyle(fontSize: 12.px),
                decoration: InputDecoration(
                  hintText: S.of(context).inputMessage(S.of(context).name),
                ),
              ),
            ),
            confirmClick: () async {
              final result = _controller.text;
              userInfo!.user!.nickName = result;
              await _updateData();
            },
          );
        }, isEdit: true),
        // 工号
        _PersonInfoItem(S.of(context).workNo, userInfo?.user?.userName ?? '',
            Icons.workspace_premium, () {}),
        _PersonInfoItem(
            S.of(context).gender,
            userInfo?.user?.sex == '0'
                ? S.of(context).man
                : userInfo?.user?.sex == '1'
                    ? S.of(context).woman
                    : S.of(context).secret,
            Icons.wc, () {
          Picker.showModalSheet(context,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (final sex in sexOptions)
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context, sex.dictValue ?? '');
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 44.px,
                              child: Text(sex.dictLabel ?? ''),
                            ),
                          ),
                          DividerWidget()
                        ],
                      ),
                  ],
                ),
              )).then((value) {
            if (value != null) {
              userInfo!.user!.sex = value;
              _updateData();
            }
          });
        }, isEdit: true),
        _PersonInfoItem(
            S.of(context).phone, userInfo?.user?.phonenumber ?? '', Icons.phone,
            () async {
          _controller.text = userInfo?.user?.phonenumber ?? '';
          DialogFactory.instance.showFieldDialog(
            context: context,
            title: S.of(context).inputMessage(S.of(context).phone),
            customContentWidget: Container(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _controller,
                decoration: InputDecoration(
                  hintText: S.of(context).inputMessage(S.of(context).phone),
                ),
              ),
            ),
            confirmClick: () async {
              final result = _controller.text;
              userInfo!.user!.phonenumber = result;
              await _updateData();
            },
          );
        }, isEdit: true),
        _PersonInfoItem(
            S.of(context).email, userInfo?.user?.email ?? '', Icons.email,
            () async {
          _controller.text = userInfo?.user?.email ?? '';
          DialogFactory.instance.showFieldDialog(
            context: context,
            title: S.of(context).inputMessage(S.of(context).email),
            customContentWidget: Container(
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _controller,
                decoration: InputDecoration(
                  hintText: S.of(context).inputMessage(S.of(context).email),
                ),
              ),
            ),
            confirmClick: () async {
              final result = _controller.text;
              userInfo!.user!.email = result;
              await _updateData();
            },
          );
        }, isEdit: true),
        // 部门
        _PersonInfoItem(S.of(context).dept,
            userInfo?.user?.dept?.deptName ?? '', Icons.work, () {},
            isEdit: false),
      ],
    );
  }

  Widget _PersonInfoItem(String title, String value, IconData icon, onTap,
      {bool isEdit = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(top: 10.px, bottom: 10.px),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(width: 1, color: Colors.grey.withOpacity(0.2)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Row(
              children: [
                // 图标
                Icon(
                  icon,
                  color: primaryColor,
                  size: 16.px,
                ),
                SizedBox(
                  width: 10.px,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 12.px),
                )
              ],
            )),
            Text(
              value,
              style: TextStyle(fontSize: 12.px, color: Colors.grey),
            ),
            if (isEdit) Icon(Icons.chevron_right, color: Colors.grey)
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showEditDialog(controller,
      {required String title,
      TextInputType keyboardType = TextInputType.text}) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration:
                InputDecoration(hintText: S.of(context).inputMessage(title)),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: Text(S.of(context).confirm),
            ),
          ],
        );
      },
    );
    return result;
  }
}
