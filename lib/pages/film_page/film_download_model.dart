import 'package:flutter/material.dart';

class FilmDownloadModel {
  FilmDownloadModel({
    this.imagePath = '',
    this.id = 0,
    this.title = '',
    this.status = 0,
    this.percentage = 0,
    this.size = 0,
    this.animationController,
  });
  

  String imagePath;
  String title;
  int status;
  int id;
  int percentage;
  int size;
  AnimationController? animationController;

  static List<FilmDownloadModel> filmDownList = <FilmDownloadModel>[
    FilmDownloadModel(
      animationController: null,
      imagePath: 'assets/images/p2902984351.webp',
      id: 0,
      title: '临时劫案粤语临时劫案粤语临时劫案粤语临时劫案粤语',
      status: 0,
      percentage: 100,
      size: 1234567,
    ),
    FilmDownloadModel(
      animationController: null,
      imagePath: 'assets/images/p2893592434.webp',
      id: 1,
      title: '九龙城寨之围城',
      status: 1,
      percentage: 100,
      size: 537153458,
    ),
    FilmDownloadModel(
      animationController: null,
      imagePath: 'assets/images/p2893592434.webp',
      id: 3,
      title: '九龙城寨之围城',
      status: 2,
      percentage: 50,
      size: 578964231,
    ),
  ];
}

