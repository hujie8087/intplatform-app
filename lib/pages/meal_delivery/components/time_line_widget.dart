import 'package:flutter/material.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineWidget extends StatelessWidget {
  final String eventText;
  final bool isfirst;
  final bool isLast;
  final String status;
  final String? formattedTime;

  const TimelineWidget({
    super.key,
    required this.eventText,
    required this.isfirst,
    required this.isLast,
    required this.status,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    // 格式化日期和时间
    bool isCompleted = status == 'completed';
    bool isInProgress = status == 'inProgress';
    bool notStarted = status == 'notStarted';

    return TimelineTile(
      alignment: TimelineAlign.start,
      isFirst: isfirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        padding:
            !notStarted
                ? EdgeInsets.only(left: 8.px, right: 8.px, bottom: 7.px)
                : EdgeInsets.only(left: 8.px, right: 8.px),
        width: 45.px,
        height: 27.px,
        indicatorXY: 0.2,
        indicator: Stack(
          children: [
            if (notStarted)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 2),
                ),
              ),
            if (isCompleted)
              Icon(Icons.check_circle, color: Colors.green, size: 16.px),
            if (isInProgress)
              Icon(Icons.watch_later_rounded, color: Colors.green, size: 16.px),
          ],
        ),
        drawGap: true,
      ),
      afterLineStyle: LineStyle(
        color: !notStarted ? Colors.green : Colors.grey,
        thickness: 3.px,
      ),
      beforeLineStyle: LineStyle(
        color: !notStarted ? Colors.green : Colors.grey,
        thickness: 3.px,
      ),
      endChild: Container(
        constraints: BoxConstraints(minHeight: !notStarted ? 90.px : 60.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eventText,
              style: TextStyle(color: !notStarted ? Colors.black : Colors.grey),
            ),
            if (!notStarted)
              Text(
                formattedTime!,
                style: TextStyle(
                  color: !notStarted ? Colors.black : Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
