import 'package:flutter/cupertino.dart';

class BottomNavigationData {

  final BottomNavigationEnum type;

  final IconData icon;

  final String title;

  final String url;

  const BottomNavigationData({
    required this.type,
    required this.title,
    required this.icon,
    required this.url,
  });
}

enum BottomNavigationEnum {
  /// 記帳本
  AccountBook,

  /// 帳戶
  Account,

  /// 記一筆
  Store,

  /// 圖表分析
  Analyze,

  /// 設定
  Setting,
}