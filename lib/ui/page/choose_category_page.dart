import 'package:account_book/route/base_bloc.dart';
import 'package:account_book/ui/bloc/choose_Category_page_bloc.dart';
import 'package:account_book/ui/bloc/system/application_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';

class ChooseCategoryPage extends StatefulWidget {
  ChooseCategoryPage({Key? key}) : super(key: key);

  @override
  ChooseCategoryPageState createState() => ChooseCategoryPageState();
}

class ChooseCategoryPageState extends State<ChooseCategoryPage> {
  late ChooseCategoryPageBloc bloc;
  // late StorePageBloc storePageBloc;
  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<ChooseCategoryPageBloc>(context);
    // storePageBloc = BlocProvider.of<StorePageBloc>(context);
    _generateImageData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        title: Text("類別"),
        centerTitle: true,
        backgroundColor: Colors.white10,
      ),
      backgroundColor: Colors.black,
      body: DraggableGridViewBuilder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.35,
        ),
        children: bloc.listOfDraggableGridItem,
        dragCompletion: onDragAccept,
        dragFeedback: feedback,
        dragPlaceHolder: placeHolder,
      ),
    );
  }

  void onDragAccept(
      List<DraggableGridItem> list, int beforeIndex, int afterIndex) {
    print('onDragAccept: $beforeIndex -> $afterIndex');
  }

  Widget feedback(List<DraggableGridItem> list, int index) {
    return Container(
      child: list[index].child,
      width: 110,
      height: 80,
    );
  }

  PlaceHolderWidget placeHolder(List<DraggableGridItem> list, int index) {
    return PlaceHolderWidget(
      child: Container(
        color: Colors.black,
      ),
    );
  }

  void _generateImageData() {
    ApplicationBloc.getInstance()
        .amountCategoryList
        .asMap()
        .forEach((index, amountCategory) {
      bloc.listOfDraggableGridItem.add(DraggableGridItem(
        child: StreamBuilder<int>(
          stream: bloc.chooseCategoryStream,
          initialData: 0,
          builder: (context, snapshot) {
            return Card(
                color: Colors.white10,
                shape: index == snapshot.requireData
                    ? RoundedRectangleBorder(
                        side: BorderSide(color: Colors.orange, width: 2),
                        borderRadius: BorderRadius.circular(8))
                    : null,
                child: InkWell(
                  onTap: (){
                    bloc.changeCategory(index);
                    Navigator.of(context).pop();
                  },
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                            padding: EdgeInsets.only(top: 12.0),
                            child:
                                Icon(amountCategory.iconData, color: Colors.orange)),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              amountCategory.categoryName,
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ))
                    ],
                  ),
                ));
          }
        ),
        isDraggable: true,
        dragCallback: (context, isDragging) {
          print('isDragging: $isDragging');
        },
      ));
    });
  }
}
