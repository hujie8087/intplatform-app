import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'package:logistics_app/http/model/canteen_layout_model.dart';

class CanteenLayoutWidget extends StatefulWidget {
  final CanteenLayoutModel canteenLayout;
  final Function(FoodCanteenLayoutDeskList table) onTableSelected;
  const CanteenLayoutWidget({
    Key? key,
    required this.canteenLayout,
    required this.onTableSelected,
  }) : super(key: key);

  @override
  _CanteenLayoutWidgetState createState() => _CanteenLayoutWidgetState();
}

class _CanteenLayoutWidgetState extends State<CanteenLayoutWidget> {
  final TransformationController _transformationController =
      TransformationController();
  bool _initialScaleSet = false;
  FoodCanteenLayoutDeskList? _selectedTable;
  String? _selectedTableOriginalStatus;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double layoutWidth = widget.canteenLayout.width?.toDouble() ?? 0;
    final double layoutHeight = widget.canteenLayout.height?.toDouble() ?? 0;
    // 防止除以0
    final double aspectRatio =
        (layoutHeight > 0) ? (layoutWidth / layoutHeight) : 1.0;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (!_initialScaleSet && layoutWidth > 0) {
              final double scale = constraints.maxWidth / layoutWidth;
              _transformationController.value =
                  Matrix4.identity()..scale(scale);
              _initialScaleSet = true;
            }

            return Listener(
              onPointerDown: (event) {
                // 触摸时阻止父级 Scrollable 滚动，解决手势冲突
                try {
                  Scrollable.of(context).position.hold(() {});
                } catch (e) {
                  debugPrint('Scrollable hold error: $e');
                }
              },
              child: InteractiveViewer(
                transformationController: _transformationController,
                // 支持双指缩放和平移，完美复刻网页端体验
                boundaryMargin: EdgeInsets.all(layoutWidth / 2), // 允许拖出边界
                minScale: 0.1,
                maxScale: 3.0,
                constrained: false, // 解除约束，允许内容超出屏幕大小
                child: Container(
                  width: layoutWidth,
                  height: layoutHeight,
                  // 绘制背景网格（可选，为了好看）
                  child: Stack(
                    // 重点：使用 Stack 模拟 absolute 定位
                    children:
                        widget.canteenLayout.foodCanteenLayoutDeskList!.map((
                          table,
                        ) {
                          return _buildTableItem(table);
                        }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTableItem(FoodCanteenLayoutDeskList table) {
    // 状态颜色映射 (对应 Vue 里的 tableStatusOptions tagType)
    Color tableColor;
    if (table.status == '0') {
      tableColor = Color(0xFF009688); // 可预订
    } else if (table.status == '1') {
      tableColor = Color(0xFF67C23A); // 已预订
    } else if (table.status == '2') {
      tableColor = Color(0xFFE6A23C); // 使用中
    } else if (table.status == '3') {
      tableColor = Color(0xFF909399); // 暂停使用
    } else if (table.status == '4') {
      tableColor = Colors.red; // 已选中
    } else {
      tableColor = Color(0xFF909399); // 其他状态
    }

    return Positioned(
      left: table.x?.toDouble() ?? 0,
      top: table.y?.toDouble() ?? 0,
      child: GestureDetector(
        onTap: () {
          // 4:实际上是客户端临时状态，如果已经是选中状态，点击无反应（或者可以取消选中，这里按需求"禁止选"理解为忽略）
          if (table.status == '4') {
            return;
          }
          // 3: 暂停使用，不可选
          if (table.status == '3') {
            return;
          }

          setState(() {
            // 如果之前有选中的桌子，恢复其状态
            if (_selectedTable != null) {
              _selectedTable!.status = _selectedTableOriginalStatus;
            }

            // 记录当前点击桌子的原始状态
            _selectedTableOriginalStatus = table.status;

            // 更新选中桌子
            _selectedTable = table;
            table.status = '4'; // 设置为选中状态

            widget.onTableSelected(_selectedTable!);
          });
          print("点击了桌台: ${table.label}");
        },
        child: Transform.rotate(
          // Vue 里的 rotation 是角度，Flutter 需要弧度
          angle: table.rotation != null ? table.rotation! * (math.pi / 180) : 0,
          child: Container(
            width: table.width?.toDouble() ?? 0,
            height: table.height?.toDouble() ?? 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. SVG 图标
                SvgPicture.asset(
                  'assets/images/svg/${table.icon}.svg',
                  width: table.width?.toDouble() ?? 0,
                  height: table.height?.toDouble() ?? 0,
                  // 这里用 colorFilter 给 SVG 整体着色，表示状态
                  colorFilter: ColorFilter.mode(tableColor, BlendMode.srcIn),
                  fit: BoxFit.fill,
                ),

                // 2. 桌号文字 (Vue 代码里的 .table-content)
                // 如果桌子旋转了，文字要不要跟着转？
                // 通常文字需要反向旋转保持水平，或者就跟着桌子转。
                // 这里演示跟着桌子转的情况。
                Text(
                  table.label!,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
