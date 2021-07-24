import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key key,
    this.autoImplyLeading,
    this.text1,
    this.text2,
    this.bottom,
    this.extraAppBarHeight,
    this.actions,
  }) : super(key: key);

  final bool autoImplyLeading;
  final String text1;
  final String text2;
  final PreferredSizeWidget bottom;
  final int extraAppBarHeight;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: actions,
      backgroundColor: Colors.grey[200],
      automaticallyImplyLeading: autoImplyLeading,
      elevation: 0,
      title: Padding(
        padding: EdgeInsets.fromLTRB(5, 7, 0, 0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                text: text1,
                style: TextStyle(
                  color: Colors.orange[400],
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  letterSpacing: 1,
                ),
              ),
              TextSpan(
                text: text2,
                style: TextStyle(
                  color: Colors.grey[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  letterSpacing: 1,
                ),
              ),
            ]),
          ),
        ),
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + extraAppBarHeight);
}
