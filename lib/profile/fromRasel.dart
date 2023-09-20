import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

AppBar getToolBar(Function function,
    {Function? function2,
    Widget? title,
    bool leading = true,
    bool IsWeb = false,
    bool rating = false,
    bool filter = false,
    bool isHome = false,
    bool done = false,
    bool noti = false}) {
  return AppBar(
    toolbarHeight: 65,
    title: isHome ? null : title,
    systemOverlayStyle: SystemUiOverlayStyle(
        //  systemNavigationBarColor: accentColor,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light),
    elevation: 0,
    centerTitle: true,
    leading: leading == true
        ? Center(
            child: IconButton(
              onPressed: () {
                function();
              },
              icon: Icon(Icons.arrow_back, size: 24, color: Colors.white),
            ),
          )
        : null,
    actions: [
      //   InkWell(
      //     onTap: (){
      //       function2!();
      //     },
      //     child: const Padding(
      //     padding: EdgeInsets.all(20.0),
      //     child: Center(child: Text('Submit'
      //     ,style: TextStyle(
      //         fontWeight: FontWeight.w500,
      //         fontSize: 17
      //       ),),
      //  ),
      // ),
      //   ),
      if (filter)
        InkWell(
          onTap: () async {
            function2!();
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.filter_list),
          ),
        ),
      if (done)
        Center(
          child: InkWell(
            onTap: () async {
              function2!();
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: getCustomFont('Done', 18.sp, Colors.white, 1,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      if (noti)
        InkWell(
            onTap: () {
              function2!();
            },
            child: Container(
              margin: EdgeInsets.only(right: 8),
              child: Icon(
                Icons.notification_important,
                color: Colors.white,
                size: 28,
              ),
            ))
    ],
  );
}

Widget getCustomFont(String text, double fontSize, Color fontColor, int maxLine,
    {TextOverflow overflow = TextOverflow.ellipsis,
    TextDecoration decoration = TextDecoration.none,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.start,
    txtHeight}) {
  return Text(
    text,
    overflow: overflow,
    style: TextStyle(
        decoration: decoration,
        fontSize: fontSize,
        fontStyle: FontStyle.normal,
        color: fontColor,
        height: txtHeight,
        fontWeight: fontWeight),
    maxLines: maxLine,
    softWrap: true,
    textAlign: textAlign,
  );
}
