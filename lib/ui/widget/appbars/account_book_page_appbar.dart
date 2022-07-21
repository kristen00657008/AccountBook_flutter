import 'package:account_book/route/base_bloc.dart';
import 'package:account_book/ui/bloc/core/account_book_page_bloc.dart';
import 'package:account_book/ui/bloc/system/application_bloc.dart';
import 'package:account_book/ui/widget/common_app_bar_widget.dart';
import 'package:account_book/utils/calendar_utils.dart';
import 'package:flutter/material.dart';

class AccountBookPageAppBar extends StatefulWidget {
  // final AccountBookPageBloc bloc;
  const AccountBookPageAppBar({
    Key? key,
    // required this.bloc
  }) : super(key: key);

  @override
  State<AccountBookPageAppBar> createState() => _AccountBookPageAppBarState();

}

class _AccountBookPageAppBarState extends State<AccountBookPageAppBar> {
  late AccountBookPageBloc bloc;
  List<bool> isSelected = [true, false];
  
  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<AccountBookPageBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return CommonAppBarWidget(
      title: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(flex: 1,child: IconButton(onPressed: () {
            print(kToday);
          }, icon: const Icon(Icons.bookmark_add_outlined))),
          Expanded(flex: 1,child: IconButton(onPressed: () {}, icon: const Icon(Icons.work_outline))),
          Center(
            child: SizedBox(
              height: 30,
              child: _topToggleButton(),
            ),
          ),
          Expanded(flex: 1,child: IconButton(onPressed: () {}, icon: const Icon(Icons.search))),
          Expanded(flex: 1,child: IconButton(onPressed: () {
            ApplicationBloc.getInstance().deleteAllData();
          }, icon: const Icon(Icons.pages))),
        ],
      ),
    );
  }

  Widget _topToggleButton() {
    return ToggleButtons(
      color: Colors.white,
      borderColor: Colors.white,
      fillColor: Colors.white,
      selectedColor: Colors.black,
      selectedBorderColor: Colors.white,
      borderRadius: BorderRadius.circular(10),
      borderWidth: 1,
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
              child: Text(
                "行事曆",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Center(
              child: Text(
                "清單",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ),
      ],
      onPressed: (int index) {
        int selectedIndex = isSelected.indexWhere((element) => element == true);
        setState(() {
          if(selectedIndex != index) {
            isSelected[selectedIndex] = false;
            isSelected[index] = true;
            bloc.pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 600),
                curve: Curves.fastOutSlowIn
            );
          }
        });
      },
      isSelected: isSelected,
    );
  }
}
