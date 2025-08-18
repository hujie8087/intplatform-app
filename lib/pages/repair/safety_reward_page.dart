import 'package:flutter/material.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class SafetyRewardPage extends StatefulWidget {
  @override
  _SafetyRewardPageState createState() => _SafetyRewardPageState();
}

class _SafetyRewardPageState extends State<SafetyRewardPage> {
  // 安全奖励细则数据
  final List<SafetyRewardItem> rewardItems = [
    SafetyRewardItem(
      sort: 1,
      description: '员工提出安全合理化建议，园区采纳并付诸实施的，',
      price: '500-1000',
    ),
    SafetyRewardItem(
      sort: 2,
      description:
          '积极开展多种形式的安全文化建设活动，对组织实施者奖励 元，安全活动中表现突出的单位或个人按照安环部批准的活动方案奖励标准执行',
      price: '300-500',
    ),
    SafetyRewardItem(
      sort: 3,
      description: '员工避免重大事故发生的奖励 元',
      price: '500-5000',
    ),
    SafetyRewardItem(
      sort: 4,
      description: '员工发现举报重大安全隐患的奖励 元',
      price: '500-5000',
    ),
    SafetyRewardItem(
      sort: 5,
      description: '员工发现举报重大安全事故的奖励 元',
      price: '500-5000',
    ),
    SafetyRewardItem(
      sort: 6,
      description: '员工发现举报 A 类以上违章违规行为的，',
      price: '500',
    ),
    SafetyRewardItem(sort: 7, description: '员工发现举报 B 类违章违规行为的，', price: '300'),
    SafetyRewardItem(sort: 8, description: '员工发现举报 C 类违章违规行为的，', price: '200'),
    SafetyRewardItem(sort: 9, description: '员工发现举报 D 类违章违规行为的，', price: '100'),
    SafetyRewardItem(
      sort: 10,
      description: '其他安全工作有突出贡献的奖励 100-5000 元',
      price: '100-5000',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('安全奖励细则', style: TextStyle(fontSize: 16.px)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 16.px),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 头部说明
            _buildHeader(),
            // 奖励细则列表
            Expanded(child: _buildRewardList()),
          ],
        ),
      ),
    );
  }

  // 构建头部说明
  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.all(12.px),
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor[100]!, primaryColor[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.px),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, color: secondaryColor[600], size: 16.px),
              SizedBox(width: 6.px),
              Text(
                '安全奖励制度',
                style: TextStyle(
                  fontSize: 14.px,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 6.px),
          Text(
            '为了鼓励员工积极参与安全管理，及时发现和消除安全隐患，特制定本奖励制度。',
            style: TextStyle(
              fontSize: 11.px,
              color: Colors.grey[700],
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // 构建奖励列表
  Widget _buildRewardList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12.px),
      itemCount: rewardItems.length,
      itemBuilder: (context, index) {
        return _buildRewardItem(rewardItems[index]);
      },
    );
  }

  // 构建单个奖励项（仅序号和内容，风格简洁紧凑）
  Widget _buildRewardItem(SafetyRewardItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 序号圆圈
          Container(
            width: 20.px,
            height: 20.px,
            margin: EdgeInsets.only(
              left: 12.px,
              top: 12.px,
              right: 8.px,
              bottom: 12.px,
            ),
            decoration: BoxDecoration(
              color: primaryColor[300]!,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                item.sort.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.px,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // 内容
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.px, horizontal: 0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: item.description,
                      style: TextStyle(
                        fontSize: 10.px,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    TextSpan(
                      text: item.price,
                      style: TextStyle(
                        fontSize: 12.px,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                    // 如有“元”等单位可再加
                    TextSpan(
                      text: '元',
                      style: TextStyle(
                        fontSize: 10.px,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 安全奖励项数据模型
class SafetyRewardItem {
  final int sort;
  final String description; // 奖励描述（不含金额）
  final String price; // 奖励金额（只含金额数字/区间）

  SafetyRewardItem({
    required this.sort,
    required this.description,
    required this.price,
  });
}
