import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/switch_type.dart';
import 'package:logistics_app/pages/film_page/film_download_page.dart';
import 'package:logistics_app/pages/film_page/film_history_page.dart';
import 'package:logistics_app/pages/film_page/film_home_page.dart';
import 'package:logistics_app/pages/film_page/film_personal_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';

class FilmScreenPage extends StatefulWidget {
  const FilmScreenPage({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _FilmScreenPage createState() => _FilmScreenPage();
}

class _FilmScreenPage extends State<FilmScreenPage>
    with SingleTickerProviderStateMixin {
  PageController _pageController = PageController();
  double topBarOpacity = 0.0;
  Animation<double>? topBarAnimation;
  TabController? tabController;
  final List<SwitchType> buttonLabels = [
    SwitchType('推荐', 0),
    SwitchType('电影', 1),
    SwitchType('电视剧', 2),
    SwitchType('综艺', 3),
    SwitchType('动漫', 4),
    SwitchType('纪录片', 5),
    SwitchType('知识', 6),
  ];

  int _currentPage = 0;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController!,
        curve: Interval(0, 0.3, curve: Curves.fastOutSlowIn),
      ),
    );
    widget.animationController!.forward();
    super.initState();
    _pageController = PageController(initialPage: 0);
    tabController = TabController(length: buttonLabels.length, vsync: this);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
        print('Current Page: $_currentPage');
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          children: [
            getAppBarUI(),
            Expanded(
              child: Stack(
                children: [
                  TabBarView(
                    controller: tabController,
                    children: <Widget>[
                      Container(child: FilmHomePage()),
                      Container(
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            'Page 2',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            'Page 3',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            'Page 2',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            'Page 3',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            'Page 2',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            'Page 3',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 头部
  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  50 * (1.0 - topBarAnimation!.value),
                  0.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(topBarOpacity),
                  ),
                  padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap:
                                () => {
                                  print('123'),
                                  RouteUtils.push(
                                    context,
                                    FilmPersonalPage(
                                      animationController:
                                          widget.animationController,
                                    ),
                                  ),
                                },
                            child:
                            // 圆形图片
                            Container(
                              width: 32,
                              height: 32,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/fitness_app/snack.png',
                                  ),
                                  fit: BoxFit.fill,
                                ),
                                color: primaryColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to the search screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '搜索电影、剧集、综艺、动漫…',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(Icons.search),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap:
                                () => {
                                  print('123'),
                                  // 跳转页面
                                  RouteUtils.push(context, FilmHistoryPage()),
                                },
                            child: Icon(Icons.history, color: Colors.white),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap:
                                () => {
                                  print('321'),
                                  // 跳转页面
                                  RouteUtils.push(context, FilmDownloadPage()),
                                },
                            child: Icon(Icons.download, color: Colors.white),
                          ),
                        ],
                      ),
                      TabBar(
                        controller: tabController,
                        labelColor: primaryColor,
                        labelPadding: EdgeInsets.all(0),
                        indicator: const BoxDecoration(),
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: TextStyle(fontSize: 14),
                        unselectedLabelColor: Colors.white.withOpacity(0.8),
                        tabs: [for (var i in buttonLabels) Tab(text: i.label)],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// 搜索界面
class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('搜索', style: TextStyle(fontSize: 18))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your search term...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            // Add more search options or results here
          ],
        ),
      ),
    );
  }
}
