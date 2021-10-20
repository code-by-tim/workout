import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/model/sessionModel.dart';
import 'package:workout/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: ChangeNotifierProvider(
        create: (context) => SessionModel(),
        child: Home(),
      ),
    );
  }
}
