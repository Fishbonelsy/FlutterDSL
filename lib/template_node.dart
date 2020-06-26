import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class TemplateNode {
  NodeType nodeType;
  Map<String, String> attrsMap = Map<String, String>();
  List<TemplateNode> children;

  Widget internalBuild();

  String getAttr(String name) {
    return attrsMap[name];
  }

  bool hasContainer() {
    return getAttr('backgroundColor') != null ||
        getAttr('width') != null ||
        getAttr('height') != null ||
        getAttr('padding') != null ||
        getAttr('margin') != null;
  }

  double get width =>
      getAttr('width') != null ? double.parse(getAttr('width')) : null;

  double get height =>
      getAttr('height') != null ? double.parse(getAttr('height')) : null;

  Color get backgroundColor => getAttr('backgroundColor') != null
      ? Color(int.parse(getAttr('backgroundColor')))
      : Colors.white;

  Alignment get alignment =>
      getAttr('alignment') != null ? Alignment.center : Alignment.topLeft;

  Widget build() {
    Widget widget = hasContainer()
        ? Container(
            width: width,
            height: height,
            color: backgroundColor,
            child: internalBuild(),
          )
        : internalBuild();
    return widget;
  }
}

enum NodeType {
  Flex,
  Text,
  Image,
}

class Attr {
  String name;
  String value;
}

class TextNode extends TemplateNode {

  @override
  Widget internalBuild() {
    Widget child = Text(
      text,
      style: TextStyle(
        fontSize: textSize,
        color: color,
        decoration: TextDecoration.none,
      ),
    );
    return child;
  }

  String get text => getAttr('text') ?? '';

  double get textSize =>
      getAttr('textSize') != null ? double.parse(getAttr('textSize')) : 14.0;

  Color get color => getAttr('color') != null
      ? Color(int.parse(getAttr('color')))
      : Colors.black;
}