import 'package:flutter/material.dart';
import 'package:flutter_dsl_demo/template_node_parser.dart';
import 'package:xml/xml.dart';

import 'invoker.dart';
import 'template_function_sample.dart';
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
    final xmlForTest = '''
   <Flex
   paddingTop="40">
      <Image
        width="100"
        height="100"
        url="https://upload.jianshu.io/admin_banners/web_images/4989/7aee9b231d11e9ba92248e65e8f407343f87376e.png?imageMogr2/auto-orient/strip|imageView2/1/w/1250/h/540"
        positionType="absolute"
        positionLeft="0"
        positionRight="0">
       </Image>
      <Flex
        flexDirection="column"
        positionType="absolute"
        positionLeft="0"
        >
        <Text
          verticalGravity="center"
          textColor="#3D4E5C"
          textSize="28"
          text="作品推广"/>
   
        <Text
          verticalGravity="center"
          textColor="#FF0000"
          textSize="24"
          text="助力作品上热门"/>
       </Flex>
       
    </Flex>
''';

    final nodeParser = TemplateNodeParser();
    final nodeList = parse(xmlForTest).children;
    final myNodeList = nodeList.map((element) {
      if (element is XmlElement) {
        return nodeParser.parse(element);
      } else {
        return null;
      }
    }).toList();

    final newNode =
        myNodeList.firstWhere((element) => element != null) ?? EmptyNode();
    final widget = newNode.build();

    final invoker = DSLMethodInvoker();
    final functions = MyTemplateFunction();
    invoker.registerMethod("test", functions.testPrint);
    return Container(
      color: Colors.white,
      child: GestureDetector(
        child: widget,
        onTap: () {
          invoker.invoke('test',params: <String,String>{'content':'Hello Invoker'});
        },
      ),
    );
  }
}
