import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/base_list_model.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/http/model/hazard_report_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:badges/badges.dart' as badges;

class MyHazardPage extends StatefulWidget {
  const MyHazardPage({super.key});

  @override
  State<MyHazardPage> createState() => _MyHazardPageState();
}

class _MyHazardPageState extends State<MyHazardPage>
    with TickerProviderStateMixin {
  static const int _pageSize = 10;

  final RefreshController _refreshController = RefreshController();
  final List<HazardReportModel> _hazardList = [];

  int _pageNum = 1;
  int _total = 0;
  bool _isLoading = false;
  ThirdUserInfoModel? _userInfo;
  AnimationController? _animationController;
  List<DictModel> _hazardTypeList = [];

  List<DictModel> _hazardProcessList = [
    DictModel(dictCode: 0, dictLabel: '待处理'),
    DictModel(dictCode: 1, dictLabel: '处理中'),
    DictModel(dictCode: 2, dictLabel: '已完成'),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fetchUserInfo();
  }

  // 获取隐患类型
  Future<void> _fetchHazardType() async {
    DataUtils.getDictDataList(
      'hazard_collection_type',
      success: (data) {
        _hazardTypeList =
            BaseListModel<DictModel>.fromJson(
              data,
              (json) => DictModel.fromJson(json),
            ).data ??
            [];
        setState(() {});
      },
    );
  }

  Future<void> _fetchUserInfo() async {
    final data = await SpUtils.getModel('thirdUserInfo');
    if (data == null) return;
    if (!mounted) return;
    await _fetchHazardType();
    setState(() {
      _userInfo = ThirdUserInfoModel.fromJson(data);
    });
    _getHazardList(isRefresh: true);
  }

  Future<void> _getHazardList({required bool isRefresh}) async {
    if (_userInfo == null || _isLoading) {
      if (isRefresh) {
        _refreshController.refreshCompleted();
      } else {
        _refreshController.loadComplete();
      }
      return;
    }

    if (isRefresh) {
      _pageNum = 1;
    }

    setState(() {
      _isLoading = true;
    });

    final completer = Completer<void>();
    final params = {
      'pageNum': _pageNum,
      'pageSize': _pageSize,
      'createBy': _userInfo?.account,
    };

    DataUtils.getHazardReportList(
      params,
      success: (data) {
        if (!mounted) return;
        final rows = (data?['rows'] as List?) ?? [];
        final total = data?['total'] ?? 0;
        final items = rows
            .map((e) => HazardReportModel.fromJson(e))
            .toList(growable: false);

        setState(() {
          if (isRefresh) {
            _hazardList
              ..clear()
              ..addAll(items);
            _refreshController.refreshCompleted();
            _refreshController.resetNoData();
          } else {
            _hazardList.addAll(items);
            _refreshController.loadComplete();
          }

          _total = total;
          _pageNum++;

          if (_hazardList.length >= _total) {
            _refreshController.loadNoData();
          }
        });
        completer.complete();
      },
      fail: (code, msg) {
        if (!mounted) {
          completer.complete();
          return;
        }
        if (isRefresh) {
          _refreshController.refreshFailed();
        } else {
          _refreshController.loadFailed();
        }
        final errorMessage =
            msg.trim().isNotEmpty ? msg : S.of(context).networkError;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
        completer.complete();
      },
    );

    await completer.future;

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          S.of(context).my_discovery,
          style: TextStyle(fontSize: 16.px),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        // 返回按钮
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: SafeArea(
        child: SmartRefreshWidget(
          enablePullDown: true,
          enablePullUp: true,
          controller: _refreshController,
          onRefresh: () => _getHazardList(isRefresh: true),
          onLoading: () => _getHazardList(isRefresh: false),
          child: Padding(
            padding: EdgeInsets.all(12.px),
            child:
                _hazardList.isEmpty
                    ? (_isLoading ? const SizedBox.shrink() : EmptyView())
                    : _buildHazardList(),
          ),
        ),
      ),
    );
  }

  Widget _buildHazardList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final hazard = _hazardList[index];
        final count = _hazardList.length;
        final animation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _animationController!,
            curve: Interval(
              (1 / count) * index,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        );
        _animationController?.forward();
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return FadeTransition(
              opacity: animation,
              child: Transform.translate(
                offset: Offset(0, 30.px * (1 - animation.value)),
                child: _HazardCard(
                  hazard: hazard,
                  hazardProcessList: _hazardProcessList,
                  hazardTypeList: _hazardTypeList,
                  onRead: () {
                    _getHazardList(isRefresh: true);
                  },
                ),
              ),
            );
          },
        );
      },
      separatorBuilder: (_, __) => SizedBox(height: 12.px),
      itemCount: _hazardList.length,
    );
  }
}

class _HazardCard extends StatefulWidget {
  const _HazardCard({
    required this.hazard,
    required this.hazardProcessList,
    required this.hazardTypeList,
    required this.onRead,
  });

  final HazardReportModel hazard;
  final List<DictModel> hazardProcessList;
  final List<DictModel> hazardTypeList;
  final Function onRead;

  @override
  State<_HazardCard> createState() => _HazardCardState();
}

class _HazardCardState extends State<_HazardCard> {
  bool _isReplyExpanded = false;

  void _toggleReplySection() {
    setState(() {
      _isReplyExpanded = !_isReplyExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hazard = widget.hazard;
    final statusColor =
        hazard.progress == 0
            ? secondaryColor
            : hazard.progress == 1
            ? const Color(0xFFFFC107)
            : secondaryColor;
    final statusText =
        widget.hazardProcessList
            .firstWhere((element) => element.dictCode == hazard.progress)
            .dictLabel;
    final typeLabel =
        widget.hazardTypeList
            .firstWhere(
              (element) => int.parse(element.dictValue ?? '0') == hazard.type,
            )
            .dictLabel;
    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: 0.px, end: 0.px),
      showBadge: widget.hazard.isRead == 1,
      child: InkWell(
        onTap: () {
          if (widget.hazard.isRead == 1) {
            DataUtils.getData(
              '/maintenance/hidden/danger/read/${widget.hazard.id}',
              null,
              success: (data) {
                setState(() {
                  widget.onRead();
                  widget.hazard.isRead = 0;
                });
              },
            );
          }
        },
        child: Container(
          padding: EdgeInsets.all(14.px),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.px),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      hazard.name ?? S.of(context).hazard_name,
                      style: TextStyle(
                        fontSize: 15.px,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.px,
                      vertical: 4.px,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20.px),
                    ),
                    child: Text(
                      statusText ?? '',
                      style: TextStyle(
                        fontSize: 11.px,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.px),
              if ((hazard.findTime ?? '').isNotEmpty)
                _InfoRow(
                  icon: Icons.category_outlined,
                  label: '${S.of(context).hazard_type}: ',
                  value: typeLabel ?? '',
                  textColor: secondaryColor,
                ),
              if ((hazard.location ?? '').isNotEmpty)
                _InfoRow(
                  icon: Icons.place_outlined,
                  label: S.of(context).hazard_location + ': ',
                  value: hazard.location ?? '',
                  textColor: Colors.grey.shade800,
                ),
              if ((hazard.findTime ?? '').isNotEmpty)
                _InfoRow(
                  icon: Icons.schedule_outlined,
                  label: S.of(context).hazard_discovery_time + ': ',
                  value: hazard.findTime!,
                  textColor: Colors.grey.shade800,
                ),
              SizedBox(height: 10.px),
              if ((hazard.describes ?? '').isNotEmpty)
                Text(
                  hazard.describes!,
                  style: TextStyle(
                    fontSize: 13.px,
                    color: Colors.grey.shade800,
                    height: 1.4,
                  ),
                ),
              if (hazard.url != null) ...[
                SizedBox(height: 12.px),
                Wrap(
                  spacing: 8.px,
                  runSpacing: 8.px,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.px),
                      child: Image.network(
                        APIs.imagePrefix + hazard.url!,
                        width: 80.px,
                        height: 80.px,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80.px,
                            height: 80.px,
                            color: Colors.grey[200],
                            child: Icon(Icons.broken_image, size: 20.px),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 12.px),
              if (((hazard.handleResult ?? '').isNotEmpty) ||
                  ((hazard.handlePhoto ?? '').isNotEmpty) ||
                  ((hazard.handleBy ?? '').isNotEmpty) ||
                  ((hazard.handleTime ?? '').isNotEmpty))
                _ReplySection(
                  hazard: hazard,
                  isExpanded: _isReplyExpanded,
                  onToggle: _toggleReplySection,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReplySection extends StatelessWidget {
  const _ReplySection({
    required this.hazard,
    required this.isExpanded,
    required this.onToggle,
  });

  final HazardReportModel hazard;
  final bool isExpanded;
  final VoidCallback onToggle;

  Widget _buildFullContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((hazard.handleResult ?? '').isNotEmpty)
          Text(
            hazard.handleResult ?? '',
            style: TextStyle(
              fontSize: 13.px,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        if ((hazard.handlePhoto ?? '').isNotEmpty) ...[
          SizedBox(height: 12.px),
          Wrap(
            spacing: 8.px,
            runSpacing: 8.px,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.px),
                child: Image.network(
                  APIs.imagePrefix + (hazard.handlePhoto ?? ''),
                  width: 80.px,
                  height: 80.px,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80.px,
                      height: 80.px,
                      color: Colors.grey[200],
                      child: Icon(Icons.broken_image, size: 20.px),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
        if ((hazard.handleBy ?? '').isNotEmpty) ...[
          SizedBox(height: 8.px),
          _InfoRow(
            icon: Icons.person_outline,
            label: '${S.of(context).reply_person}: ',
            value: hazard.handleBy ?? '--',
            textColor: Colors.grey.shade800,
          ),
        ],
        if ((hazard.handleTime ?? '').isNotEmpty)
          _InfoRow(
            icon: Icons.access_time,
            label: '${S.of(context).reply_time}: ',
            value: hazard.handleTime ?? '',
            textColor: Colors.grey.shade800,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
        color: primaryColor[50],
        borderRadius: BorderRadius.circular(10.px),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(8.px),
            child: Row(
              children: [
                Icon(Icons.reply, size: 16.px, color: primaryColor[600]),
                SizedBox(width: 4.px),
                Expanded(
                  child: Text(
                    S.of(context).reply_content,
                    style: TextStyle(
                      fontSize: 13.px,
                      fontWeight: FontWeight.w600,
                      color: primaryColor[700],
                    ),
                  ),
                ),
                Text(
                  isExpanded
                      ? S.of(context).hazard_hide_reply
                      : S.of(context).hazard_expand_reply,
                  style: TextStyle(fontSize: 11.px, color: primaryColor[600]),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 18.px,
                  color: primaryColor[600],
                ),
              ],
            ),
          ),
          SizedBox(height: 6.px),
          AnimatedCrossFade(
            firstChild: Text(
              hazard.handleResult ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.px,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            secondChild: _buildFullContent(context),
            duration: const Duration(milliseconds: 200),
            crossFadeState:
                isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.textColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.px),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 14.px, color: Colors.grey[600]),
          SizedBox(width: 6.px),
          Text(
            label,
            style: TextStyle(fontSize: 12.px, color: Colors.grey[800]),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12.px, color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
