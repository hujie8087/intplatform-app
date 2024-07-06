import 'package:flutter/material.dart';
import 'package:logistics_app/pages/film_page/film_data_model.dart';
import 'package:logistics_app/pages/film_page/film_view_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class FilmHomePage extends StatefulWidget {
  const FilmHomePage({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _FilmHomePage createState() => _FilmHomePage();
}

class _FilmHomePage extends State<FilmHomePage> {
  List<FilmDataModel> filmsDataList = FilmDataModel.filmDataList;

  List<FilmDataModel> filmsHotList = FilmDataModel.filmHotList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 设置透明背景
      backgroundColor: Colors.transparent,
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              getFilmTypeUI(filmsDataList),
              SizedBox(height: 20),
              getHotFilmUI(filmsHotList, '热门'),
              SizedBox(height: 20),
              getHotFilmUI(filmsHotList, '华语')
            ],
          ),
        ),
      ),
    );
  }
}

// 电影类型模块轮播
Widget getFilmTypeUI(filmsDataList) {
  return Container(
    height: 300,
    padding: EdgeInsets.only(left: 10),
    child: ListView.builder(
      itemCount: filmsDataList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Card(
          clipBehavior: Clip.hardEdge,
          // 设置卡片的圆角
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          // 超出隐藏
          margin: EdgeInsets.only(right: 20),
          child: Stack(
            children: [
              ColorFiltered(
                // 设置圆角
                colorFilter: ColorFilter.mode(
                  Colors.grey,
                  BlendMode.saturation,
                ),
                child: Image.asset(
                  filmsDataList[index].imagePath,
                  width: 240,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                  width: 240,
                  height: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.white.withOpacity(0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        filmsDataList[index].title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // 电影列表
                      Expanded(
                        child: ListView.builder(
                          itemCount: filmsDataList[index].list.length,
                          itemBuilder: (context, idx) {
                            return InkWell(
                              onTap: () => RouteUtils.push(
                                  context,
                                  // BiliVideoPage(
                                  //   bvid: 'BV15t411U7yf',
                                  //   cid: 62816723,
                                  // )
                                  FilmViewPage()),
                              child: Ink(
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 50,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Image.asset(
                                          filmsDataList[index]
                                              .list[idx]
                                              .imagePath,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              filmsDataList[index]
                                                  .list[idx]
                                                  .title,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            // 带星星的评分，总共5颗星
                                            Row(
                                              children: [
                                                SmoothStarRating(
                                                    allowHalfRating: false,
                                                    starCount: 5,
                                                    rating: filmsDataList[index]
                                                        .list[idx]
                                                        .score
                                                        .toDouble(),
                                                    size: 16.0,
                                                    filledIconData: Icons.star,
                                                    halfFilledIconData:
                                                        Icons.blur_on,
                                                    color: Colors.yellow,
                                                    borderColor: Colors.yellow,
                                                    spacing: 0.0),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  filmsDataList[index]
                                                      .list[idx]
                                                      .score
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // 查看更多
                      GestureDetector(
                        onTap: () => {print('查看更多')},
                        child: Container(
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '查看更多',
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        );
      },
    ),
  );
}

// 热门模块
Widget getHotFilmUI(filmsHotList, label) {
  return Container(
    height: 250,
    padding: EdgeInsets.only(left: 10, right: 10),
    child: Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.only(left: 15, top: 10, right: 15),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(80),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // 更多连接
              GestureDetector(
                child: Text(
                  '更多>',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            // 使用Expanded包裹GridView
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 3,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.5,
              ),
              itemBuilder: (context, index) {
                return Container(
                  height: 220,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 设置背景图片模块
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(filmsHotList[index].imagePath),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        filmsHotList[index].title,
                        // 超出省略号
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
