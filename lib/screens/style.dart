import 'package:flutter/material.dart';

  final Color backgroundColor1 = Color(0xFF444152);
  final Color backgroundColor2 = Color(0xFF6f6c7d);
  final Color highlightColor = Color(0xffe0a28f);
  final Color foregroundColor = Colors.white;
  final AssetImage logo = AssetImage('assets/images/logo-large.png');

Widget submitButton(String text,Function function) {
    return FlatButton(
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(30.0)
      //     ),
      color: highlightColor,
      onPressed: function,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 20.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: foregroundColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
    }