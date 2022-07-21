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
          backgroundColor: Colors.black,
          body: Column(
            children: [
              StorePageAppBar(bloc: bloc),
              Expanded(
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  children: [
                    _buildDateTileWidget(),
                    MyDividerWidget(),
                    TextEditTileWidget(controller: bloc.textEditingController),
                    _buildCategoryTile(),
                    _buildAccountTypeTileWidget(),
                    _buildMemberTileWidget(),
                    SizedBox(
                      height: 15,
                    ),
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
    return Container(
      color: Colors.white12,
      child: ListTile(
        title: InkWell(
          onTap: () {},
          child: Center(
              child: Text(
            bloc.currentAmountData.date.formatToTW(),
            style: TextStyle(fontSize: 25, color: Colors.white),
          )),
        ),
      ),
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
      color: Colors.white12,
      height: MediaQuery.of(context).size.height * 0.4,
      padding: EdgeInsets.all(10),
      child: TextField(
        scrollPadding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        keyboardType: TextInputType.multiline,
        style: TextStyle(
          fontSize: 20,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '寫點備註吧...',
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              "儲存",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            style: ElevatedButton.styleFrom(
                side: BorderSide(
                  width: 1.0,
                  color: Colors.orange,
                ),
                primary: Colors.black,
                visualDensity: VisualDensity(vertical: 1)),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  visualDensity: VisualDensity(vertical: 1)),
              onPressed: () {},
              child: Text("再記一筆",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ))),
        ),
      ],
    );
  }
}
