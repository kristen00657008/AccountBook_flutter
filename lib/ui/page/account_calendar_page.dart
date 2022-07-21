import 'package:account_book/extension/datetime_extension.dart';
import 'package:account_book/ui/bloc/core/account_book_page_bloc.dart';
import 'package:account_book/ui/bloc/system/application_bloc.dart';
import 'package:account_book/ui/model/amount_data.dart';
import 'package:account_book/ui/widget/date_title_widget.dart';
import 'package:account_book/ui/widget/my_divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:account_book/tools/colors.dart';
import 'package:account_book/ui/widget/list_tile/amount_list_tile_widget.dart';
import 'package:account_book/utils/calendar_utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:table_calendar/table_calendar.dart';

class AccountCalendarPage extends StatelessWidget {
  final AccountBookPageBloc bloc;
  const AccountCalendarPage({
    Key? key,
    required this.bloc
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
        stream: ApplicationBloc.getInstance().dateDataStream,
        // initialData: DateUtils.dateOnly(DateTime.now()),
        builder: (context, dateDataSnapshot) {
          if(!dateDataSnapshot.hasData) {
            return SizedBox.shrink();
          }
          var focusDay = dateDataSnapshot.requireData;
          return StreamBuilder<List<AmountData>>(
              stream: ApplicationBloc.getInstance().amountDataStream,
              initialData: [],
              builder: (context, snapshot) {
                var amountDataList = snapshot.requireData;
                bloc.focusDayExpenditure = 0;
                amountDataList.forEach((element) {
                  if (element.date.isEqualTo(focusDay)) {
                    bloc.focusDayExpenditure += element.amount;
                  }
                });
                return Column(children: [
                  _buildTableCalendar(amountDataList),
                  Expanded(child: _buildScrollView(amountDataList, focusDay)),
                  Container(
                    height: 10,
                    color: Colors.black,
                  )
                ]);
              });
        });
  }

  Widget _buildTableCalendar(List<AmountData> amountDataList) {
    return StreamBuilder<DateTime>(
        stream: ApplicationBloc.getInstance().dateDataStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox.shrink();
          }
          var focusDay = snapshot.requireData;
          return _tableCalendarWidget(amountDataList, focusDay);
        });
  }

  Widget _tableCalendarWidget([
    List<AmountData> amountDataList = const [],
    DateTime? focusDay,
  ]) {
    return TableCalendar(
      daysOfWeekHeight: 30,
      rowHeight: 45,
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: focusDay ?? kToday,
      calendarFormat: bloc.calendarFormat,
      currentDay: kToday,
      pageAnimationEnabled: true,
      pageJumpingEnabled: true,
      headerVisible: true,
      headerStyle: CalendarHeaderStyle(),
      calendarStyle: CalendarStyle(
        rangeHighlightColor: Colors.white12,
        isTodayHighlighted: false,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.grey),
        weekendStyle: TextStyle(color: Colors.grey),
        decoration: BoxDecoration(color: Colors.white12)
      ),
      calendarBuilders: CalendarBuilders(
        headerTitleBuilder: (context, day) {
          return DateTitleWidget(
            focusDay: focusDay ?? kToday,
            onConfirm: (date) {
              bloc.pickDay(date, focusDay ?? kToday);
            },
          );
        },
        selectedBuilder: (context, date, _) {
          return _buildSelectedCalendaritem(date, amountDataList);
        },
        outsideBuilder: (context, date, _) {
          return _buildOutSideCalendarItem(date);
        },
        defaultBuilder: (context, date, _) {
          return _buildDefaultCalendarItem(date, amountDataList);
        },
        holidayBuilder: (context, date, _) {
          return _buildHoliDayCalendarItem(date);
        },
      ),
      selectedDayPredicate: (day) => isSameDay(focusDay, day),
      onCalendarCreated: (controller) {
        bloc.calendarPageController = controller;
      },
      onPageChanged: (focusDay) {
        bloc.pageChanged(focusDay);
      },
      onDaySelected: (selectedDay, focusedDay) {
        bloc.daySelected(selectedDay);
      },
    );
  }

  Widget _buildSelectedCalendaritem(
      DateTime date, List<AmountData> amountDataList) {
    return Container(
      decoration: _defaultBoxDecoration(),
      child: Stack(
        children: [
          date.isEqualTo(DateUtils.dateOnly(DateTime.now()))
              ? Align(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4.8, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.all(Radius.elliptical(55, 60)),
              ),
              child: Text(
                "今天",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )
              : Center(
            child: CircleAvatar(
              child: Text(
                date.isEqualTo(DateUtils.dateOnly(DateTime.now()))
                    ? "今天"
                    : date.day.toString(),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              backgroundColor: Colors.orange,
              radius: 15,
            ),
          ),
          dateHasData(date, amountDataList) ? hasDataCircle() : Container()
        ],
      ),
    );
  }

  Widget _buildOutSideCalendarItem(DateTime date) {
    return Container(
      decoration: _defaultBoxDecoration(color: lightBlack),
      child: Center(
        child: Text(
          date.isEqualTo(DateUtils.dateOnly(DateTime.now())) ? "今天" : date.day.toString(),
          style: TextStyle(color: Colors.grey, fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildHoliDayCalendarItem(DateTime date) {
    return Container(
      decoration: _defaultBoxDecoration(),
      child: Center(
        child: Text(
          date.day.toString(),
          style: TextStyle(color: Colors.red, fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildDefaultCalendarItem(
      DateTime date, List<AmountData> amountDataList) {
    return Container(
      decoration: _defaultBoxDecoration(),
      child: Stack(
        children: [
          Center(
            child: Text(
              date.isEqualTo(DateUtils.dateOnly(DateTime.now())) ? "今天" : date.day.toString(),
              style: TextStyle(
                  color: dateHasData(date, amountDataList)
                      ? Colors.green
                      : Colors.white,
                  fontSize: 20),
            ),
          ),
          dateHasData(date, amountDataList) ? hasDataCircle() : Container()
        ],
      ),
    );
  }

  HeaderStyle CalendarHeaderStyle() {
    return HeaderStyle(
      decoration: BoxDecoration(color: Colors.white12,),
      headerPadding: EdgeInsets.zero,
      leftChevronIcon: Icon(
        Icons.chevron_left,
        color: Colors.white,
      ),
      rightChevronIcon: Icon(
        Icons.chevron_right,
        color: Colors.white,
      ),
      titleTextStyle: TextStyle(color: Colors.red),
      formatButtonVisible: false,
    );
  }

  Widget _buildHintText() {
    TextStyle hintTextStyle = TextStyle(
      color: Colors.grey,
      fontSize: 18,
    );

    return ListTile(
      visualDensity: VisualDensity(vertical: -4),
      leading: bloc.focusDayExpenditure > 0
          ? Text(
        "支出: ${bloc.focusDayExpenditure}",
        style: hintTextStyle,
      )
          : Text(
        "沒有紀錄。按「+」新增紀錄",
        style: hintTextStyle,
      ),
    );
  }

  Widget _buildScrollView(List<AmountData> amountDataList, DateTime focusDay) {
    List<AmountData> focusAmountDataList = [];
    amountDataList.forEach((element) {
      if (element.date.isEqualTo(focusDay)) {
        focusAmountDataList.add(element);
      }
    });

    return SlidableAutoCloseBehavior(
      child: ListView.separated(
          physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          itemCount: 1 + focusAmountDataList.length,
          // itemExtent: 50,
          separatorBuilder: (context, index) {
            return MyDividerWidget();
          },
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildHintText();
            } else {
              return AmountListTileWidget(
                  onCopyTap: () {
                    bloc.openStorePage(context, focusAmountDataList[index-1], true);
                  },
                  onEditTap: () {
                    bloc.openStorePage(context, focusAmountDataList[index-1], false);
                  },
                  amountData: focusAmountDataList[index - 1]);
            }
          }),
    );
  }

  BoxDecoration _defaultBoxDecoration({Color? color = Colors.white12}) {
    return BoxDecoration(
        color: color,
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.3),
          bottom: BorderSide(color: Colors.grey, width: 0.3),
        ));
  }

  Widget hasDataCircle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: CircleAvatar(
          radius: 2,
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }

  bool dateHasData(DateTime date, List<AmountData> amountDataList) {
    bool result = false;

    for (var amountData in amountDataList) {
      if (amountData.date.isEqualTo(date)) {
        result = true;
        break;
      }
    }

    return result;
  }
}
