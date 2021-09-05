import 'package:flutter/material.dart';
import 'package:workout/menus/homeMenu.dart';

enum WhyFarther { harder, smarter }

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Guten Abend Tim"),
        automaticallyImplyLeading: false,
        actions: [
          HomeMenu(),
        ],
      ),
    );
  }
}
