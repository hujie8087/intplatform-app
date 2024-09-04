import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/repair_utils.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_list_page.dart';
import 'package:logistics_app/pages/repair/content_page.dart';
import 'package:logistics_app/pages/repair/repair_data_model.dart';
import 'package:flutter/material.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class RepairRatingPage extends StatefulWidget {
  const RepairRatingPage({Key? key}) : super(key: key);
  @override
  _RepairRatingPageState createState() => _RepairRatingPageState();
}

class _RepairRatingPageState extends State<RepairRatingPage>
    with TickerProviderStateMixin {
  int? id;
  String? title;
  double rating = 0;
  bool isShowButton = false;
  final TextEditingController ratingMessageController = TextEditingController();
  bool _switchSelected = true; //维护单选开关状态
  RepairDataModel model = new RepairDataModel();
  String imagePrefix = '';

  @override
  void initState() {
    SpUtils.getString(Constants.SP_IMAGE_PREFIX)
        .then((res) => {imagePrefix = res});
    super.initState();
    // 获取路由参数
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var map = ModalRoute.of(context)?.settings.arguments;
      if (map is Map) {
        id = map['repairId'];
        title = map['title'];
        isShowButton = map['isShowButton'];
        if (id != null) {
          await model.getRepairDetail(id!);
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          return model;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                title ?? '',
                style: TextStyle(fontSize: 18, color: Colors.black),
                textAlign: TextAlign.left,
              ),
              actions: [
                if (isShowButton)
                  TextButton(
                      onPressed: () {
                        if (_switchSelected && rating.toInt() == 0) {
                          showToast(
                            S.of(context).repairServiceRate,
                          );
                          return;
                        }
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(S.of(context).tip),
                                content: Text(S.of(context).repairFeedbackTip),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context)
                                            .pop('submit'); // 返回上一页
                                      },
                                      child: Text(
                                        S.of(context).cancel,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        RepairUtils.editRepairDetail({
                                          'id': id,
                                          'repairRoomId': model
                                              .repairViewData?.repairRoomId,
                                          'rating': rating.toInt(),
                                          'repairState':
                                              _switchSelected ? '3' : '2',
                                          'ratingMessage':
                                              ratingMessageController.text,
                                        }, success: (data) {
                                          Navigator.of(context).pop(); // 关闭对话框
                                          Navigator.of(context)
                                              .pop('submit'); // 返回上一页
                                        }, fail: (code, msg) {
                                          showToast(msg);
                                          Navigator.pop(context); // 关闭对话框
                                        });
                                      },
                                      child: Text(
                                        S.of(context).submit,
                                        style: TextStyle(
                                            fontSize: 16, color: primaryColor),
                                      ))
                                ],
                              );
                            });
                      },
                      child: Text(
                        S.of(context).submit,
                        style: TextStyle(fontSize: 16, color: primaryColor),
                      ))
              ],
            ),
            body: Consumer<RepairDataModel>(
              builder: (context, value, child) {
                List<String> images = [];
                if (model.repairViewData != null &&
                    model.repairViewData?.repairPhoto != '') {
                  images = model.repairViewData!.repairPhoto!.split(',');
                }
                return SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(model.repairViewData?.repairArea ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text('/',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(model.repairViewData?.roomNo ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                  S.of(context).repairTime +
                                      ":" +
                                      (model.repairViewData?.createTime ?? ''),
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey))
                            ],
                          )),
                          SizedBox(width: 10),
                          // 维修状态
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            child: Text(
                              getRepairStateText(
                                  model.repairViewData?.repairState),
                              style: TextStyle(
                                color: getRepairStateColor(
                                    model.repairViewData?.repairState),
                                fontSize: 14,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        S.of(context).repairPerson,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 10, top: 10, right: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        width: double.infinity,
                        child: Text(
                          model.repairViewData?.repairPerson ?? '',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        S.of(context).contactPhone,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 10, top: 10, right: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        width: double.infinity,
                        child: Text(
                          model.repairViewData?.tel ?? '',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        S.of(context).repairContent,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 10, top: 5, right: 10, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: HtmlLineLimit(
                            htmlContent:
                                model.repairViewData?.repairMessage ?? ''),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        S.of(context).repairImages,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (images.length > 0)
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // 每行显示3张图片
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PhotoViewGallery(
                                              pageOptions: images
                                                  .map(
                                                    (item) =>
                                                        PhotoViewGalleryPageOptions(
                                                      imageProvider:
                                                          NetworkImage(
                                                              imagePrefix +
                                                                  item),
                                                      initialScale:
                                                          PhotoViewComputedScale
                                                              .contained,
                                                      heroAttributes:
                                                          PhotoViewHeroAttributes(
                                                        tag:
                                                            'galleryTag_$index',
                                                      ),
                                                      onTapUp: (context,
                                                              details,
                                                              controllerValue) =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                    ),
                                                  )
                                                  .toList(),
                                              backgroundDecoration:
                                                  BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              pageController: PageController(
                                                  initialPage: index),
                                            )));
                              },
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5)),
                                child: Image.network(
                                  imagePrefix + images[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      if (model.repairViewData?.repairState != 0)
                        Column(
                          children: [
                            Text(
                              S.of(context).repairDetail,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      if (model.repairViewData?.repairState != 0)
                        Container(
                          padding:
                              EdgeInsets.only(top: 10, left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    S.of(context).repairTime + ':',
                                    style: TextStyle(color: AppTheme.dark_grey),
                                  ),
                                  Text(
                                    model.repairViewData?.repairTime ?? '',
                                    style: TextStyle(color: secondaryColor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    S.of(context).repairDirection + ':',
                                    style: TextStyle(color: AppTheme.dark_grey),
                                  ),
                                  Expanded(
                                    child: Text(
                                      model.repairViewData?.repairNote ?? '',
                                      style: TextStyle(color: secondaryColor),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                S.of(context).repairServiceRate,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    S.of(context).repairResult + ':',
                                    style: TextStyle(
                                        color: AppTheme.dark_grey,
                                        fontSize: 14),
                                  ),
                                  Row(
                                    children: [
                                      if (model.repairViewData?.repairState ==
                                              2 ||
                                          model.repairViewData?.repairState ==
                                              3)
                                        Text(
                                          getRepairStateText(model
                                              .repairViewData?.repairState),
                                          style: TextStyle(
                                            color: getRepairStateColor(model
                                                .repairViewData?.repairState),
                                            fontSize: 14,
                                          ),
                                        ),
                                      if (isShowButton)
                                        Text(
                                          _switchSelected
                                              ? S.of(context).fixed
                                              : S.of(context).unfixed,
                                          style: TextStyle(
                                            color: _switchSelected
                                                ? primaryColor
                                                : secondaryColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      if (isShowButton)
                                        Switch(
                                            value: _switchSelected,
                                            activeColor: primaryColor,
                                            activeTrackColor: primaryColor,
                                            onChanged: (value) => {
                                                  _switchSelected = value,
                                                  setState(() {
                                                    if (!value) {
                                                      model.repairViewData!
                                                          .rating = null;
                                                      rating = 0;
                                                    }
                                                  })
                                                })
                                    ],
                                  )
                                ],
                              ),
                              if (_switchSelected &&
                                  model.repairViewData?.repairState != 2)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      S.of(context).satisfaction,
                                      style: TextStyle(
                                          color: AppTheme.dark_grey,
                                          fontSize: 14),
                                    ),
                                    if (model.repairViewData?.repairState == 3)
                                      SmoothStarRating(
                                          allowHalfRating: false,
                                          starCount: 5,
                                          rating: model.repairViewData!.rating!
                                              .toDouble(),
                                          size: 30.0,
                                          color: primaryColor,
                                          borderColor: primaryColor,
                                          spacing: 0.0),
                                    if (model.repairViewData?.repairState == 1)
                                      SmoothStarRating(
                                          allowHalfRating: false,
                                          onRatingChanged: (v) {
                                            if (!isShowButton) {
                                              return;
                                            }
                                            rating = v;
                                            setState(() {});
                                          },
                                          starCount: 5,
                                          rating: rating,
                                          size: 30.0,
                                          color: primaryColor,
                                          borderColor: primaryColor,
                                          spacing: 0.0)
                                  ],
                                ),
                              SizedBox(
                                height: 10,
                              ),
                              if (model.repairViewData?.repairState == 2)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).userFeedback + ":",
                                      style: TextStyle(
                                          color: AppTheme.dark_grey,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      model.repairViewData?.ratingMessage ?? '',
                                      style: TextStyle(
                                          color: secondaryColor, fontSize: 14),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      if (model.repairViewData?.repairState != 0 &&
                          !_switchSelected)
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          child: TextFormField(
                            controller: ratingMessageController,
                            maxLines: 8,
                            decoration: new InputDecoration(
                              helper: Icon(Icons.edit),
                              hintText: S.of(context).unfixedReason,
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                              // 取消边框
                              enabledBorder: InputBorder.none,
                              // 去除下划线
                              focusedBorder: InputBorder.none,
                              // 默认8行
                            ),
                          ),
                        )
                    ],
                  ),
                ));
              },
            )));
  }
}
