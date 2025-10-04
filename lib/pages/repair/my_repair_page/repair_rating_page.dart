import 'package:flutter/material.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/repair_utils.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_list_page.dart';
import 'package:logistics_app/pages/repair/components/content_page.dart';
import 'package:logistics_app/pages/repair/repair_data_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
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
  final TextEditingController ratingMessageController = TextEditingController();
  bool _switchSelected = true; //维护单选开关状态
  RepairDataModel model = new RepairDataModel();
  String imagePrefix = APIs.imagePrefix;

  @override
  void initState() {
    super.initState();
    // 获取路由参数
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var map = ModalRoute.of(context)?.settings.arguments;
      if (map is Map) {
        id = map['repairId'];
        title = map['title'];
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
            style: TextStyle(fontSize: 16.px, color: Colors.black),
            textAlign: TextAlign.left,
          ),
          actions: [
            Consumer<RepairDataModel>(
              builder: (context, model, child) {
                if (model.isShowButton)
                  return TextButton(
                    onPressed: () {
                      if (_switchSelected && rating.toInt() == 0) {
                        ProgressHUD.showError(S.of(context).repairServiceRate);
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
                                  Navigator.of(context).pop('submit'); // 返回上一页
                                },
                                child: Text(
                                  S.of(context).cancel,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  RepairUtils.editRepairDetail(
                                    {
                                      'id': id,
                                      'repairRoomId':
                                          model.repairViewData?.repairRoomId,
                                      'rating': rating.toInt(),
                                      'repairState':
                                          _switchSelected ? '3' : '2',
                                      'ratingMessage':
                                          ratingMessageController.text,
                                    },
                                    success: (data) {
                                      Navigator.of(context).pop(); // 关闭对话框
                                      Navigator.of(
                                        context,
                                      ).pop('submit'); // 返回上一页
                                    },
                                    fail: (code, msg) {
                                      ProgressHUD.showError(msg);
                                      Navigator.pop(context); // 关闭对话框
                                    },
                                  );
                                },
                                child: Text(
                                  S.of(context).submit,
                                  style: TextStyle(
                                    fontSize: 16.px,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      S.of(context).submit,
                      style: TextStyle(fontSize: 14.px, color: primaryColor),
                    ),
                  );
                return SizedBox.shrink(); // 当 isShowButton 为 false 时不显示按钮
              },
            ),
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
                padding: EdgeInsets.all(10.px),
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
                                  Text(
                                    model.repairViewData?.repairArea ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.px,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '/',
                                    style: TextStyle(
                                      fontSize: 12.px,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    model.repairViewData?.roomNo ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.px,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.px),
                              Text(
                                S.of(context).repairTime +
                                    ":" +
                                    (model.repairViewData?.createTime ?? ''),
                                style: TextStyle(
                                  fontSize: 12.px,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.px),
                        // 维修状态
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.px,
                            vertical: 2.px,
                          ),
                          child: Text(
                            getRepairStateText(
                              model.repairViewData?.repairState,
                            ),
                            style: TextStyle(
                              color: getRepairStateColor(
                                model.repairViewData?.repairState,
                              ),
                              fontSize: 12.px,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.px),
                    Text(
                      S.of(context).repairPerson,
                      style: TextStyle(
                        fontSize: 12.px,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 8.px),
                    Container(
                      padding: EdgeInsets.only(
                        left: 8.px,
                        top: 8.px,
                        right: 8.px,
                        bottom: 8.px,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.px)),
                      ),
                      width: double.infinity,
                      child: Text(
                        model.repairViewData?.repairPerson ?? '',
                        style: TextStyle(fontSize: 14.px),
                      ),
                    ),
                    SizedBox(height: 8.px),
                    Text(
                      S.of(context).contactPhone,
                      style: TextStyle(
                        fontSize: 12.px,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 8.px),
                    Container(
                      padding: EdgeInsets.only(
                        left: 8.px,
                        top: 8.px,
                        right: 8.px,
                        bottom: 8.px,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      width: double.infinity,
                      child: Text(
                        model.repairViewData?.tel ?? '',
                        style: TextStyle(fontSize: 12.px),
                      ),
                    ),
                    SizedBox(height: 8.px),
                    Text(
                      S.of(context).repairContent,
                      style: TextStyle(
                        fontSize: 12.px,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 8.px),
                    Container(
                      padding: EdgeInsets.only(
                        left: 8.px,
                        top: 5.px,
                        right: 8.px,
                        bottom: 5.px,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: HtmlLineLimit(
                        htmlContent: model.repairViewData?.repairMessage ?? '',
                      ),
                    ),
                    SizedBox(height: 8.px),
                    Text(
                      S.of(context).repairImages,
                      style: TextStyle(
                        fontSize: 12.px,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 8.px),
                    if (images.length > 0)
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // 每行显示3张图片
                          crossAxisSpacing: 8.px,
                          mainAxisSpacing: 8.px,
                        ),
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => PhotoViewGallery(
                                        pageOptions:
                                            images
                                                .map(
                                                  (
                                                    item,
                                                  ) => PhotoViewGalleryPageOptions(
                                                    imageProvider: NetworkImage(
                                                      imagePrefix + item,
                                                    ),
                                                    initialScale:
                                                        PhotoViewComputedScale
                                                            .contained,
                                                    heroAttributes:
                                                        PhotoViewHeroAttributes(
                                                          tag:
                                                              'galleryTag_$index',
                                                        ),
                                                    onTapUp:
                                                        (
                                                          context,
                                                          details,
                                                          controllerValue,
                                                        ) =>
                                                            Navigator.of(
                                                              context,
                                                            ).pop(),
                                                  ),
                                                )
                                                .toList(),
                                        backgroundDecoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        pageController: PageController(
                                          initialPage: index,
                                        ),
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Image.network(
                                imagePrefix + images[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    SizedBox(height: 16.px),
                    if (model.repairViewData?.repairState != 0)
                      Column(
                        children: [
                          Text(
                            S.of(context).repairDetail,
                            style: TextStyle(
                              fontSize: 12.px,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 8.px),
                        ],
                      ),
                    if (model.repairViewData?.repairState != 0)
                      Container(
                        padding: EdgeInsets.only(
                          top: 8.px,
                          left: 8.px,
                          right: 8.px,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  S.of(context).repairTime + ':',
                                  style: TextStyle(
                                    color: AppTheme.dark_grey,
                                    fontSize: 12.px,
                                  ),
                                ),
                                Text(
                                  model.repairViewData?.repairTime ?? '',
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 12.px,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.px),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).repairDirection + ':',
                                  style: TextStyle(
                                    color: AppTheme.dark_grey,
                                    fontSize: 12.px,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    model.repairViewData?.repairNote ?? '',
                                    style: TextStyle(
                                      color: secondaryColor,
                                      fontSize: 12.px,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.px),
                            Text(
                              S.of(context).repairServiceRate,
                              style: TextStyle(
                                fontSize: 10.px,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8.px),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).repairResult + ':',
                                  style: TextStyle(
                                    color: AppTheme.dark_grey,
                                    fontSize: 12.px,
                                  ),
                                ),
                                Row(
                                  children: [
                                    if (model.repairViewData?.repairState ==
                                            2 ||
                                        model.repairViewData?.repairState == 3)
                                      Text(
                                        getRepairStateText(
                                          model.repairViewData?.repairState,
                                        ),
                                        style: TextStyle(
                                          color: getRepairStateColor(
                                            model.repairViewData?.repairState,
                                          ),
                                          fontSize: 12.px,
                                        ),
                                      ),
                                    if (model.isShowButton)
                                      Text(
                                        _switchSelected
                                            ? S.of(context).fixed
                                            : S.of(context).unfixed,
                                        style: TextStyle(
                                          color:
                                              _switchSelected
                                                  ? primaryColor
                                                  : secondaryColor,
                                          fontSize: 12.px,
                                        ),
                                      ),
                                    if (model.isShowButton)
                                      Switch(
                                        value: _switchSelected,
                                        activeThumbColor: primaryColor,
                                        activeTrackColor: primaryColor,
                                        onChanged:
                                            (value) => {
                                              _switchSelected = value,
                                              setState(() {
                                                if (!value) {
                                                  model.repairViewData!.rating =
                                                      null;
                                                  rating = 0;
                                                }
                                              }),
                                            },
                                      ),
                                  ],
                                ),
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
                                      fontSize: 12.px,
                                    ),
                                  ),
                                  if (model.repairViewData?.repairState == 3)
                                    SmoothStarRating(
                                      allowHalfRating: false,
                                      starCount: 5,
                                      rating:
                                          model.repairViewData!.rating!
                                              .toDouble(),
                                      size: 24.px,
                                      color: primaryColor,
                                      borderColor: primaryColor,
                                      spacing: 0.0,
                                    ),
                                  if (model.repairViewData?.repairState == 1)
                                    SmoothStarRating(
                                      allowHalfRating: false,
                                      onRatingChanged: (v) {
                                        if (!model.isShowButton) {
                                          return;
                                        }
                                        rating = v;
                                        setState(() {});
                                      },
                                      starCount: 5,
                                      rating: rating,
                                      size: 24.px,
                                      color: primaryColor,
                                      borderColor: primaryColor,
                                      spacing: 0.0,
                                    ),
                                ],
                              ),
                            SizedBox(height: 8.px),
                            if (model.repairViewData?.repairState == 2)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    S.of(context).userFeedback + ":",
                                    style: TextStyle(
                                      color: AppTheme.dark_grey,
                                      fontSize: 12.px,
                                    ),
                                  ),
                                  Text(
                                    model.repairViewData?.ratingMessage ?? '',
                                    style: TextStyle(
                                      color: secondaryColor,
                                      fontSize: 12.px,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    SizedBox(height: 8.px),
                    if (model.repairViewData?.repairState != 0 &&
                        !_switchSelected)
                      Container(
                        padding: EdgeInsets.all(8.px),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(4.px)),
                        ),
                        child: TextFormField(
                          controller: ratingMessageController,
                          maxLines: 8,
                          decoration: new InputDecoration(
                            helper: Icon(Icons.edit),
                            hintText: S.of(context).unfixedReason,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.px,
                            ),
                            // 取消边框
                            enabledBorder: InputBorder.none,
                            // 去除下划线
                            focusedBorder: InputBorder.none,
                            // 默认8行
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
