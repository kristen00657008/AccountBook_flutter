import 'package:flutter/material.dart';

import 'common_list_tile_widget.dart';

class TextEditTileWidget extends StatefulWidget {
  final TextEditingController controller;

  const TextEditTileWidget({Key? key, required this.controller}) : super(key: key);

  @override
  State<TextEditTileWidget> createState() => _TextEditTileWidgetState();
}

class _TextEditTileWidgetState extends State<TextEditTileWidget> {
  @override
  Widget build(BuildContext context) {
    return CommonListTileWidget(
      iconData: Icons.star,
      title: "金額",
      widgets: [
        Expanded(
          child: TextField(
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            autofocus: true,
            textAlign: TextAlign.right,
            controller: widget.controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hoverColor: Colors.white,
              focusColor: Colors.white,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              hintText: "金額輸入",
              hintStyle: TextStyle(
                color: Colors.white38,
                fontSize: 25,
              ),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        if(widget.controller.text.isNotEmpty)
          InkWell(
            onTap: () {
              setState(() {
                widget.controller.clear();
              });
            },
            child: Container(
              width: 25.0,
              height: 25.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white38,
              ),
              child: Icon(
                Icons.clear,
                color: Colors.black,
                size: 20,
              ),
            ),
          )
      ],

    );
  }
}
