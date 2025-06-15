import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/bus_timetable_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';

class BusTimetablePage extends StatefulWidget {
  const BusTimetablePage({Key? key}) : super(key: key);

  @override
  _BusTimetablePageState createState() => _BusTimetablePageState();
}

class _BusTimetablePageState extends State<BusTimetablePage>
    with TickerProviderStateMixin {
  // 刷新控制器
  late RefreshController _refreshController;

  // 静态的公交时刻表数据
  List<BusTimetable> _busTimetableList = [
    BusTimetable.fromJson({
      "routeId": "101",
      "name": "1路",
      "stops": [
        {"stopId": "s1", "name": "丹江坞", "idName": "TANJUNG ULE", "order": 1},
        {"stopId": "s2", "name": "新医院", "idName": "KLINIK", "order": 2},
      ],
      "directions": [
        {
          "directionId": "0",
          "name": "丹江坞-新医院",
          "trips": [
            {
              "tripId": "trip_101_1",
              "departureTime": "05:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_2",
              "departureTime": "06:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_3",
              "departureTime": "06:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_4",
              "departureTime": "06:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_5",
              "departureTime": "06:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_6",
              "departureTime": "06:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_7",
              "departureTime": "06:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_8",
              "departureTime": "07:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_9",
              "departureTime": "07:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_10",
              "departureTime": "07:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_11",
              "departureTime": "07:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_12",
              "departureTime": "07:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_13",
              "departureTime": "07:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_14",
              "departureTime": "08:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_15",
              "departureTime": "08:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_16",
              "departureTime": "09:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_17",
              "departureTime": "10:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_18",
              "departureTime": "11:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_19",
              "departureTime": "11:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_20",
              "departureTime": "11:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_21",
              "departureTime": "13:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_22",
              "departureTime": "13:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_23",
              "departureTime": "14:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_24",
              "departureTime": "14:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_25",
              "departureTime": "16:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_26",
              "departureTime": "16:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_27",
              "departureTime": "17:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_28",
              "departureTime": "17:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_29",
              "departureTime": "17:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_30",
              "departureTime": "17:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_31",
              "departureTime": "17:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_32",
              "departureTime": "18:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_33",
              "departureTime": "18:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_34",
              "departureTime": "18:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_35",
              "departureTime": "18:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_36",
              "departureTime": "18:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_37",
              "departureTime": "18:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_38",
              "departureTime": "19:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_39",
              "departureTime": "19:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_40",
              "departureTime": "19:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_41",
              "departureTime": "19:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_42",
              "departureTime": "19:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_43",
              "departureTime": "19:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_44",
              "departureTime": "20:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_45",
              "departureTime": "20:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_46",
              "departureTime": "20:40",
              "arrivalTime": "",
            },
          ],
        },
        {
          "directionId": "1",
          "name": "新医院-丹江坞",
          "trips": [
            {
              "tripId": "trip_101_1",
              "departureTime": "06:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_2",
              "departureTime": "06:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_3",
              "departureTime": "06:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_4",
              "departureTime": "06:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_5",
              "departureTime": "06:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_6",
              "departureTime": "06:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_7",
              "departureTime": "07:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_8",
              "departureTime": "07:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_9",
              "departureTime": "07:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_10",
              "departureTime": "07:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_11",
              "departureTime": "07:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_12",
              "departureTime": "07:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_13",
              "departureTime": "08:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_14",
              "departureTime": "08:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_15",
              "departureTime": "09:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_16",
              "departureTime": "10:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_17",
              "departureTime": "10:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_18",
              "departureTime": "11:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_19",
              "departureTime": "11:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_20",
              "departureTime": "12:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_21",
              "departureTime": "13:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_22",
              "departureTime": "13:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_23",
              "departureTime": "14:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_24",
              "departureTime": "15:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_25",
              "departureTime": "16:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_26",
              "departureTime": "17:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_27",
              "departureTime": "17:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_28",
              "departureTime": "17:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_29",
              "departureTime": "17:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_30",
              "departureTime": "17:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_31",
              "departureTime": "18:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_32",
              "departureTime": "18:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_33",
              "departureTime": "18:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_34",
              "departureTime": "18:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_35",
              "departureTime": "18:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_36",
              "departureTime": "18:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_37",
              "departureTime": "19:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_38",
              "departureTime": "19:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_39",
              "departureTime": "19:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_40",
              "departureTime": "19:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_41",
              "departureTime": "19:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_42",
              "departureTime": "19:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_43",
              "departureTime": "20:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_44",
              "departureTime": "20:20",
              "arrivalTime": "",
            },
          ],
        },
      ],
    }),
    BusTimetable.fromJson({
      "routeId": "102",
      "name": "2路",
      "stops": [
        {"stopId": "s1", "name": "丹江坞", "idName": "TANJUNG ULE", "order": 1},
        {"stopId": "s2", "name": "海港特", "idName": "Jeti", "order": 2},
        {
          "stopId": "s3",
          "name": "精加工",
          "idName": "Divisi Perbaikan Mekanik",
          "order": 3,
        },
        {"stopId": "s4", "name": "锂电池", "idName": "Litium", "order": 4},
        {"stopId": "s5", "name": "1号换电站", "idName": "Travo 1", "order": 5},
        {"stopId": "s2", "name": "海港特", "idName": "Jeti", "order": 2},
        {"stopId": "s1", "name": "丹江坞", "idName": "TANJUNG ULE", "order": 1},
      ],
      "directions": [
        {
          "directionId": "0",
          "name": "2A车",
          "trips": [
            {
              "tripId": "trip_101_1",
              "departureTime": "05:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_2",
              "departureTime": "06:15",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_3",
              "departureTime": "06:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_4",
              "departureTime": "07:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_5",
              "departureTime": "07:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_6",
              "departureTime": "07:55",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_7",
              "departureTime": "08:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_8",
              "departureTime": "09:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_9",
              "departureTime": "11:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_10",
              "departureTime": "11:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_11",
              "departureTime": "13:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_12",
              "departureTime": "14:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_13",
              "departureTime": "16:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_14",
              "departureTime": "17:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_15",
              "departureTime": "17:25",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_16",
              "departureTime": "17:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_17",
              "departureTime": "18:15",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_18",
              "departureTime": "18:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_19",
              "departureTime": "19:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_20",
              "departureTime": "19:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_21",
              "departureTime": "19:55",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_22",
              "departureTime": "20:10",
              "arrivalTime": "",
            },
          ],
        },
        {
          "directionId": "0",
          "name": "2B车",
          "trips": [
            {
              "tripId": "trip_102_1",
              "departureTime": "06:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_2",
              "departureTime": "06:25",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_3",
              "departureTime": "06:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_4",
              "departureTime": "07:15",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_5",
              "departureTime": "07:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_6",
              "departureTime": "08:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_7",
              "departureTime": "08:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_8",
              "departureTime": "10:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_9",
              "departureTime": "11:25",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_10",
              "departureTime": "12:15",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_11",
              "departureTime": "13:25",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_12",
              "departureTime": "15:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_13",
              "departureTime": "17:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_14",
              "departureTime": "17:45",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_15",
              "departureTime": "18:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_16",
              "departureTime": "18:35",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_17",
              "departureTime": "19:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_18",
              "departureTime": "19:25",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_19",
              "departureTime": "19:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_20",
              "departureTime": "20:15",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_21",
              "departureTime": "20:40",
              "arrivalTime": "",
            },
          ],
        },
      ],
    }),
    BusTimetable.fromJson({
      "routeId": "103",
      "name": "3路",
      "stops": [
        {"stopId": "s1", "name": "李白", "idName": "Lipe Akomodasi", "order": 1},
        {"stopId": "s2", "name": "3号桥", "idName": "Jembatan 3", "order": 2},
        {"stopId": "s3", "name": "2号桥", "idName": "Jembatan 2", "order": 3},
        {
          "stopId": "s4",
          "name": "机修车间",
          "idName": "Mekanik Divisi Perbaikan",
          "order": 4,
        },
        {"stopId": "s5", "name": "镍铁A区", "idName": "Smelter A", "order": 5},
        {"stopId": "s6", "name": "镍铁B区", "idName": "Smelter B", "order": 6},
        {"stopId": "s7", "name": "镍铁C区", "idName": "Smelter B", "order": 7},
        {"stopId": "s8", "name": "2号桥", "idName": "Jembatan 2", "order": 8},
        {"stopId": "s9", "name": "3号桥", "idName": "Jembatan 3", "order": 9},
        {
          "stopId": "s10",
          "name": "李白",
          "idName": "Lipe Akomodasi",
          "order": 10,
        },
      ],
      "directions": [
        {
          "directionId": "0",
          "name": "3A车",
          "trips": [
            {
              "tripId": "trip_103_1",
              "departureTime": "05:45",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_2",
              "departureTime": "06:15",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_3",
              "departureTime": "06:45",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_4",
              "departureTime": "07:15",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_5",
              "departureTime": "07:45",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_6",
              "departureTime": "08:15",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_7",
              "departureTime": "09:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_8",
              "departureTime": "11:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_9",
              "departureTime": "12:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_10",
              "departureTime": "14:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_11",
              "departureTime": "16:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_12",
              "departureTime": "17:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_13",
              "departureTime": "18:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_14",
              "departureTime": "19:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_15",
              "departureTime": "19:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_16",
              "departureTime": "20:40",
              "arrivalTime": "",
            },
          ],
        },
        {
          "directionId": "0",
          "name": "3B车",
          "trips": [
            {
              "tripId": "trip_103_1",
              "departureTime": "05:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_2",
              "departureTime": "06:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_3",
              "departureTime": "06:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_4",
              "departureTime": "07:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_5",
              "departureTime": "07:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_6",
              "departureTime": "08:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_7",
              "departureTime": "10:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_8",
              "departureTime": "11:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_9",
              "departureTime": "12:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_10",
              "departureTime": "14:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_11",
              "departureTime": "16:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_12",
              "departureTime": "17:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_13",
              "departureTime": "18:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_14",
              "departureTime": "19:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_15",
              "departureTime": "20:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_16",
              "departureTime": "20:50",
              "arrivalTime": "",
            },
          ],
        },
        {
          "directionId": "0",
          "name": "3C车",
          "trips": [
            {
              "tripId": "trip_103_1",
              "departureTime": "05:55",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_2",
              "departureTime": "06:25",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_3",
              "departureTime": "06:55",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_4",
              "departureTime": "07:25",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_5",
              "departureTime": "07:55",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_6",
              "departureTime": "08:25",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_7",
              "departureTime": "10:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_8",
              "departureTime": "11:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_9",
              "departureTime": "13:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_10",
              "departureTime": "15:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_11",
              "departureTime": "16:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_12",
              "departureTime": "17:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_13",
              "departureTime": "18:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_14",
              "departureTime": "19:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_15",
              "departureTime": "20:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_16",
              "departureTime": "21:00",
              "arrivalTime": "",
            },
          ],
        },

        {
          "directionId": "0",
          "name": "3D车",
          "trips": [
            {
              "tripId": "trip_103_1",
              "departureTime": "06:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_2",
              "departureTime": "06:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_3",
              "departureTime": "07:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_4",
              "departureTime": "07:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_5",
              "departureTime": "08:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_6",
              "departureTime": "08:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_7",
              "departureTime": "11:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_8",
              "departureTime": "12:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_9",
              "departureTime": "13:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_10",
              "departureTime": "15:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_11",
              "departureTime": "17:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_12",
              "departureTime": "17:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_13",
              "departureTime": "18:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_14",
              "departureTime": "19:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_15",
              "departureTime": "20:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_16",
              "departureTime": "21:10",
              "arrivalTime": "",
            },
          ],
        },

        {
          "directionId": "0",
          "name": "3E车",
          "trips": [
            {
              "tripId": "trip_103_1",
              "departureTime": "06:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_2",
              "departureTime": "06:35",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_3",
              "departureTime": "07:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_4",
              "departureTime": "07:35",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_5",
              "departureTime": "08:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_6",
              "departureTime": "09:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_7",
              "departureTime": "11:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_8",
              "departureTime": "12:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_9",
              "departureTime": "13:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_10",
              "departureTime": "16:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_11",
              "departureTime": "17:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_12",
              "departureTime": "18:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_13",
              "departureTime": "18:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_14",
              "departureTime": "19:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_15",
              "departureTime": "20:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_16",
              "departureTime": "21:20",
              "arrivalTime": "",
            },
          ],
        },
      ],
    }),
    BusTimetable.fromJson({
      "routeId": "104",
      "name": "4路",
      "stops": [
        {"stopId": "s1", "name": "李白", "idName": "Lipe Akomodasi", "order": 1},
        {"stopId": "s2", "name": "3号桥", "idName": "Jembatan", "order": 2},
        {"stopId": "s3", "name": "2号桥", "idName": "Jembatan 2", "order": 3},
        {
          "stopId": "s4",
          "name": "锂电池",
          "idName": "Mekanik Divisi Perbaikan",
          "order": 4,
        },
        {"stopId": "s5", "name": "电厂祷告室", "idName": "Smelter A", "order": 5},
        {"stopId": "s6", "name": "1号换电站", "idName": "Smelter B", "order": 6},
        {"stopId": "s7", "name": "机修车间", "idName": "Travo 2", "order": 7},
        {"stopId": "s3", "name": "2号桥", "idName": "Jembatan 2", "order": 8},
        {"stopId": "s2", "name": "3号桥", "idName": "Jembatan 3", "order": 9},
        {"stopId": "s1", "name": "李白", "idName": "Lipe Akomodasi", "order": 10},
      ],
      "directions": [
        {
          "directionId": "0",
          "name": "4A车",
          "trips": [
            {
              "tripId": "trip_103_1",
              "departureTime": "05:45",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_2",
              "departureTime": "06:15",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_3",
              "departureTime": "06:45",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_4",
              "departureTime": "07:15",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_5",
              "departureTime": "07:45",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_6",
              "departureTime": "08:15",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_7",
              "departureTime": "09:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_8",
              "departureTime": "11:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_9",
              "departureTime": "12:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_10",
              "departureTime": "14:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_11",
              "departureTime": "16:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_12",
              "departureTime": "17:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_13",
              "departureTime": "18:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_14",
              "departureTime": "19:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_15",
              "departureTime": "19:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_103_16",
              "departureTime": "20:40",
              "arrivalTime": "",
            },
          ],
        },
        {
          "directionId": "0",
          "name": "4B车",
          "trips": [
            {
              "tripId": "trip_104_1",
              "departureTime": "05:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_2",
              "departureTime": "06:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_3",
              "departureTime": "06:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_4",
              "departureTime": "07:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_102_5",
              "departureTime": "07:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_6",
              "departureTime": "08:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_7",
              "departureTime": "10:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_8",
              "departureTime": "11:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_9",
              "departureTime": "12:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_10",
              "departureTime": "14:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_11",
              "departureTime": "16:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_12",
              "departureTime": "17:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_13",
              "departureTime": "18:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_14",
              "departureTime": "19:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_15",
              "departureTime": "20:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_16",
              "departureTime": "20:50",
              "arrivalTime": "",
            },
          ],
        },
        {
          "directionId": "0",
          "name": "4C车",
          "trips": [
            {
              "tripId": "trip_104_1",
              "departureTime": "05:55",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_2",
              "departureTime": "06:25",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_3",
              "departureTime": "06:55",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_4",
              "departureTime": "07:25",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_5",
              "departureTime": "07:55",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_6",
              "departureTime": "08:25",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_7",
              "departureTime": "10:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_8",
              "departureTime": "11:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_9",
              "departureTime": "13:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_10",
              "departureTime": "15:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_11",
              "departureTime": "16:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_12",
              "departureTime": "17:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_13",
              "departureTime": "18:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_14",
              "departureTime": "19:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_15",
              "departureTime": "20:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_16",
              "departureTime": "21:00",
              "arrivalTime": "",
            },
          ],
        },

        {
          "directionId": "0",
          "name": "4D车",
          "trips": [
            {
              "tripId": "trip_104_1",
              "departureTime": "06:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_2",
              "departureTime": "06:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_3",
              "departureTime": "07:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_4",
              "departureTime": "07:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_5",
              "departureTime": "08:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_6",
              "departureTime": "08:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_7",
              "departureTime": "11:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_8",
              "departureTime": "12:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_9",
              "departureTime": "13:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_10",
              "departureTime": "15:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_11",
              "departureTime": "17:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_12",
              "departureTime": "17:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_13",
              "departureTime": "18:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_14",
              "departureTime": "19:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_15",
              "departureTime": "20:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_16",
              "departureTime": "21:10",
              "arrivalTime": "",
            },
          ],
        },

        {
          "directionId": "0",
          "name": "4E车",
          "trips": [
            {
              "tripId": "trip_104_1",
              "departureTime": "06:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_2",
              "departureTime": "06:35",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_3",
              "departureTime": "07:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_4",
              "departureTime": "07:35",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_5",
              "departureTime": "08:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_6",
              "departureTime": "09:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_7",
              "departureTime": "11:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_8",
              "departureTime": "12:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_9",
              "departureTime": "13:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_10",
              "departureTime": "16:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_11",
              "departureTime": "17:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_12",
              "departureTime": "18:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_13",
              "departureTime": "18:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_14",
              "departureTime": "19:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_15",
              "departureTime": "20:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_104_16",
              "departureTime": "21:20",
              "arrivalTime": "",
            },
          ],
        },
      ],
    }),
    BusTimetable.fromJson({
      "routeId": "105",
      "name": "5路",
      "stops": [
        {"stopId": "s1", "name": "W生活区", "idName": "Akomodasi W", "order": 1},
        {"stopId": "s2", "name": "镍铁RS区", "idName": "Smelter RS", "order": 2},
      ],
      "directions": [
        {
          "directionId": "0",
          "name": "W生活区-镍铁RS区",
          "trips": [
            {
              "tripId": "trip_105_1",
              "departureTime": "05:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_2",
              "departureTime": "06:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_3",
              "departureTime": "06:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_4",
              "departureTime": "06:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_5",
              "departureTime": "07:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_6",
              "departureTime": "07:25",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_7",
              "departureTime": "8:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_8",
              "departureTime": "09:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_9",
              "departureTime": "10:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_10",
              "departureTime": "11:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_11",
              "departureTime": "12:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_12",
              "departureTime": "13:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_13",
              "departureTime": "14:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_14",
              "departureTime": "15:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_15",
              "departureTime": "16:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_16",
              "departureTime": "16:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_17",
              "departureTime": "17:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_18",
              "departureTime": "17:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_19",
              "departureTime": "18:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_20",
              "departureTime": "18:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_21",
              "departureTime": "18:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_22",
              "departureTime": "19:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_23",
              "departureTime": "19:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_24",
              "departureTime": "19:50",
              "arrivalTime": "",
            },
          ],
        },
        {
          "directionId": "1",
          "name": "镍铁RS区-W生活区",
          "trips": [
            {
              "tripId": "trip_105_1",
              "departureTime": "06:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_2",
              "departureTime": "06:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_3",
              "departureTime": "06:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_4",
              "departureTime": "07:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_5",
              "departureTime": "07:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_6",
              "departureTime": "07:45",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_7",
              "departureTime": "8:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_8",
              "departureTime": "09:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_9",
              "departureTime": "10:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_10",
              "departureTime": "11:35",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_11",
              "departureTime": "13:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_12",
              "departureTime": "13:35",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_13",
              "departureTime": "14:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_14",
              "departureTime": "15:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_15",
              "departureTime": "17:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_16",
              "departureTime": "17:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_17",
              "departureTime": "17:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_18",
              "departureTime": "18:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_19",
              "departureTime": "18:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_20",
              "departureTime": "18:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_21",
              "departureTime": "19:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_22",
              "departureTime": "19:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_23",
              "departureTime": "20:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_105_24",
              "departureTime": "20:30",
              "arrivalTime": "",
            },
          ],
        },
      ],
    }),
    BusTimetable.fromJson({
      "routeId": "106",
      "name": "6路",
      "stops": [
        {"stopId": "s1", "name": "H生活区", "idName": "Akomodasi H", "order": 1},
        {"stopId": "s2", "name": "镍铁M/O区", "idName": "Smelter M/O", "order": 2},
        {"stopId": "s3", "name": "镍铁A区", "idName": "Smelter A", "order": 3},
        {"stopId": "s4", "name": "镍铁H区", "idName": "Smelter H", "order": 4},
        {"stopId": "s5", "name": "H生活区", "idName": "Akomodasi H", "order": 5},
      ],
      "directions": [
        {
          "directionId": "0",
          "name": "6A车",
          "trips": [
            {
              "tripId": "trip_106_1",
              "departureTime": "05:55",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_2",
              "departureTime": "06:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_3",
              "departureTime": "06:45",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_4",
              "departureTime": "07:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_5",
              "departureTime": "07:35",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_6",
              "departureTime": "08:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_101_7",
              "departureTime": "10:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_8",
              "departureTime": "12:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_9",
              "departureTime": "14:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_10",
              "departureTime": "16:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_11",
              "departureTime": "17:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_12",
              "departureTime": "17:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_13",
              "departureTime": "18:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_14",
              "departureTime": "19:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_15",
              "departureTime": "20:00",
              "arrivalTime": "",
            },
          ],
        },
        {
          "directionId": "0",
          "name": "6B车",
          "trips": [
            {
              "tripId": "trip_106_1",
              "departureTime": "06:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_2",
              "departureTime": "06:25",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_3",
              "departureTime": "06:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_4",
              "departureTime": "07:15",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_5",
              "departureTime": "07:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_6",
              "departureTime": "08:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_7",
              "departureTime": "10:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_8",
              "departureTime": "13:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_9",
              "departureTime": "14:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_10",
              "departureTime": "16:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_11",
              "departureTime": "17:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_12",
              "departureTime": "18:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_13",
              "departureTime": "18:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_14",
              "departureTime": "19:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_15",
              "departureTime": "20:20",
              "arrivalTime": "",
            },
          ],
        },
        {
          "directionId": "0",
          "name": "6C车",
          "trips": [
            {
              "tripId": "trip_106_1",
              "departureTime": "06:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_2",
              "departureTime": "06:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_3",
              "departureTime": "06:55",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_4",
              "departureTime": "07:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_5",
              "departureTime": "07:45",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_6",
              "departureTime": "09:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_7",
              "departureTime": "11:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_8",
              "departureTime": "13:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_9",
              "departureTime": "15:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_10",
              "departureTime": "16:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_11",
              "departureTime": "17:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_12",
              "departureTime": "18:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_13",
              "departureTime": "18:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_14",
              "departureTime": "19:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_15",
              "departureTime": "20:40",
              "arrivalTime": "",
            },
          ],
        },
        {
          "directionId": "0",
          "name": "6D车",
          "trips": [
            {
              "tripId": "trip_106_1",
              "departureTime": "06:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_2",
              "departureTime": "06:35",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_3",
              "departureTime": "07:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_4",
              "departureTime": "07:25",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_5",
              "departureTime": "07:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_6",
              "departureTime": "09:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_7",
              "departureTime": "11:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_8",
              "departureTime": "13:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_9",
              "departureTime": "15:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_10",
              "departureTime": "17:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_11",
              "departureTime": "17:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_12",
              "departureTime": "18:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_13",
              "departureTime": "19:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_14",
              "departureTime": "19:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_106_15",
              "departureTime": "21:00",
              "arrivalTime": "",
            },
          ],
        },
      ],
    }),
    BusTimetable.fromJson({
      "routeId": "107",
      "name": "7路",
      "stops": [
        {"stopId": "s1", "name": "H生活区", "idName": "Akomodasi H", "order": 1},
        {"stopId": "s2", "name": "镍铁M/O区", "idName": "Smelter M/O", "order": 2},
        {"stopId": "s3", "name": "镍铁R/S区", "idName": "Smelter R/S", "order": 3},
      ],
      "directions": [
        {
          "directionId": "0",
          "name": "H生活区-镍铁RS区",
          "trips": [
            {
              "tripId": "trip_107_1",
              "departureTime": "06:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_2",
              "departureTime": "06:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_3",
              "departureTime": "06:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_4",
              "departureTime": "06:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_5",
              "departureTime": "06:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_6",
              "departureTime": "07:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_7",
              "departureTime": "07:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_8",
              "departureTime": "07:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_9",
              "departureTime": "07:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_10",
              "departureTime": "08:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_11",
              "departureTime": "09:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_12",
              "departureTime": "10:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_13",
              "departureTime": "11:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_14",
              "departureTime": "11:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_15",
              "departureTime": "11:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_16",
              "departureTime": "12:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_17",
              "departureTime": "13:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_18",
              "departureTime": "13:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_19",
              "departureTime": "14:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_20",
              "departureTime": "15:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_21",
              "departureTime": "15:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_22",
              "departureTime": "16:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_23",
              "departureTime": "16:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_24",
              "departureTime": "16:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_25",
              "departureTime": "17:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_26",
              "departureTime": "17:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_27",
              "departureTime": "17:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_28",
              "departureTime": "18:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_29",
              "departureTime": "18:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_30",
              "departureTime": "18:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_31",
              "departureTime": "18:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_32",
              "departureTime": "18:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_33",
              "departureTime": "19:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_34",
              "departureTime": "19:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_35",
              "departureTime": "19:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_36",
              "departureTime": "20:10",
              "arrivalTime": "",
            },
          ],
        },
        {
          "directionId": "1",
          "name": "镍铁RS区-W生活区",
          "trips": [
            {
              "tripId": "trip_107_1",
              "departureTime": "06:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_2",
              "departureTime": "06:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_3",
              "departureTime": "06:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_4",
              "departureTime": "07:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_5",
              "departureTime": "07:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_6",
              "departureTime": "07:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_7",
              "departureTime": "07:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_8",
              "departureTime": "07:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_9",
              "departureTime": "08:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_10",
              "departureTime": "08:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_11",
              "departureTime": "09:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_12",
              "departureTime": "10:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_13",
              "departureTime": "11:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_14",
              "departureTime": "11:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_15",
              "departureTime": "12:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_16",
              "departureTime": "13:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_17",
              "departureTime": "13:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_18",
              "departureTime": "13:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_19",
              "departureTime": "14:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_20",
              "departureTime": "15:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_21",
              "departureTime": "16:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_22",
              "departureTime": "16:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_23",
              "departureTime": "17:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_24",
              "departureTime": "17:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_25",
              "departureTime": "17:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_26",
              "departureTime": "17:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_27",
              "departureTime": "18:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_28",
              "departureTime": "18:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_29",
              "departureTime": "18:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_30",
              "departureTime": "18:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_31",
              "departureTime": "19:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_32",
              "departureTime": "19:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_33",
              "departureTime": "19:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_34",
              "departureTime": "20:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_35",
              "departureTime": "20:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_36",
              "departureTime": "20:40",
              "arrivalTime": "",
            },
          ],
        },
      ],
    }),
    BusTimetable.fromJson({
      "routeId": "108",
      "name": "8路",
      "stops": [
        {"stopId": "s1", "name": "W生活区", "idName": "Akomodasi W", "order": 1},
        {"stopId": "s2", "name": "吊装车间", "idName": "", "order": 2},
        {"stopId": "s3", "name": "瑞浦兰钧", "idName": "RBI", "order": 3},
        {
          "stopId": "s4",
          "name": "高旺地搅拌站",
          "idName": "MIXING PLAN GOMDI",
          "order": 4,
        },
      ],
      "directions": [
        {
          "directionId": "0",
          "name": "W生活区-高旺地搅拌站",
          "trips": [
            {
              "tripId": "trip_108_1",
              "departureTime": "06:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_108_2",
              "departureTime": "07:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_108_3",
              "departureTime": "08:25",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_108_4",
              "departureTime": "09:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_5",
              "departureTime": "11:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_6",
              "departureTime": "11:45",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_7",
              "departureTime": "13:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_8",
              "departureTime": "14:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_9",
              "departureTime": "16:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_10",
              "departureTime": "17:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_11",
              "departureTime": "18:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_12",
              "departureTime": "19:30",
              "arrivalTime": "",
            },
          ],
        },
        {
          "directionId": "1",
          "name": "高旺地搅拌站-W生活区",
          "trips": [
            {
              "tripId": "trip_108_1",
              "departureTime": "07:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_108_2",
              "departureTime": "08:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_108_3",
              "departureTime": "08:45",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_108_4",
              "departureTime": "10:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_108_5",
              "departureTime": "11:25",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_108_6",
              "departureTime": "12:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_108_7",
              "departureTime": "14:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_108_8",
              "departureTime": "15:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_108_9",
              "departureTime": "17:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_108_10",
              "departureTime": "18:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_108_11",
              "departureTime": "19:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_108_12",
              "departureTime": "20:05",
              "arrivalTime": "",
            },
          ],
        },
      ],
    }),
    BusTimetable.fromJson({
      "routeId": "110",
      "name": "10路",
      "stops": [
        {"stopId": "s1", "name": "李白", "idName": "Lipe Akomodasi", "order": 1},
        {"stopId": "s2", "name": "锂电池", "idName": "Litium", "order": 2},
        {
          "stopId": "s3",
          "name": "蓝天码头",
          "idName": "Jeti Langit Biru",
          "order": 3,
        },
        {"stopId": "s4", "name": "4号桥", "idName": "Jembatan 4", "order": 4},
      ],
      "directions": [
        {
          "directionId": "0",
          "name": "李白-4号桥",
          "trips": [
            {
              "tripId": "trip_110_1",
              "departureTime": "06:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_110_2",
              "departureTime": "06:35",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_110_3",
              "departureTime": "07:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_110_4",
              "departureTime": "07:35",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_5",
              "departureTime": "08:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_6",
              "departureTime": "16:35",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_7",
              "departureTime": "17:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_8",
              "departureTime": "17:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_9",
              "departureTime": "18:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_10",
              "departureTime": "18:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_11",
              "departureTime": "19:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_12",
              "departureTime": "19:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_13",
              "departureTime": "20:20",
              "arrivalTime": "",
            },
          ],
        },
        {
          "directionId": "1",
          "name": "4号桥-李白",
          "trips": [
            {
              "tripId": "trip_110_1",
              "departureTime": "06:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_110_2",
              "departureTime": "07:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_110_3",
              "departureTime": "07:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_110_4",
              "departureTime": "07:50",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_5",
              "departureTime": "08:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_6",
              "departureTime": "17:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_7",
              "departureTime": "17:35",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_8",
              "departureTime": "18:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_9",
              "departureTime": "18:35",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_10",
              "departureTime": "19:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_11",
              "departureTime": "19:35",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_12",
              "departureTime": "20:05",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_13",
              "departureTime": "20:35",
              "arrivalTime": "",
            },
          ],
        },
      ],
    }),
    BusTimetable.fromJson({
      "routeId": "112",
      "name": "12路",
      "stops": [
        {"stopId": "s1", "name": "李白", "idName": "LIPE", "order": 1},
        {"stopId": "s2", "name": "丹江坞", "idName": "Tanjung Ullie", "order": 2},
        {"stopId": "s3", "name": "路易生活区", "idName": "Asrama Luyi", "order": 3},
      ],
      "directions": [
        {
          "directionId": "0",
          "name": "李白-路易生活区",
          "trips": [
            {
              "tripId": "trip_112_1",
              "departureTime": "05:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_112_2",
              "departureTime": "5:45",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_112_3",
              "departureTime": "9:45",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_112_4",
              "departureTime": "10:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_112_5",
              "departureTime": "13:45",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_112_6",
              "departureTime": "14:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_112_7",
              "departureTime": "17:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_112_8",
              "departureTime": "17:45",
              "arrivalTime": "",
            },
          ],
        },
        {
          "directionId": "1",
          "name": "路易生活区-李白",
          "trips": [
            {
              "tripId": "trip_112_1",
              "departureTime": "07:55",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_112_2",
              "departureTime": "8:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_112_3",
              "departureTime": "11:45",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_112_4",
              "departureTime": "12:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_112_5",
              "departureTime": "15:45",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_112_6",
              "departureTime": "16:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_112_7",
              "departureTime": "19:55",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_112_8",
              "departureTime": "20:10",
              "arrivalTime": "",
            },
          ],
        },
      ],
    }),
    BusTimetable.fromJson({
      "routeId": "113",
      "name": "丹江坞-李白",
      "stops": [
        {"stopId": "s1", "name": "丹江坞", "idName": "Tanjung Ullie", "order": 1},
        {"stopId": "s2", "name": "李白", "idName": "LIPE", "order": 2},
      ],
      "directions": [
        {
          "directionId": "0",
          "name": "丹江坞-李白",
          "trips": [
            {
              "tripId": "trip_114_1",
              "departureTime": "17:20",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_114_2",
              "departureTime": "18:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_110_3",
              "departureTime": "19:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_114_3",
              "departureTime": "20:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_5",
              "departureTime": "21:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_6",
              "departureTime": "22:10",
              "arrivalTime": "",
            },
          ],
        },

        {
          "directionId": "1",
          "name": "李白-丹江坞",
          "trips": [
            {
              "tripId": "trip_114_1",
              "departureTime": "17:45",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_114_2",
              "departureTime": "18:35",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_110_3",
              "departureTime": "19:35",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_114_3",
              "departureTime": "20:35",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_107_5",
              "departureTime": "21:35",
              "arrivalTime": "",
            },
          ],
        },
      ],
    }),
    BusTimetable.fromJson({
      "routeId": "110",
      "name": "H生活区-丹江坞",
      "stops": [
        {"stopId": "s1", "name": "H生活区", "idName": "Asrama H", "order": 1},
        {"stopId": "s2", "name": "丹江坞", "idName": "Tanjung Ullie", "order": 2},
      ],
      "directions": [
        {
          "directionId": "0",
          "name": "H生活区-丹江坞",
          "trips": [
            {
              "tripId": "trip_114_1",
              "departureTime": "18:00",
              "arrivalTime": "",
            },
          ],
        },

        {
          "directionId": "1",
          "name": "丹江坞-H生活区",
          "trips": [
            {
              "tripId": "trip_114_1",
              "departureTime": "21:30",
              "arrivalTime": "",
            },
          ],
        },
      ],
    }),
    BusTimetable.fromJson({
      "routeId": "110",
      "name": "W生活区—丹江坞",
      "stops": [
        {"stopId": "s1", "name": "W生活区", "idName": "Asrama W", "order": 1},
        {"stopId": "s2", "name": "丹江坞", "idName": "Tanjung Ullie", "order": 2},
      ],
      "directions": [
        {
          "directionId": "0",
          "name": "W生活区—丹江坞",
          "trips": [
            {
              "tripId": "trip_114_1",
              "departureTime": "09:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_114_2",
              "departureTime": "14:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_114_3",
              "departureTime": "17:10",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_114_4",
              "departureTime": "18:10",
              "arrivalTime": "",
            },
          ],
        },

        {
          "directionId": "1",
          "name": "丹江坞-W生活区",
          "trips": [
            {
              "tripId": "trip_114_1",
              "departureTime": "11:30",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_114_2",
              "departureTime": "16:00",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_114_3",
              "departureTime": "17:40",
              "arrivalTime": "",
            },
            {
              "tripId": "trip_114_4",
              "departureTime": "21:30",
              "arrivalTime": "",
            },
          ],
        },
      ],
    }),
  ];

  // 当前选择的路线索引
  int _selectedRouteIndex = 0;

  // 当前选择的方向索引
  int _selectedDirectionIndex = 0;

  // Tab控制器
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();

    // 初始化tab控制器
    _tabController = TabController(
      length: _busTimetableList[_selectedRouteIndex].directions?.length ?? 0,
      vsync: this,
    );

    _tabController.addListener(() {
      setState(() {
        _selectedDirectionIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // 模拟刷新数据
  Future<void> _loadTimetableData() async {
    // 实际应用中应该从API获取数据
    await Future.delayed(Duration(seconds: 1));

    // 模拟刷新后的数据
    setState(() {
      // 这里只是刷新现有数据，实际应用中应该更新数据
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(S.current.busTimetable),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 路线选择卡片
          _buildRouteSelectionCard(),

          // 方向选择Tabs
          _buildDirectionTabs(),

          // 时刻表内容
          Expanded(
            child: SmartRefreshWidget(
              enablePullDown: true,
              enablePullUp: false,
              onRefresh: () async {
                await _loadTimetableData();
                _refreshController.refreshCompleted();
              },
              controller: _refreshController,
              child: _buildTimetableContent(),
            ),
          ),
        ],
      ),
    );
  }

  // 构建路线选择卡片
  Widget _buildRouteSelectionCard() {
    return Container(
      margin: EdgeInsets.all(10.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(5.px),
            child: Text(
              S.current.chooseRoute,
              style: TextStyle(fontSize: 12.px, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.px, vertical: 5.px),
            width: double.infinity,
            child: Wrap(
              spacing: 5.px, // 主轴间距（水平间距）
              runSpacing: 5.px, // 纵轴间距（垂直间距）
              children: List.generate(_busTimetableList.length, (index) {
                final route = _busTimetableList[index];
                final isSelected = _selectedRouteIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRouteIndex = index;
                      _selectedDirectionIndex = 0;

                      // 更新 TabController
                      _tabController.dispose();
                      _tabController = TabController(
                        length: route.directions?.length ?? 0,
                        vsync: this,
                      );
                      _tabController.addListener(() {
                        setState(() {
                          _selectedDirectionIndex = _tabController.index;
                        });
                      });
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.px,
                      vertical: 6.px,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : Colors.grey[200],
                      borderRadius: BorderRadius.circular(5.px),
                    ),
                    child: Text(
                      route.name ?? '',
                      style: TextStyle(
                        fontSize: 12.px,
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 10.px),
        ],
      ),
    );
  }

  // 构建方向选择Tabs
  Widget _buildDirectionTabs() {
    if (_busTimetableList.isEmpty) {
      return SizedBox.shrink();
    }

    // 获取当前路线的方向列表
    List<Directions>? directions =
        _busTimetableList[_selectedRouteIndex].directions;
    if (directions == null || directions.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: primaryColor,
        tabs:
            directions.map((direction) {
              return Tab(text: direction.name ?? '');
            }).toList(),
      ),
    );
  }

  // 构建时刻表内容
  Widget _buildTimetableContent() {
    if (_busTimetableList.isEmpty) {
      return Center(child: EmptyView());
    }

    // 获取当前路线
    BusTimetable currentRoute = _busTimetableList[_selectedRouteIndex];

    // 获取当前方向
    List<Directions>? directions = currentRoute.directions;
    if (directions == null ||
        directions.isEmpty ||
        _selectedDirectionIndex >= directions.length) {
      return Center(child: EmptyView());
    }

    Directions currentDirection = directions[_selectedDirectionIndex];

    // 获取站点和班次
    List<Trips>? trips = currentDirection.trips;
    List<Stops>? stops = currentRoute.stops;

    if (stops == null || stops.isEmpty) {
      return Center(child: EmptyView());
    }

    if (trips == null || trips.isEmpty) {
      return Center(child: EmptyView());
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // 路线信息卡片
          _buildRouteInfoCard(currentRoute, currentDirection),

          // 班次列表
          _buildTripsList(currentRoute, currentDirection),
        ],
      ),
    );
  }

  // 构建路线信息卡片
  Widget _buildRouteInfoCard(BusTimetable route, Directions direction) {
    // 获取站点
    List<Stops>? stops = route.stops;
    if (stops == null || stops.isEmpty) {
      return SizedBox.shrink();
    }

    // 获取班次
    List<Trips>? trips = direction.trips;
    if (trips == null || trips.isEmpty) {
      return SizedBox.shrink();
    }

    // 获取第一个和最后一个站点
    Stops firstStop = direction.directionId == '0' ? stops.first : stops.last;
    Stops lastStop = direction.directionId == '0' ? stops.last : stops.first;

    // 获取第一班车和最后一班车时间
    String firstTripTime = trips.first.departureTime ?? '--:--';
    String lastTripTime = trips.last.departureTime ?? '--:--';

    return Container(
      margin: EdgeInsets.all(10.px),
      padding: EdgeInsets.all(10.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.directions_bus, color: primaryColor),
              SizedBox(width: 5.px),
              Text(
                '${route.name} - ${direction.name}',
                style: TextStyle(fontSize: 14.px, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 5.px),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.current.startStation,
                      style: TextStyle(fontSize: 12.px, color: Colors.grey),
                    ),
                    SizedBox(height: 5.px),
                    Text(
                      firstStop.name ?? '',
                      style: TextStyle(
                        fontSize: 14.px,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      firstStop.idName ?? '',
                      style: TextStyle(fontSize: 12.px, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, color: Colors.grey),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      S.current.endStation,
                      style: TextStyle(fontSize: 12.px, color: Colors.grey),
                    ),
                    SizedBox(height: 5.px),
                    Text(
                      lastStop.name ?? '',
                      style: TextStyle(
                        fontSize: 16.px,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      lastStop.idName ?? '',
                      style: TextStyle(fontSize: 12.px, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15.px),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimeInfo(S.current.firstTripTime, firstTripTime),
              _buildTimeInfo(S.current.lastTripTime, lastTripTime),
              _buildTimeInfo(S.current.stationNumber, '${stops.length}'),
              _buildTimeInfo(S.current.tripNumber, '${trips.length}'),
            ],
          ),
        ],
      ),
    );
  }

  // 构建时间信息
  Widget _buildTimeInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12.px, color: Colors.grey)),
        SizedBox(height: 5.px),
        Text(
          value,
          style: TextStyle(fontSize: 14.px, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // 构建班次列表
  Widget _buildTripsList(BusTimetable route, Directions direction) {
    List<Trips>? trips = direction.trips;
    List<Stops>? stops = route.stops;

    if (trips == null || trips.isEmpty || stops == null || stops.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(left: 10.px, right: 10.px, bottom: 10.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.px),
            child: Row(
              children: [
                Icon(Icons.schedule, color: primaryColor),
                SizedBox(width: 5.px),
                Text(
                  S.current.timetable,
                  style: TextStyle(
                    fontSize: 14.px,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // 当前日期
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.px),
            child: Text(
              '${S.current.busToday}: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
              style: TextStyle(fontSize: 14.px, color: Colors.grey),
            ),
          ),
          SizedBox(height: 10.px),
          // 班次时间网格
          _buildTimeGrid(trips),
          SizedBox(height: 15.px),
          // 站点列表
          _buildStopsList(stops),
        ],
      ),
    );
  }

  // 构建时间网格
  Widget _buildTimeGrid(List<Trips> trips) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.px),
      child: Wrap(
        spacing: 5.px,
        runSpacing: 5.px,
        children:
            trips.map((trip) {
              // 判断班次是否已过期
              bool isExpired = false;
              if (trip.departureTime != null) {
                List<String> timeParts = trip.departureTime!.split(':');
                if (timeParts.length == 2) {
                  DateTime now = DateTime.now();
                  DateTime tripTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    int.parse(timeParts[0]),
                    int.parse(timeParts[1]),
                  );
                  isExpired = now.isAfter(tripTime);
                }
              }

              return GestureDetector(
                onTap: () {
                  // 显示班次详情
                  // _showTripDetails(trip);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.px,
                    vertical: 3.px,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isExpired
                            ? Colors.grey[200]
                            : primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.px),
                    border: Border.all(
                      color: isExpired ? Colors.grey : primaryColor,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    trip.departureTime ?? '--:--',
                    style: TextStyle(
                      fontSize: 12.px,
                      color: isExpired ? Colors.grey : primaryColor,
                      fontWeight:
                          isExpired ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  // 显示班次详情
  // void _showTripDetails(Trips trip) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     isScrollControlled: true,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: 300.px,
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(20.px),
  //             topRight: Radius.circular(20.px),
  //           ),
  //         ),
  //         child: Column(
  //           children: [
  //             Container(
  //               height: 5.px,
  //               width: 40.px,
  //               margin: EdgeInsets.symmetric(vertical: 10.px),
  //               decoration: BoxDecoration(
  //                 color: Colors.grey[300],
  //                 borderRadius: BorderRadius.circular(2.5.px),
  //               ),
  //             ),
  //             Padding(
  //               padding: EdgeInsets.all(15.px),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     '班次详情',
  //                     style: TextStyle(
  //                       fontSize: 18.px,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   SizedBox(height: 20.px),
  //                   _buildDetailRow('班次ID', trip.tripId ?? '未知'),
  //                   SizedBox(height: 10.px),
  //                   _buildDetailRow('出发时间', trip.departureTime ?? '--:--'),
  //                   SizedBox(height: 10.px),
  //                   _buildDetailRow('到达时间', trip.arrivalTime ?? '--:--'),
  //                   SizedBox(height: 10.px),
  //                   _buildDetailRow('行程时间', _calculateTripDuration(trip)),
  //                   SizedBox(height: 20.px),
  //                   // 按钮操作区
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       ElevatedButton.icon(
  //                         onPressed: () {
  //                           Navigator.pop(context);
  //                           // 实际应用中可添加分享功能
  //                         },
  //                         icon: Icon(Icons.share),
  //                         label: Text('分享'),
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: primaryColor,
  //                           padding: EdgeInsets.symmetric(
  //                             horizontal: 20.px,
  //                             vertical: 10.px,
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(width: 20.px),
  //                       OutlinedButton.icon(
  //                         onPressed: () {
  //                           Navigator.pop(context);
  //                         },
  //                         icon: Icon(Icons.close),
  //                         label: Text('关闭'),
  //                         style: OutlinedButton.styleFrom(
  //                           padding: EdgeInsets.symmetric(
  //                             horizontal: 20.px,
  //                             vertical: 10.px,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // 计算行程时间
  // String _calculateTripDuration(Trips trip) {
  //   if (trip.departureTime == null ||
  //       trip.arrivalTime == null ||
  //       trip.arrivalTime!.isEmpty) {
  //     return '未知';
  //   }

  //   try {
  //     List<String> departureTimeParts = trip.departureTime!.split(':');
  //     List<String> arrivalTimeParts = trip.arrivalTime!.split(':');

  //     if (departureTimeParts.length != 2 || arrivalTimeParts.length != 2) {
  //       return '未知';
  //     }

  //     DateTime now = DateTime.now();
  //     DateTime departureTime = DateTime(
  //       now.year,
  //       now.month,
  //       now.day,
  //       int.parse(departureTimeParts[0]),
  //       int.parse(departureTimeParts[1]),
  //     );

  //     DateTime arrivalTime = DateTime(
  //       now.year,
  //       now.month,
  //       now.day,
  //       int.parse(arrivalTimeParts[0]),
  //       int.parse(arrivalTimeParts[1]),
  //     );

  //     // 如果到达时间在出发时间之前，说明跨天了
  //     if (arrivalTime.isBefore(departureTime)) {
  //       arrivalTime = arrivalTime.add(Duration(days: 1));
  //     }

  //     Duration difference = arrivalTime.difference(departureTime);
  //     int minutes = difference.inMinutes;

  //     if (minutes < 60) {
  //       return '$minutes分钟';
  //     } else {
  //       int hours = minutes ~/ 60;
  //       int remainingMinutes = minutes % 60;
  //       return '$hours小时$remainingMinutes分钟';
  //     }
  //   } catch (e) {
  //     return '未知';
  //   }
  // }

  // 构建详情行
  // Widget _buildDetailRow(String label, String value) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(label, style: TextStyle(fontSize: 14.px, color: Colors.grey)),
  //       Text(
  //         value,
  //         style: TextStyle(fontSize: 14.px, fontWeight: FontWeight.bold),
  //       ),
  //     ],
  //   );
  // }

  // 构建站点列表
  Widget _buildStopsList(List<Stops> stops) {
    return Container(
      padding: EdgeInsets.only(left: 15.px, right: 15.px, bottom: 10.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: primaryColor),
              SizedBox(width: 5.px),
              Text(
                S.current.stopList,
                style: TextStyle(fontSize: 14.px, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 10.px),
          // 站点时间线
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: stops.length,
            itemBuilder: (context, index) {
              final stop = stops[index];
              final isFirst = index == 0;
              final isLast = index == stops.length - 1;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 时间线
                  Container(
                    width: 30.px,
                    child: Column(
                      children: [
                        Container(
                          width: 14.px,
                          height: 14.px,
                          decoration: BoxDecoration(
                            color:
                                isFirst || isLast
                                    ? primaryColor
                                    : Colors.grey[300],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  isFirst || isLast
                                      ? primaryColor
                                      : Colors.grey,
                              width: 2,
                            ),
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 30.px,
                            color: Colors.grey[300],
                          ),
                      ],
                    ),
                  ),
                  // 站点信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stop.name ?? '',
                          style: TextStyle(
                            fontSize: 12.px,
                            fontWeight:
                                isFirst || isLast
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                        if (stop.idName != null && stop.idName!.isNotEmpty)
                          Text(
                            stop.idName!,
                            style: TextStyle(
                              fontSize: 12.px,
                              color: Colors.grey,
                            ),
                          ),
                        if (!isLast) SizedBox(height: 20.px),
                      ],
                    ),
                  ),
                  // 站点序号
                  Container(
                    width: 30.px,
                    alignment: Alignment.center,
                    child: Text(
                      '${stop.order ?? index + 1}',
                      style: TextStyle(fontSize: 12.px, color: Colors.grey),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
