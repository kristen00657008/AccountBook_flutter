import 'package:account_book/main.dart';
import 'package:account_book/tools/colors.dart';
import 'package:account_book/ui/widget/common_app_bar_widget.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CommonAppBarWidget(
              title: Text("設定")
          ),
          Expanded(
              child: _buildListView()
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {

    return ListView.separated(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      itemCount: themeColors.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: (){
            MyApp.primaryColor.value = themeColors[index];
          },
          visualDensity: VisualDensity(vertical: -4),
          title: Text(themeColors[index].toString()),
        );
      },
    );
  }
}
