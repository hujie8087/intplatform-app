import 'package:flutter/material.dart';

class FilmDataModel {
  FilmDataModel(
      {this.imagePath = '',
      this.index = 0,
      this.title = '',
      this.score = 0,
      this.animationController,
      this.list});

  String imagePath;
  String title;
  int score;
  int index;
  List<FilmDataModel>? list;

  AnimationController? animationController;

  static List<FilmDataModel> filmDataList = <FilmDataModel>[
    FilmDataModel(
        imagePath: 'assets/images/p2902984351.webp',
        index: 0,
        animationController: null,
        title: '电影',
        score: 0,
        list: [
          FilmDataModel(
            title: '临时劫案粤语',
            imagePath: 'assets/images/p2902984351.webp',
            index: 10,
            score: 10,
            animationController: null,
          ),
          FilmDataModel(
            title: '九龙城寨之围城',
            imagePath: 'assets/images/p2893592434.webp',
            index: 11,
            score: 2,
            animationController: null,
          ),
          FilmDataModel(
            title: '玫瑰的故事',
            imagePath: 'assets/images/mgdgs.jpg',
            index: 13,
            score: 10,
            animationController: null,
          )
        ]),
    FilmDataModel(
        imagePath: 'assets/images/mgdgs.jpg',
        index: 0,
        animationController: null,
        title: '电视剧',
        score: 0,
        list: [
          FilmDataModel(
            title: '玫瑰的故事',
            imagePath: 'assets/images/mgdgs.jpg',
            index: 10,
            score: 10,
            animationController: null,
          ),
          FilmDataModel(
            title: '第一序列',
            imagePath: 'assets/images/p2893592434.webp',
            index: 11,
            score: 2,
            animationController: null,
          ),
          FilmDataModel(
            title: '玫瑰的故事',
            imagePath: 'assets/images/mgdgs.jpg',
            index: 13,
            score: 10,
            animationController: null,
          )
        ]),
  ];

  static List<FilmDataModel> filmHotList = <FilmDataModel>[
    FilmDataModel(
      title: '玫瑰的故事',
      imagePath: 'assets/images/mgdgs.jpg',
      index: 13,
      score: 10,
      animationController: null,
    ),
    FilmDataModel(
      title: '临时劫案粤语',
      imagePath: 'assets/images/p2902984351.webp',
      index: 10,
      score: 10,
      animationController: null,
    ),
    FilmDataModel(
      title: '九龙城寨之围城',
      imagePath: 'assets/images/p2893592434.webp',
      index: 11,
      score: 2,
      animationController: null,
    ),
  ];
}
