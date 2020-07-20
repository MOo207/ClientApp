import 'package:flutter/material.dart';

class Nfc extends StatefulWidget {
  @override
  _NfcState createState() => _NfcState();
}

class _NfcState extends State<Nfc> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("NFC"),
      ),
    );
  }
}