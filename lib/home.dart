import 'package:flutter/material.dart';

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
          PopupMenuButton(
            icon: Icon(Icons.menu),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: Text("Workout hinzufügen"),
                ),
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Einstellungen"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
