import 'package:flutter/material.dart';

import 'template_node.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final node = TextNode();
    final attrs = Map<String, String>();
    attrs['text'] = 'Hello World';
    attrs['textSize'] = '16.0';
    attrs['width'] = '100.0';
    attrs['height'] = '100.0';
    attrs['backgroundColor'] = '0xFFFF0000';
    node.attrsMap = attrs;


    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: node.build()
    );
  }
}
