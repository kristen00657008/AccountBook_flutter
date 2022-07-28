import 'package:account_book/extension/datetime_extension.dart';
import 'package:account_book/route/base_bloc.dart';
import 'package:account_book/route/page_name.dart';
import 'package:account_book/route/transition_enum.dart';
import 'package:account_book/ui/bloc/core/store_page_bloc.dart';
import 'package:account_book/ui/bloc/system/application_bloc.dart';
import 'package:account_book/ui/widget/appbars/store_page_appbar.dart';
import 'package:account_book/ui/widget/list_tile/navigation_list_tile_widget.dart';
import 'package:account_book/ui/widget/list_tile/text_edit_tile_widget.dart';
import 'package:account_book/ui/widget/my_divider_widget.dart';
import 'package:flutter/material.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  late StorePageBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<StorePageBloc>(context);
    bloc.initCurrentData();
    bloc.setView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          StorePageAppBar(bloc: bloc),
          Expanded(
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              children: [
                _buildDateTileWidget(),
                TextEditTileWidget(controller: bloc.textEditingController),
                _buildCategoryTile(),
                _buildAccountTypeTileWidget(),
                _buildMemberTileWidget(),
                _buildMemoTextEditWidget(),
                _buildBottomButton(),
              ],
            ),
          )
        ],
      )),
    );
  }

  Widget _buildDateTileWidget() {
    return Column(
      children: [
        ListTile(
          tileColor: Theme.of(context).colorScheme.tertiary,
          title: InkWell(
            onTap: () {},
            child: Center(
                child: Text(
              bloc.currentAmountData.date.formatToTW(),
              style: Theme.of(context).textTheme.bodyText1,
            )),
          ),
        ),
        MyDividerWidget(),
      ],
    );
  }

  Widget _buildCategoryTile() {
    return StreamBuilder<int>(
        initialData: 0,
        stream: bloc.categoryIndexStream,
        builder: (context, snapshot) {
          var index = snapshot.requireData;
          return NavigationListTileWidget(
            title: '類別',
            iconData: ApplicationBloc.getInstance()
                .amountCategoryList[index]
                .iconData,
            answer: ApplicationBloc.getInstance()
                .amountCategoryList[index]
                .categoryName,
            onTap: () {
              bloc.pushPage(PageName.ChooseCategoryPage, context,
                  transitionEnum: TransitionEnum.RightLeft,
                  blocQuery: {
                    BlocOptionKey.CurrentCategoryKey:
                        bloc.currentAmountData.categoryIndex,
                    BlocOptionKey.StorePageBlocKey: bloc
                  });
            },
          );
        });
  }

  Widget _buildAccountTypeTileWidget() {
    return NavigationListTileWidget(
      title: '帳戶',
      iconData: Icons.kayaking_sharp,
      answer: '現金',
      onTap: () {
        bloc.pushPage(PageName.ChooseCategoryPage, context,
            transitionEnum: TransitionEnum.RightLeft);
      },
    );
  }

  Widget _buildMemberTileWidget() {
    return NavigationListTileWidget(
      title: '成員',
      iconData: Icons.man_sharp,
      answer: '自己',
      onTap: () {
        bloc.pushPage(PageName.ChooseCategoryPage, context,
            transitionEnum: TransitionEnum.RightLeft);
      },
    );
  }

  Widget _buildMemoTextEditWidget() {
    return Container(
      height: MediaQuery.of(context).viewInsets.bottom == 0
          ? MediaQuery.of(context).size.height * 0.38
          : MediaQuery.of(context).size.height * 0.30,
      color: Theme.of(context).colorScheme.tertiary,
      margin: EdgeInsets.only(top: 35, bottom: 5),
      padding: EdgeInsets.all(10),
      child: TextField(
        scrollPadding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        keyboardType: TextInputType.multiline,
        style: Theme.of(context).textTheme.bodyText2,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '寫點備註吧...',
          hintStyle: Theme.of(context)
              .textTheme
              .bodyText2
              ?.copyWith(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Row(
      children: [
        Expanded(flex: 1, child: SizedBox.shrink()),
        Expanded(
          flex: 8,
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              "儲存",
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            style: ElevatedButton.styleFrom(
                side: BorderSide(
                  width: 1.0,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                primary: Theme.of(context).scaffoldBackgroundColor,
                visualDensity: VisualDensity(vertical: 1)),
          ),
        ),
        Expanded(flex: 1, child: SizedBox.shrink()),
        Expanded(
          flex: 8,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).secondaryHeaderColor,
                  visualDensity: VisualDensity(vertical: 1)),
              onPressed: () {},
              child: Text("再記一筆",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ))),
        ),
        Expanded(flex: 1, child: SizedBox.shrink()),
      ],
    );
  }
}
