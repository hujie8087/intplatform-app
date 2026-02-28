import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/data/shopping_utils.dart';
import 'package:logistics_app/http/model/card_info_model.dart';
import 'package:logistics_app/http/model/top_up_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/shopping/payment/signature_page.dart';
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
  List<SignatureModel> signatureList = [];
  SignatureModel? selectSignature;
  String password = '';
  String exchangeRate = '0.00';

  @override
  void initState() {
    super.initState();
    _fetchCardInfo();
    _fetchSignatureList();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // 获取签名列表
  void _fetchSignatureList({VoidCallback? onSuccess}) {
    DataUtils.getSignature(
      {'current': "1", 'size': "100"},
      success: (data) {
        if (mounted) {
          setState(() {
            final List<dynamic>? rawList = data['data']['list'];

            if (rawList != null) {
              signatureList =
                  rawList
                      .map<SignatureModel>((e) => SignatureModel.fromJson(e))
                      .toList();
            } else {
              signatureList = [];
            }
          });
          onSuccess?.call();
        }
      },
      fail: (code, msg) {
        ProgressHUD.showError(msg);
      },
    );
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
    // 获取当月汇率
    DataUtils.getData(
      APIs.getExchangeRate,
      null,
      success: (data) {
        if (mounted) {
          setState(() {
            exchangeRate = data['data']['exchangeRate'] ?? '0.00';
          });
        }
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
    Map<String, dynamic> params = {
      'amount': amount,
      'password': password,
      'sign': selectSignature?.signImageUrl,
    };

    isLoading = true;
    ProgressHUD.showLoadingText('充值中...');
    DataUtils.onlineTopup(
      params,
      success: (data) {
        if (mounted) {
          setState(() {
            ProgressHUD.showSuccess('充值成功');
            isLoading = false;
            _amountController.clear();
            _fetchCardInfo();
            Navigator.pop(context);
          });
        }
      },
      fail: (code, msg) {
        if (mounted) {
          setState(() {
            isLoading = false;
            Navigator.pop(context);
          });
          ProgressHUD.showError(msg);
        }
      },
    );
  }

  // Show Password Dialog
  void _showPasswordDialog(String amount) {
    double amountVal = double.parse(amount);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('请输入登录密码', style: TextStyle(fontSize: 14.px)),
          content: TextField(
            obscureText: true,
            onChanged: (value) => password = value,
            decoration: InputDecoration(
              hintText: '登录密码',
              hintStyle: TextStyle(fontSize: 12.px),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('取消'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (password.isEmpty) {
                  ProgressHUD.showError('请输入密码');
                  return;
                }
                if (amountVal < 1000) {
                  _submitTopup();
                } else {
                  if (signatureList.isEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignaturePage()),
                    ).then((result) {
                      if (result == true) {
                        // 签名成功，执行充值
                        Navigator.pop(context); // Close Password Dialog first
                        _fetchSignatureList(
                          onSuccess: () {
                            _showSignatureDialog();
                          },
                        );
                      }
                    });
                  } else {
                    // 弹出选择签名弹窗
                    _showSignatureDialog();
                  }
                }
              },
              child: Text(amountVal >= 1000 ? '确认' : '确认充值'),
            ),
          ],
        );
      },
    );
  }

  void _validateAndSubmit() {
    if (userInfo?.country != 2) {
      ProgressHUD.showError('充值功能暂只对中国籍员工开放，如信息有误可联系部门文员处理！');
      return;
    }
    final amountText = _amountController.text;
    if (amountText.isEmpty) {
      ProgressHUD.showError('请输入充值金额');
      return;
    }

    double? amountVal = double.tryParse(amountText);
    if (amountVal == null) {
      ProgressHUD.showError('请输入有效的数字');
      return;
    }

    // 1. Integer 100 validation
    if (amountVal % 100 != 0) {
      ProgressHUD.showError('充值金额必须是100的整数倍');
      return;
    }

    // 3. Password Check (Always required)
    _showPasswordDialog(amountText);
  }

  void _showSignatureDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(
                '请选择签名(充值金额超过1000需要签名)',
                style: TextStyle(fontSize: 14.px),
              ),
              content: Container(
                width: double.maxFinite,
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.px,
                    mainAxisSpacing: 8.px,
                  ),
                  itemCount: signatureList.length + 1,
                  itemBuilder: (context, index) {
                    if (index == signatureList.length) {
                      // Add button
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignaturePage(),
                            ),
                          ).then((result) {
                            if (result == true) {
                              _fetchSignatureList(
                                onSuccess: () {
                                  setStateDialog(() {});
                                },
                              );
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[300]!,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(5.px),
                            color: Colors.grey[100],
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.grey,
                            size: 30.px,
                          ),
                        ),
                      );
                    }
                    final item = signatureList[index];
                    final isSelected = selectSignature?.id == item.id;
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setStateDialog(() {
                              selectSignature = item;
                            });
                            setState(() {});
                          },
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.px),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? primaryColor
                                        : Colors.grey[300]!,
                                width: isSelected ? 2.px : 1.px,
                              ),
                            ),
                            child: Image.network(
                              APIs.imagePrefix + (item.signImageUrl ?? ''),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder:
                                  (ctx, err, stack) => Icon(Icons.error),
                            ),
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(2.px),
                              color: primaryColor,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 12.px,
                              ),
                            ),
                          ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              // Delete confirmation
                              showDialog(
                                context: context,
                                builder:
                                    (ctx) => AlertDialog(
                                      title: Text(
                                        '提示',
                                        style: TextStyle(fontSize: 14.px),
                                      ),
                                      content: Text(
                                        '确定删除该签名吗？',
                                        style: TextStyle(fontSize: 12.px),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: Text(
                                            '取消',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            // Call delete API
                                            DataUtils.deleteSignature(
                                              [item.id],
                                              success: (_) {
                                                ProgressHUD.showSuccess('删除成功');
                                                _fetchSignatureList(
                                                  onSuccess: () {
                                                    if (selectSignature?.id ==
                                                        item.id) {
                                                      selectSignature = null;
                                                      setState(() {});
                                                    }
                                                    setStateDialog(() {});
                                                  },
                                                );
                                              },
                                              fail:
                                                  (c, m) =>
                                                      ProgressHUD.showError(m),
                                            );
                                          },
                                          child: Text('确定'),
                                        ),
                                      ],
                                    ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5.px),
                                ),
                              ),
                              padding: EdgeInsets.all(2.px),
                              child: Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 16.px,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    '取消',
                    style: TextStyle(color: Colors.grey, fontSize: 14.px),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectSignature == null) {
                      ProgressHUD.showError('请选择签名');
                      return;
                    }
                    _submitTopup();
                    Navigator.pop(context);
                  },
                  child: Text('确定', style: TextStyle(fontSize: 14.px)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            );
          },
        );
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
          Row(
            children: [
              Column(
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
                ],
              ),
              Spacer(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '当月汇率',
                      style: TextStyle(color: Colors.white70, fontSize: 12.px),
                    ),
                    SizedBox(height: 4.px),
                    Text(
                      exchangeRate,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.px,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
              Container(width: 1.px, height: 30.px, color: Colors.white24),
              SizedBox(width: 16.px),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '剩余额度',
                      style: TextStyle(color: Colors.white70, fontSize: 12.px),
                    ),
                    SizedBox(height: 4.px),
                    Text(
                      (creditLimit - usedCreditLimit).toString(),
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

  Widget _buildQuickAmountChip(int amount) {
    return ActionChip(
      label: Text(amount.toString()),
      onPressed: () {
        setState(() {
          _amountController.text = amount.toString();
        });
      },
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(color: Colors.black87),
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
        SizedBox(height: 12.px),
        // Quick Select Amounts
        Wrap(
          spacing: 12.px,
          runSpacing: 8.px,
          children: [
            _buildQuickAmountChip(100),
            _buildQuickAmountChip(500),
            _buildQuickAmountChip(1000),
            _buildQuickAmountChip(3000),
            _buildQuickAmountChip(5000),
          ],
        ),
      ],
    );
  }

  void _onDebounceSubmit() {
    if (isLoading) return;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _validateAndSubmit(); // Use new validation method
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
          _buildRuleItem('2. 充值积分:', '即消费卡积分。'),
          SizedBox(height: 8.px),
          _buildRuleItem('3. 兑换比例:', '1消费积分=1,000印尼盾(1Rp)。'),
          SizedBox(height: 8.px),
          _buildRuleItem('', '4.充值积分在员工在职期间长期有效，可累计使用，不清零。'),
          SizedBox(height: 8.px),
          _buildRuleItem('5. 额度说明:', '4.根据员工职级设置消费卡额度标准，每月额度于每月1日自动发放至消费卡账户。'),
          SizedBox(height: 8.px),
          _buildRuleItem(
            '6. 薪资代扣',
            '充值金额将通过工资以人民币形式代扣，工资代扣月份详见充值记录，扣款金额按财务公布汇率计算。',
          ),
          SizedBox(height: 8.px),
          _buildRuleItem(
            '7. 汇率说明',
            '汇率由公司每月统一公布，按充值当月汇率计算人民币金额，汇率更新后，人民币金额自动更新。',
          ),
          SizedBox(height: 8.px),
          _buildRuleItem(
            '8. 离职退款说明',
            '离职时需办理消费卡注销，未使用积分可以兑换印尼盾或者直接根据公司汇率打到工资卡上，已使用积分不退款。',
          ),
          SizedBox(height: 8.px),
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
