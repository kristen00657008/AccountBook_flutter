import 'package:account_book/route/base_bloc.dart';
import 'package:account_book/route/page_bloc.dart';
import 'package:account_book/route/page_name.dart';
import 'package:account_book/ui/bloc/core/store_page_bloc.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:rxdart/rxdart.dart';

class ChooseCategoryPageBloc extends PageBloc {
  ChooseCategoryPageBloc(BlocOption blocOption) : super(blocOption);

  List<DraggableGridItem> listOfDraggableGridItem = [];

  int get currentCategoryIndex =>
      option.query[BlocOptionKey.CurrentCategoryKey];

  StorePageBloc get storePageBloc => option.query[BlocOptionKey.StorePageBlocKey];

  int chooseCategoryIndex = 0;

  /// 紀錄當前選擇類別
  BehaviorSubject<int> _chooseCategorySubject = BehaviorSubject.seeded(0);

  Stream<int> get chooseCategoryStream => _chooseCategorySubject.stream;

  void changeCategory(int index) {
    chooseCategoryIndex = index;
    _chooseCategorySubject.add(chooseCategoryIndex);
    storePageBloc.currentAmountData.categoryIndex = chooseCategoryIndex;
    storePageBloc.categoryIndexSubject.add(index);
  }

}