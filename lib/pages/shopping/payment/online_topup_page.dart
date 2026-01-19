import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/data/shopping_utils.dart';
import 'package:logistics_app/http/model/card_info_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/utils/color.dart';

import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';

class OnlineTopupPage extends StatefulWidget {
  const OnlineTopupPage({Key? key}) : super(key: key);

  @override
  _OnlineTopupPageState createState() => _OnlineTopupPageState();
}

class _OnlineTopupPageState extends State<OnlineTopupPage> {
  CardInfoModel? cardInfo;
  ThirdUserInfoModel? userInfo;
  bool isLoading = false;
  final TextEditingController _amountController = TextEditingController();
  int creditLimit = 0;
  int usedCreditLimit = 0;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchCardInfo();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _fetchCardInfo() async {
    var userInfoData = await SpUtils.getModel('thirdUserInfo');
    if (userInfoData != null) {
      userInfo = ThirdUserInfoModel.fromJson(userInfoData);
    }
    // 获取信用额度
    DataUtils.getData(
      APIs.getUserCreditLimit,
      null,
      success: (data) {
        if (mounted) {
          setState(() {
            creditLimit = data['data'];
          });
        }
      },
      fail: (code, msg) {
        ProgressHUD.showError(msg);
      },
    );
    // 获取已使用信用额度
    DataUtils.getData(
      APIs.getUserUsedCreditLimit,
      null,
      success: (data) {
        if (mounted) {
          setState(() {
            usedCreditLimit = data['data'];
          });
        }
      },
      fail: (code, msg) {
        ProgressHUD.showError(msg);
      },
    );
    ShoppingUtils.getCardInfo(
      {'uniqueId': userInfo?.account},
      success: (data) {
        if (mounted) {
          setState(() {
            cardInfo = CardInfoModel.fromJson(data['data']);
          });
        }
      },
      fail: (code, msg) {
        ProgressHUD.showError(msg);
      },
    );
  }

  void _submitTopup() {
    final amount = _amountController.text;
    if (amount.isEmpty) {
      ProgressHUD.showError('请输入充值金额');
      return;
    }
    isLoading = true;
    // Mock processing
    ProgressHUD.showLoadingText('充值中...');
    DataUtils.onlineTopup(
      {'amount': amount},
      success: (data) {
        if (mounted) {
          setState(() {
            ProgressHUD.showSuccess('充值成功');
            isLoading = false;
            _amountController.clear();
            _fetchCardInfo();
          });
        }
      },
      fail: (code, msg) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          ProgressHUD.showError(msg);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).online_recharge,
          style: TextStyle(fontSize: 16.px),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.px),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.px),
          child: Column(
            children: [
              _buildInfoCard(),
              SizedBox(height: 24.px),
              _buildInputSection(),
              SizedBox(height: 32.px),
              _buildSubmitButton(),
              SizedBox(height: 20.px),
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.px),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor[500]!, primaryColor[500]!.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.px),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).current_balance,
            style: TextStyle(color: Colors.white70, fontSize: 14.px),
          ),
          SizedBox(height: 8.px),
          Text(
            cardInfo?.balance ?? '0.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.px,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.px),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).recharge_limit,
                      style: TextStyle(color: Colors.white70, fontSize: 12.px),
                    ),
                    SizedBox(height: 4.px),
                    Text(
                      creditLimit.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.px,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1.px, height: 30.px, color: Colors.white24),
              SizedBox(width: 16.px),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).used_credit_limit,
                      style: TextStyle(color: Colors.white70, fontSize: 12.px),
                    ),
                    SizedBox(height: 4.px),
                    Text(
                      usedCreditLimit.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.px,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).amount,
          style: TextStyle(
            fontSize: 16.px,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.px),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 0.px),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.px),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              SizedBox(width: 12.px),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    fontSize: 14.px,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: S.of(context).inputMessage(S.of(context).amount),
                    hintStyle: TextStyle(
                      fontSize: 14.px,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onDebounceSubmit() {
    if (isLoading) return;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _submitTopup();
    });
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 40.px,
      child: ElevatedButton(
        onPressed: isLoading ? null : _onDebounceSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor[500],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.px),
          ),
          elevation: 2,
        ),
        child: Text(
          isLoading ? S.of(context).submitting : S.of(context).submit,
          style: TextStyle(
            fontSize: 14.px,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.all(16.px),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.px),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                S.of(context).recharge_rules,
                style: TextStyle(
                  fontSize: 14.px,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.px),
          _buildRuleItem('1. 极速到账：', '充值成功后，消费积分立即到账，可即时使用，无需等待。'),
          SizedBox(height: 8.px),
          _buildRuleItem('2. 兑换比例：', '1 消费积分 = 1,000 印尼盾 (IDR)。'),
          SizedBox(height: 8.px),
          _buildRuleItem('3. 薪资代扣（当月结清）', ''),
          Padding(
            padding: EdgeInsets.only(left: 8.px, top: 4.px),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRuleItem('• 扣款时间：', '本月产生的所有充值金额，将统一在发放本月工资时扣除。'),
                Padding(
                  padding: EdgeInsets.only(
                    left: 12.px,
                    top: 2.px,
                    bottom: 4.px,
                  ),
                  child: Text(
                    '例：1月份的充值，将在1月份工资中扣除。',
                    style: TextStyle(
                      fontSize: 12.px,
                      color: Colors.black45,
                      height: 1.4,
                    ),
                  ),
                ),
                _buildRuleItem('• 汇率计算：', '扣款金额将按充值当月的公司设定汇率进行折算。'),
              ],
            ),
          ),
          SizedBox(height: 8.px),
          _buildRuleItem('4. 额度说明：', '每月享有固定充值额度，次月1日自动重置，额度不累计。'),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String title, String content) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 12.px, height: 1.5),
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          if (content.isNotEmpty)
            TextSpan(
              text: ' $content',
              style: TextStyle(color: Colors.black54),
            ),
        ],
      ),
    );
  }
}
