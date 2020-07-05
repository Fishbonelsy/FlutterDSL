import 'package:flutter/material.dart';
import 'package:flutter_dsl_demo/template_node_parser.dart';
import 'package:xml/xml.dart';

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
    final xmlForTest = '''<Flex>
    <Image
        height="32"
        width="32"
        url="https://static.yximgs.com/udata/pkg/kwai-client-image/feed_cover_tag_picture_normal.png"
        actualImageScaleType="centerCrop" />
 
    <Text
        height="40"
        verticalGravity="center"
        textColor="#ff8822"
        textSize="20"
        text="Hello, world!"/>
</Flex>''';

    final nodeParser = TemplateNodeParser();
    final nodeList = parse(xmlForTest).children;
    final myNodeList = nodeList.map((element) {
      return nodeParser.parse(element);
    }).toList();

    final newNode = myNodeList.first ?? EmptyNode();
    final widget = newNode.build();
    return Container(
        color: Colors.white, alignment: Alignment.center, child: widget);
  }
}
