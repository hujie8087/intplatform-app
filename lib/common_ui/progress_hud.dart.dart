import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

const Color _bgColor = Color.fromARGB(150, 0, 0, 0);
const double _radius = 10.0;
const int _closeTime = 3000;

enum _ToastType { text, success, error, info, loading }

class ProgressHUD {
  static showText(String loadingText) {
    return _showToast(loadingText, _ToastType.text);
  }

  static showSuccess(String loadingText) {
    return _showToast(loadingText, _ToastType.success);
  }

  static showError(String loadingText) {
    return _showToast(loadingText, _ToastType.error);
  }

  static showInfo(String loadingText) {
    return _showToast(loadingText, _ToastType.info);
  }

  static showLoadingText([loadingText = '加载中...']) {
    return _showLoading(loadingText);
  }

  /// 隐藏所有Toast
  static hide() {
    dismissAllToast();
  }
}

void _showToast(String loadingText, _ToastType toastType) {
  dismissAllToast();
  showToastWidget(
    _showCustomToast(loadingText, toastType),
    duration: Duration(milliseconds: _closeTime),
    position: ToastPosition.center,
  );
}

void _showLoading(String loadingText) {
  dismissAllToast();
  showToastWidget(
    _showCustomToast(loadingText, _ToastType.loading),
    duration: Duration(milliseconds: _closeTime),
    position: ToastPosition.center,
  );
}

Widget _showCustomToast(String loadingText, _ToastType toastType) {
  Widget topWidget;
  if (toastType == _ToastType.text) {
    topWidget = Container();
  } else if (toastType == _ToastType.loading) {
    topWidget = Container(
      width: 36.0.px,
      height: 36.0.px,
      margin: EdgeInsets.only(bottom: 8.px),
      padding: EdgeInsets.all(4.px),
      child: const CircularProgressIndicator(
        strokeWidth: 3.0,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  } else {
    IconData? icon;
    if (toastType == _ToastType.success) {
      icon = Icons.check_circle_outline;
    }
    if (toastType == _ToastType.error) {
      icon = Icons.highlight_off;
    }
    if (toastType == _ToastType.info) {
      icon = Icons.info_outline;
    }
    topWidget = Container(
      width: 40.px,
      height: 40.px,
      margin: EdgeInsets.only(bottom: 8.px),
      padding: EdgeInsets.all(4.px),
      child: Icon(icon, size: 24.px, color: Colors.white),
    );
  }

  var w = Container(
    margin: EdgeInsets.all(40.px),
    padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 14.px),
    decoration: BoxDecoration(
      color: _bgColor,
      borderRadius: BorderRadius.circular(_radius),
    ),
    child: ClipRect(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Visibility(visible: toastType != _ToastType.text, child: topWidget),
          Text(
            loadingText,
            style: TextStyle(fontSize: 14.px, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
  return w;
}
