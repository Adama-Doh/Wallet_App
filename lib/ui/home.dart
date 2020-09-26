import 'package:flutter/material.dart';
import 'package:wap/ui/wap_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WaP"),
        centerTitle: true,
        backgroundColor: Colors.black38,
      ),
      body: WapScreen()
    );
  }
}