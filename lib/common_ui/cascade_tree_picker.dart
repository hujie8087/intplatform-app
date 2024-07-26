///  jh_cascade_tree_picker.dart
///
///  Created by iotjin on 2022/07/23.
///  description: 级联选择器（树形结构数据、支持搜索）

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/searchbar.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/utils.dart';

const String _labelKey = 'title';
const String _valueKey = 'id';
const String _childrenKey = 'children';
const String _titleText = '请选择';
const String _tabText = '请选择';
const String _searchHintText = '搜索';
const String _splitString = ' / ';
const double _headerHeight = 50.0;
const double _searchBarHeight = 58.0;
const double _headerRadius = 10.0;
const double _lineHeight = 0.5;
const double _itemHeight = 50.0;
const double _titleFontSize = 18.0;
const double _textFontSize = 16.0;
const double _searchResultTextFontSize = 14.0;

/// 选择回调，返回选中末级节点对象和所有节点数组
typedef _ClickCallBack = void Function(dynamic selectItem, dynamic selectArr);

class CascadeTreePicker {
  static bool _isShowPicker = false;

  static void show(
    BuildContext context, {
    required List data, // tree数组
    String labelKey = _labelKey, // tree数据的文字字段
    String valueKey = _valueKey, // tree数据的数值字段
    String childrenKey = _childrenKey, // tree数据的children字段
    String title = _titleText,
    String tabText = _tabText,
    List values =
        const [], // 默认选中的数组(一维数组)，通过valuesKey确定是根据value还是label进行比较，最好使用唯一值作为元素
    String valuesKey = _valueKey, // 选中数组内元素使用的字段，对应valueKey或者labelKey
    bool isShowSearch = true,
    String searchHintText = _searchHintText,
    String splitString = _splitString, // 搜索结果显示时分割两级的字符串
    bool isShowRadius = true,
    _ClickCallBack? clickCallBack,
  }) {
    if (_isShowPicker || data.isEmpty) {
      return;
    }
    _isShowPicker = true;
    var radius = isShowRadius ? _headerRadius : 0.0;

    showModalBottomSheet<void>(
      context: context,
      // 使用true则高度不受16分之9的最高限制
      isScrollControlled: true,
      // 设置圆角
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
      ),
      // 抗锯齿
      clipBehavior: Clip.antiAlias,
      builder: (BuildContext context) {
        return SafeArea(
          child: CascadePickerView(
            data: data,
            labelKey: labelKey,
            valueKey: valueKey,
            childrenKey: childrenKey,
            title: title,
            tabText: tabText,
            values: values,
            valuesKey: valuesKey,
            isShowSearch: isShowSearch,
            searchHintText: searchHintText,
            splitString: splitString,
            clickCallBack: clickCallBack,
          ),
        );
      },
    ).then((value) => _isShowPicker = false);
  }
}

class CascadePickerView extends StatefulWidget {
  const CascadePickerView({
    Key? key,
    required this.data,
    this.labelKey = _labelKey,
    this.valueKey = _valueKey,
    this.childrenKey = _childrenKey,
    this.title = _titleText,
    this.tabText = _tabText,
    this.values = const [],
    this.valuesKey = _valueKey,
    this.isShowSearch = true,
    this.searchHintText = _searchHintText,
    this.splitString = _splitString,
    this.clickCallBack,
  }) : super(key: key);

  final List? data; // tree数组
  final String labelKey; // tree数据的文字字段
  final String valueKey; // tree数据的数值字段
  final String childrenKey; // tree数据的children字段
  final String title;
  final String tabText;
  final List
      values; // 默认选中的数组(一维数组)，通过valuesKey确定是根据value还是label进行比较，最好使用唯一值作为元素
  final String valuesKey; // 选中数组内元素使用的字段，对应valueKey或者labelKey
  final bool isShowSearch;
  final String searchHintText;
  final String splitString;
  final _ClickCallBack? clickCallBack;

  @override
  State<CascadePickerView> createState() => _CascadePickerViewState();
}

class _CascadePickerViewState extends State<CascadePickerView>
    with TickerProviderStateMixin {
  TabController? _tabController;
  final ScrollController _scrollController = ScrollController();

  // TabBar 数组
  final List<Tab> _myTabs = <Tab>[];

  // 当前列表数据
  List _mList = [];

  // 多级联动选择的position
  final List<int> _positions = [];

  // 当前列
  int _currentColumn = 0;

  // 搜索数据
  List _searchData = [];
  bool _isShowSearchResult = false;
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();

    _initData();
    if (widget.values.isNotEmpty) {
      _initSelectData();
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initData() {
    if (widget.data != null) {
      List dataArr = widget.data!;
      _mList = dataArr;
      _myTabs.add(Tab(text: widget.tabText));
      _positions.add(0);
      _tabController = TabController(vsync: this, length: 1);
      _tabController?.animateTo(_currentColumn, duration: Duration.zero);
    }
  }

  void _initSelectData() {
    if (widget.data != null) {
      List dataArr = widget.data!;
      List tempArr = widget.values;
      for (int i = 0; i < tempArr.length; i++) {
        var value = tempArr[i];
        var index = _getTreeIndexByName(dataArr, value);
        _myTabs[_currentColumn] = Tab(text: _mList[index]['title']);
        _positions[_currentColumn] = index;
        _columnIncrement();
        if (_isNotEmptyChildren(_mList[index])) {
          _setListAndChangeTab(index);
        } else {
          _setColumn(_currentColumn - 1);
        }
        _tabController?.animateTo(_currentColumn);
      }
    }
  }

  /// 根据节点的文字获取对应节点所在的index
  /// 根据选中的数组values的每一项的值，通过和valuesKey做对比，获取对应节点所在的index
  _getTreeIndexByName(treeArr, value) {
    for (int i = 0; i < treeArr.length; i++) {
      var item = treeArr[i];
      var newValue = Map<String, dynamic>.from(value);
      if (treeArr[i]['id'] == newValue['id']) {
        return i;
      } else {
        if (_isNotEmptyChildren(item)) {
          var res = _getTreeIndexByName(item['children'], value);
          if (res != null) {
            return res;
          }
        }
      }
    }
  }

  /// 判断Children是否为空
  bool _isNotEmptyChildren(listData) {
    if (listData['children'] != null && listData['children'].length > 0) {
      return true;
    }
    return false;
  }

  void _setColumn(int column) {
    _currentColumn = column;
  }

  void _columnIncrement() {
    _currentColumn++;
  }

  /// tabBar点击后更新数据
  void _onClickTab(currentColumn) {
    if (widget.data != null) {
      List dataArr = widget.data!;
      if (currentColumn == 0) {
        _mList = dataArr;
      } else {
        // 获取点击tabBar的数据（根据上一级tabBar文字获取）
        var tabText = _myTabs[currentColumn - 1].text;
        if (tabText != widget.tabText) {
          var tempData = _getTreeDataByName(dataArr, tabText);
          _mList = tempData['children'];
        }
      }
    }
  }

  /// 根据节点的文字获取对应节点的数据
  _getTreeDataByName(treeArr, name) {
    for (int i = 0; i < treeArr.length; i++) {
      var item = treeArr[i];
      if (treeArr[i]['title'] == name) {
        return item;
      } else {
        if (_isNotEmptyChildren(item)) {
          var res = _getTreeDataByName(item['children'], name);
          if (res != null) {
            return res;
          }
        }
      }
    }
  }

  /// 选项点击后设置下一级数据并改变tabBar
  /// 这里的currentColumn已经+1
  /// index是点击item的索引
  void _setListAndChangeTab(index) {
    if (widget.data != null) {
      if (_myTabs.length <= _currentColumn) {
        _myTabs.add(Tab(text: widget.tabText));
        _positions.add(0);
        _tabController = TabController(
            initialIndex: _currentColumn - 1,
            vsync: this,
            length: _myTabs.length);
      }
      // 更新前的tabText
      var beforeTabText = _myTabs[_currentColumn - 1].text;
      _myTabs[_currentColumn - 1] = Tab(text: _mList[index]['title']);
      _positions[_currentColumn - 1] = index;
      // 更新后的tabText
      var tabText = _mList[index]['title'];
      // 选中改变后删掉多余的Tabs
      if (_myTabs.length > _currentColumn + 1 && beforeTabText != tabText) {
        _myTabs.removeRange(_currentColumn + 1, _myTabs.length);
        _myTabs[_myTabs.length - 1] = Tab(text: widget.tabText);
        _positions.removeRange(_currentColumn + 1, _positions.length);
        _tabController = TabController(
            initialIndex: _currentColumn - 1,
            vsync: this,
            length: _myTabs.length);
      }
      // 设置下一级数据
      _mList = _mList[index]['children'];
    }
  }

  @override
  Widget build(BuildContext context) {
    // 默认颜色
    var bgColor = AppTheme.background;
    var headerColor = AppTheme.white;
    var titleColor = primaryColor;
    var lineColor = primaryColor;
    var textColor = AppTheme.darkText;

    return Container(
      color: bgColor,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 11.0 / 16.0,
        child: Stack(
          children: [
            // header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: _headerHeight,
                color: headerColor,
                alignment: Alignment.center,
                child: Text(widget.title,
                    style:
                        TextStyle(fontSize: _titleFontSize, color: titleColor)),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: _headerHeight,
                  width: _headerHeight * 2,
                  child: Icon(
                    Icons.close,
                    color: titleColor,
                  ),
                ),
              ),
            ),
            _searchBar(),
            Offstage(
              offstage: !_isShowSearchResult,
              child: _searchResultView(bgColor, textColor, lineColor),
            ),
            Offstage(
              offstage: _isShowSearchResult,
              child: _mainWidget(bgColor, textColor, lineColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mainWidget(Color bgColor, Color textColor, Color lineColor) {
    // TODO: 通过ThemeProvider进行主题管理
    var indicatorColor = primaryColor;
    var labelColor = primaryColor;
    var unselectedLabelColor = primaryColor;

    return Container(
      margin: EdgeInsets.only(
          top: _headerHeight + (widget.isShowSearch ? _searchBarHeight : 0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: _lineHeight, child: Container(color: lineColor)),
          Container(
            color: bgColor,
            child: TabBar(
              // key: UniqueKey(),
              // tabs: _myTabs.map<Tab>((Tab tab) {
              //   return Tab(text: tab.text);
              // }).toList(),
              tabs: _myTabs,
              controller: _tabController,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.grey,
              unselectedLabelColor: unselectedLabelColor,
              indicatorColor: indicatorColor,
              tabAlignment: TabAlignment.start,
              dividerHeight: 0.5,
              onTap: (index) {
                if ((_myTabs[index].text ?? '').isEmpty) {
                  // 拦截点击事件
                  _tabController?.animateTo(_currentColumn);
                  return;
                }
                setState(() {
                  _setColumn(index);
                  _onClickTab(index);
                  _scrollController.animateTo(
                    _positions[_currentColumn] * _itemHeight,
                    duration: const Duration(milliseconds: 10),
                    curve: Curves.ease,
                  );
                });
              },
            ),
          ),
          SizedBox(height: _lineHeight, child: Container(color: lineColor)),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemExtent: _itemHeight,
              itemBuilder: (_, index) {
                return _buildItem(index, bgColor, textColor, labelColor);
              },
              itemCount: _mList.length,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(
      int index, Color bgColor, Color textColor, Color themeColor) {
    var tempData = _mList[index];
    bool flag = false;
    if (_currentColumn >= 0) {
      flag = tempData['title'] == _myTabs[_currentColumn].text;
    }

    return InkWell(
      child: Container(
        color: bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Row(
          children: <Widget>[
            Text(
              tempData['title'],
              style: TextStyle(
                  fontSize: _textFontSize,
                  color: flag ? themeColor : textColor),
            ),
            const SizedBox(width: 8),
            Visibility(
              visible: flag,
              child: Icon(Icons.check, size: 15, color: themeColor),
            )
          ],
        ),
      ),
      onTap: () {
        setState(() {
          if (_isNotEmptyChildren(tempData)) {
            // 有子结点
            _columnIncrement();
            _setListAndChangeTab(index);
            // 跳到指定位置
            _scrollController.animateTo(0.0,
                duration: const Duration(milliseconds: 100),
                curve: Curves.ease);
            Future.delayed(const Duration(milliseconds: 100), () {
              _tabController?.animateTo(_currentColumn);
            });
          } else {
            // 无子结点

            // 索引数组
            // _positions[_positions.length - 1] = index;
            // var tempIndexArr = List.from(_positions);

            // 根据末级节点查出包含父节点的数据
            List res =
                _findParentNodeDataByValue(widget.data!, _mList[index]['id']);
            // 选择回调
            widget.clickCallBack?.call(res.last, res);
            // JhNavUtils.goBack(context);
            _setColumn(_currentColumn - 1);
          }
        });
      },
    );
  }

  /// 搜索框相关

  /// 根据搜索文字过滤数据
  _getSearchData(keyword) {
    var data = _getTreeDataByKeyword(keyword, widget.data!);
    var newData = _convertTreeToListData(data, data, []);
    return newData;
  }

  /// 根据关键字过滤树结构数据
  _getTreeDataByKeyword(keyWord, List treeArr) {
    var newArr = [];
    for (var item in treeArr) {
      if (item['title'].contains(keyWord)) {
        newArr.add(item);
      } else {
        if (_isNotEmptyChildren(item)) {
          var res = _getTreeDataByKeyword(keyWord, item['children']);
          if (res != null && res.length > 0) {
            var obj = {...item, widget.childrenKey: res};
            newArr.add(obj);
          }
        }
      }
    }
    return newArr;
  }

  /// 把树结构数据打平为一维数组，拼接父节点和子节点作为搜索结果
  /// resultArr为返回结果，默认为[]
  _convertTreeToListData(List treeArr, List treeArr2, List resultArr) {
    for (int i = 0; i < treeArr.length; i++) {
      var item = treeArr[i];
      if (_isNotEmptyChildren(item)) {
        _convertTreeToListData(item['children'], treeArr2, resultArr);
      } else {
        // 找到末级节点，根据末级节点找到所有父节点进行拼接
        var res = _findParentNodeDataByValue(treeArr2, item['id']);
        if (res != null && res.length > 0) {
          List tempArr = [];
          for (var j = 0; j < res.length; j++) {
            tempArr.add(res[j]['title']);
          }
          var dict = {
            'selectArr': res,
            'text': tempArr.join(widget.splitString),
          };
          resultArr.add(dict);
        }
      }
    }
    return resultArr;
  }

  /// 根据末级节点的value查找所有父节点的数据
  /// onlyName = false ,返回name数组 , 否则返回name和value对象数组
  List<dynamic> _findParentNodeDataByValue(List<dynamic> tree, dynamic value,
      {List<dynamic> result = const [], bool onlyName = false}) {
    var resultList = List<dynamic>.from(result);
    for (var node in tree) {
      if (onlyName) {
        resultList.add(node['title']);
      } else {
        resultList.add({'id': node['id'], 'title': node['title']});
      }
      if (node['id'] == value) {
        return resultList;
      }
      if (node['children'] != null && node['children']!.isNotEmpty) {
        var res = _findParentNodeDataByValue(node['children']!, value,
            result: resultList, onlyName: onlyName);
        // 如果找到结果，则返回结果，结束递归
        if (res.isNotEmpty) {
          return res;
        }
      }
      // 到这里，意味着本次并不是需要的节点，则在resultList中移除
      resultList.removeLast();
    }
    return [];
  }

  Widget _searchBar() {
    return !widget.isShowSearch
        ? Container()
        : Container(
            margin: const EdgeInsets.only(top: _headerHeight),
            // child: SearchBar(),
            child: JhSearchBar(
              hintText: widget.searchHintText,
              text: _searchKeyword,
              inputCallBack: Utils.debounceInput((value) {
                setState(() {
                  _searchKeyword = value;
                  if (value.isNotEmpty) {
                    _searchData = _getSearchData(value);
                    _isShowSearchResult = _searchData.isNotEmpty;
                  } else {
                    _isShowSearchResult = false;
                  }
                });
              }, 500),
            ),
          );
  }

  Widget _searchResultView(Color bgColor, Color textColor, Color lineColor) {
    return Container(
      color: bgColor,
      margin: EdgeInsets.only(
          top: _headerHeight + (widget.isShowSearch ? _searchBarHeight : 0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: _lineHeight, child: Container(color: lineColor)),
          Expanded(
            child: ListView.builder(
              itemExtent: _itemHeight,
              itemBuilder: (_, index) {
                return _buildSearchResultItem(
                    index, bgColor, textColor, lineColor);
              },
              itemCount: _searchData.length,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchResultItem(
      index, Color bgColor, Color textColor, Color lineColor) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: bgColor,
          border:
              Border(bottom: BorderSide(color: lineColor, width: _lineHeight)),
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Text(_searchData[index]['text'],
                  style: TextStyle(
                      fontSize: _searchResultTextFontSize, color: textColor)),
            ),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          var selectItem = _searchData[index];
          List res = selectItem['selectArr'];
          // 选择回调
          widget.clickCallBack?.call(res.last, res);
          // JhNavUtils.goBack(context);
        });
      },
    );
  }
}
