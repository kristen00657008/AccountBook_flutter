import 'package:account_book/route/page_name.dart';
import 'package:account_book/route/route_data.dart';
import 'package:account_book/route/route_mixin.dart';
import 'package:account_book/ui/model/amount_data.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationBloc with RouteMixin {

  static final _singleton = ApplicationBloc._internal();

  static ApplicationBloc getInstance() => _singleton;

  factory ApplicationBloc() => _singleton;

  ApplicationBloc._internal() {
    addSubPageRoute(RouteData(PageName.AccountBookPage));
  }

  /// 子頁面歷史紀錄
  List<RouteData> _subPageHistory = [];

  String? get lastSubPage => _subPageSubject.value.routeName;

  /// 紀錄當前子頁面
  BehaviorSubject<RouteData> _subPageSubject = BehaviorSubject.seeded(RouteData(''));

  Stream<RouteData> get subPageStream => _subPageSubject.stream;

  /// 日期流
  BehaviorSubject<DateTime> dateDataSubject = BehaviorSubject.seeded(DateUtils.dateOnly(DateTime.now()));

  Stream<DateTime> get dateDataStream => dateDataSubject.stream.asBroadcastStream();

  /// 收支流
  BehaviorSubject<List<AmountData>> _amountDataSubject = BehaviorSubject.seeded([]);

  Stream<List<AmountData>> get amountDataStream => _amountDataSubject.stream.asBroadcastStream();

  List<AmountData> amountDataList = [];

  List<AmountCategory> amountCategoryList = [
    AmountCategory(iconData: Icons.ac_unit, categoryName: "午餐"),
    AmountCategory(iconData: Icons.book, categoryName: "學習"),
    AmountCategory(iconData: Icons.train, categoryName: "交通"),
    AmountCategory(iconData: Icons.shopping_bag, categoryName: "日常用品"),
    AmountCategory(iconData: Icons.water_drop, categoryName: "水電瓦斯"),
    AmountCategory(iconData: Icons.phone_android, categoryName: "電話網路"),
    AmountCategory(iconData: Icons.home, categoryName: "居家"),
    AmountCategory(iconData: Icons.shop, categoryName: "服飾"),
    AmountCategory(iconData: Icons.car_rental, categoryName: "汽車"),
  ];

  void setDate(DateTime date) {
    dateDataSubject.add(date);
  }

  void saveAmount(AmountData amountData) {
    bool isNotExist = amountDataList.where((element) => element.id == amountData.id).isEmpty;
    if(isNotExist){
      amountDataList.add(amountData);
    } else {
      int index = amountDataList.indexWhere((element) => element.id == amountData.id);
      amountDataList[index] = amountData;
    }
    _amountDataSubject.add(amountDataList);
    dateDataSubject.add(dateDataSubject.value);
    ApplicationBloc.getInstance().saveToSharedPreferences();
  }

  /// 加入歷史紀錄
  void addSubPageRoute(RouteData routeData) {
    /// 當前頁與routeData相同，則先移除當前頁歷史紀錄
    /// 避免又返回重複頁面
    if (lastSubPage == routeData.routeName && _subPageHistory.isNotEmpty) {
      _subPageHistory.removeLast();
    }

    _subPageHistory.add(routeData);
    _subPageSubject.add(routeData);
  }

  void popSubPage() {
    if(_subPageHistory.length>1) {
      _subPageHistory.removeLast();
    }

    if(!_subPageHistory.last.addHistory) {
      _subPageHistory.removeLast();
    }

    _subPageSubject.add(_subPageHistory.last);
  }

  /// 關閉
  void dispose() {
    _subPageSubject.close();
  }

  void saveToSharedPreferences() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String encodedData = AmountData.encode(amountDataList);

    await prefs.setString('amount_datas', encodedData);
  }

  void getSharedPreferences() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? amountDatasString = await prefs.getString('amount_datas');
    if(amountDatasString != null) {
      final List<AmountData> amountDatas = AmountData.decode(amountDatasString);
      amountDataList = amountDatas;
    }
    _amountDataSubject.add(amountDataList);
  }

  void deleteAmountData(AmountData amountData) {
    print("delete");
    amountDataList.removeWhere((element) => element.id == amountData.id);
    _amountDataSubject.add(amountDataList);
    dateDataSubject.add(dateDataSubject.value);
    saveToSharedPreferences();
  }

  void deleteAllData() {
    amountDataList = [];
    _amountDataSubject.add(amountDataList);
    saveToSharedPreferences();
  }

}