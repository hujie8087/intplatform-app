import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/base_list_model.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/http/model/other_view_model.dart';
import 'package:logistics_app/pages/public_convenience_page/other_content_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/picker.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class PublicConvenienceListPage extends StatefulWidget {
  @override
  _PublicConvenienceListPage createState() => _PublicConvenienceListPage();
}

class _PublicConvenienceListPage extends State<PublicConvenienceListPage> {
  List<DictModel> typeOptions = [];
  List<OtherViewModel> otherDataList = [];
  DictModel? typeCheck;

  @override
  void initState() {
    super.initState();
    _fetchDictData();
  }

  Future<void> _fetchDictData() async {
    // 模拟异步数据获取
    DataUtils.getDictDataList(
      'public_common_type',
      success: (data) {
        BaseListModel<DictModel> response =
            BaseListModel.fromJson(data, (json) => DictModel.fromJson(json));

        setState(() {
          typeOptions = response.data ?? [];
        });
      },
    );
    // 更新状态
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '公共便利',
          style: TextStyle(
            fontSize: 16.px,
          ),
          textAlign: TextAlign.left,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(36.px),
          child: Row(
            children: [
              SizedBox(
                width: 10.px,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Picker.showModalSheet(context,
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              for (final type in typeOptions)
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context, type);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 50.px,
                                        child: Text(type.dictLabel ?? ''),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        )).then((value) {
                      if (value != null) {
                        typeCheck = value;
                        setState(() {});
                      }
                    });
                  },
                  child: Container(
                    height: 40.px,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            typeCheck?.dictLabel ?? '请选择设施类型',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Icon(
                          Icons.arrow_downward,
                          size: 16.px,
                          color: primaryColor,
                        ),
                        SizedBox(
                          width: 10.px,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.px,
              ),
              Expanded(
                child: InkWell(
                  child: Container(
                    height: 40.px,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20.px)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            S.of(context).repairArea,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Icon(
                          Icons.arrow_downward,
                          size: 16.px,
                          color: primaryColor,
                        ),
                        SizedBox(
                          width: 10.px,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.px,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.px),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: OtherContentPage(
                souceType: typeCheck?.dictValue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
