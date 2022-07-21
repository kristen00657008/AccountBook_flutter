import 'package:account_book/route/base_bloc.dart';
import 'package:account_book/route/page_bloc.dart';
import 'package:account_book/route/page_name.dart';
import 'package:account_book/ui/bloc/system/application_bloc.dart';
import 'package:account_book/ui/model/amount_data.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class StorePageBloc extends PageBloc {
  StorePageBloc(BlocOption blocOption) : super(blocOption);

  TextEditingController textEditingController = TextEditingController();

  // DateTime dataTime = ApplicationBloc.getInstance().focusDay;

  AmountData currentAmountData = AmountData(
      id: Uuid().v1(),
      amount: 0,
      type: AmountType.Expenditure,
      date: ApplicationBloc.getInstance().dateDataSubject.value,
      categoryIndex: 0,
      text: ""
  );


  Map<String, dynamic>? get currentAmountDataJson =>
      option.query[BlocOptionKey.StoringAmountDataKey];

  AmountCategory amountCategory = ApplicationBloc.getInstance().amountCategoryList.first;

  /// 類別流
  BehaviorSubject<int> categoryIndexSubject = BehaviorSubject.seeded(0);

  Stream<int> get categoryIndexStream => categoryIndexSubject.stream.asBroadcastStream();

  void initCurrentData() {
    var uuid = Uuid();
    if (currentAmountDataJson != null) {
      bool isCopy = currentAmountDataJson!['isCopy'];
      if (isCopy) {
        currentAmountDataJson?.removeWhere((key, value) => key == 'isCopy');
        currentAmountData = AmountData.fromJson(currentAmountDataJson!);
        currentAmountData.id = uuid.v1();
        currentAmountData.date = DateUtils.dateOnly(DateTime.now());
      } else {
        currentAmountDataJson?.removeWhere((key, value) => key == 'isCopy');
        currentAmountData = AmountData.fromJson(currentAmountDataJson!);
      }
      categoryIndexSubject.add(currentAmountData.categoryIndex);
    }
  }

  void setView() {
    if (currentAmountData.amount != 0) {
      textEditingController.text = currentAmountData.amount.toString();
    }
  }

  void save() {
    currentAmountData.amount = int.parse(textEditingController.text);
    ApplicationBloc.getInstance().saveAmount(currentAmountData);
  }
}
