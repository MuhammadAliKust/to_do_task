import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

Widget card(String title, IconData iconData, VoidCallback _navigation,
    BuildContext context) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  var subHeadingTextStyle;
    return InkWell(
      onTap: () => _navigation(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 3,
            child: Container(
              height: (20 * height) / 100,
              width: (40 * width) / 100,
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        iconData,
                        color: Color(0xff201b6d),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 120,
                            child: Align(
                              alignment: Alignment.center,
                              child: AutoSizeText(
                                title,
                                textAlign: TextAlign.center,
                                maxFontSize: 16,
                                style: subHeadingTextStyle,
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          )),
    ),
  );
}
