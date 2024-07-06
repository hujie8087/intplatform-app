import 'package:flutter/material.dart';

class FilmMessageModel {
  FilmMessageModel({
    this.index = 0,
    this.title = '',
    this.content = '',
    this.replay = '',
    this.status = '',
    this.type = '',
    this.createTime = '',
    this.replayTime = '',
    this.animationController,
  });

  String title;
  String content;
  int index;
  String status;
  String type;
  String replay;
  String createTime;
  String replayTime;

  AnimationController? animationController;

  static List<FilmMessageModel> filmDataList = <FilmMessageModel>[
    FilmMessageModel(
        title: '仙剑奇侠传',
        content: '主演胡歌，刘亦菲',
        createTime: '2024-06-19 14:20',
        type: '1',
        status: '1',
        replay: '已添加',
        replayTime: '2024-06-20 16:20'),
    FilmMessageModel(
        title: 'APP视频播放有问题',
        content: '视频播放有问题',
        createTime: '2024-06-19 14:20',
        type: '2',
        status: '0',
        replay: '已修复',
        replayTime: '2024-06-20 16:20'),
    FilmMessageModel(
        title: '关于app被攻击的解释',
        content: '近期会影响大家的使用体验，对此向APP用户表示抱歉，我们一直致力于提供优质的服务体验，相信经历这次攻击，我们会做的更好！',
        createTime: '2024-06-19 14:20',
        type: '3',
        status: '0',
        replay: '',
        replayTime: ''),
  ];
}
