import 'package:account_book/ui/bloc/system/application_bloc.dart';
import 'package:account_book/ui/model/amount_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AmountListTileWidget extends StatelessWidget {
  final AmountData amountData;

  final VoidCallback onEditTap;

  final VoidCallback onCopyTap;

  AmountListTileWidget({
    Key? key,
    required this.amountData,
    required this.onEditTap,
    required this.onCopyTap,
  }) : super(key: key);

  TextStyle primaryStyle = TextStyle(
    color: Colors.white,
    fontSize: 20,
  );

  TextStyle secondaryStyle = TextStyle(
    color: Colors.grey,
    fontSize: 18,
  );

  AmountCategory get amountCategory => ApplicationBloc.getInstance().amountCategoryList[amountData.categoryIndex];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {onEditTap();},
      child: Slidable(
        key: UniqueKey(),
        groupTag: "todo",
        closeOnScroll: true,
        startActionPane: ActionPane(
          motion: ScrollMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              onPressed: (value) {
                onCopyTap();
              },
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              label: '拷貝',
            ),
          ],
        ),
        endActionPane: ActionPane(
          dragDismissible: true,
          dismissible: DismissiblePane(onDismissed: () {
            ApplicationBloc.getInstance().deleteAmountData(amountData);
          }),
          motion: ScrollMotion(),
          children: [
            CustomSlidableAction(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              onPressed: (BuildContext context) {
                onEditTap();
              },
              child: Text('編輯', style: TextStyle(fontSize: 16),),
            ),
            CustomSlidableAction(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              onPressed: (BuildContext context) {
                onCopyTap();
              },
              child: Text('拷貝', style: TextStyle(fontSize: 16)),
            ),
            CustomSlidableAction(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              autoClose: false,
              onPressed: (BuildContext context) {
                Slidable.of(context)!.dismiss(
                    ResizeRequest(Duration(milliseconds: 300), () {
                      ApplicationBloc.getInstance().deleteAmountData(amountData);
                    }),
                );
              },
              child: Text('刪除', style: TextStyle(fontSize: 16)),
            ),

          ],
        ),
        child: Container(
          color: Colors.white12,
          child: ListTile(
            leading: Icon(
              amountCategory.iconData,
              color: Colors.orange,
            ),
            minLeadingWidth: 0,
            title: Column(
              children: [
                Row(
                  children: [
                    Text(
                      amountCategory.categoryName,
                      style: primaryStyle,
                    ),
                    Spacer(),
                    Text(
                      "${amountData.amount}",
                      style: primaryStyle,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "自己",
                      style: secondaryStyle,
                    ),
                    Spacer(),
                    Text(
                      "現金",
                      style: secondaryStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
