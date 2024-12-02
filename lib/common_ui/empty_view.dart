import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import '/project/configs/colors.dart';

const double _verticalTop = 0.0;
const double _space = 10.0; // 控件垂直间距
const double _btnBorderRadius = 20.0; // 边框圆角
const double _textFontSize = 14.0; // 文字大小
const double _btnFontSize = 14.0; // 按钮文字大小

final String _emptyText = S.current.noData;
final String _networkErrorText = S.current.networkErrorTips;
final String _emptyImagePath = 'assets/images/empty/ic_empty.png';
final String _networkErrorImagePath = 'assets/images/empty/ic_netErr.png';

enum EmptyType { empty, error, loading }

class EmptyView extends StatefulWidget {
  const EmptyView({
    Key? key,
    this.type = EmptyType.empty,
    this.image,
    this.text,
    this.verticalTop = _verticalTop,
    this.space = _space,
    this.clickCallBack,
  }) : super(key: key);

  final EmptyType type; // 空数据类型
  final String? image; // 空数据图片,不传根据类型显示默认图片
  final String? text; // 描述文字,不传根据类型显示默认文字
  final double verticalTop; // margin top
  final double space; // 垂直间距
  final VoidCallback? clickCallBack; // 按钮点击回调

  @override
  State<EmptyView> createState() => _EmptyViewState();
}

class _EmptyViewState extends State<EmptyView> {
  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    var image = widget.image ??
        (widget.type == EmptyType.error
            ? _networkErrorImagePath
            : _emptyImagePath);
    var text = widget.text ??
        (widget.type == EmptyType.error ? _networkErrorText : _emptyText);
    // 默认颜色
    var textColor = const Color(0xFFB1BBC3);
    var bgColor = KColors.kThemeColor;

    var empty = Container(
      padding: EdgeInsets.only(top: widget.verticalTop.px, bottom: 20.px),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          image.isNotEmpty ? Image.asset(image) : Container(),
          SizedBox(height: image.isNotEmpty ? widget.space : 0),
          Text(text,
              style: TextStyle(fontSize: _textFontSize.px, color: textColor)),
          SizedBox(height: widget.type == EmptyType.error ? widget.space : 0),
          Visibility(
            visible: widget.type == EmptyType.error,
            child: GestureDetector(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 50.px),
                width: double.infinity,
                height: 40.px,
                decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(_btnBorderRadius)),
                child: Center(
                  child: Text(S.of(context).clickRetry,
                      style: TextStyle(
                          fontSize: _btnFontSize.px, color: Colors.white)),
                ),
              ),
              onTap: () => widget.clickCallBack?.call(),
            ),
          ),
        ],
      ),
    );

    return empty;
  }
}
