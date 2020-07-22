import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'invoker.dart';

abstract class TemplateNode {
  Map<String, String> attrsMap = Map<String, String>();
  List<TemplateNode> children;

  Widget internalBuild(DSLMethodInvoker invoker);

  String getAttr(String name) {
    return attrsMap[name];
  }

  void setAttr(String key, String value) {
    attrsMap[key] = value;
  }

  bool hasContainer() {
    return getAttr('backgroundColor') != null ||
        getAttr('width') != null ||
        getAttr('height') != null ||
        getAttr('paddingLeft') != null ||
        getAttr('paddingTop') != null ||
        getAttr('paddingRight') != null ||
        getAttr('paddingBottom') != null ||
        getAttr('marginLeft') != null ||
        getAttr('marginTop') != null ||
        getAttr('marginRight') != null ||
        getAttr('marginBottom') != null;
  }

  double get width =>
      getAttr('width') != null ? double.parse(getAttr('width')) : null;

  double get height =>
      getAttr('height') != null ? double.parse(getAttr('height')) : null;

  Color get backgroundColor {
    final attrStr = getAttr('backgroundColor') ?? '#FFFFFF';
    final prefix = attrStr.length == 7 ? '0xFF' : '0x';
    final colorStr = prefix + attrStr.substring(1, attrStr.length);
    return Color(int.parse(colorStr));
  }

  Alignment get alignment =>
      getAttr('alignment') != null ? Alignment.center : Alignment.topLeft;

  String get positionType => getAttr('positionType') ?? 'relative';

  double get positionLeft => getAttr('positionLeft') != null
      ? double.parse(getAttr('positionLeft'))
      : null;

  double get positionTop => getAttr('positionTop') != null
      ? double.parse(getAttr('positionTop'))
      : null;

  double get positionRight => getAttr('positionRight') != null
      ? double.parse(getAttr('positionRight'))
      : null;

  double get positionBottom => getAttr('positionBottom') != null
      ? double.parse(getAttr('positionBottom'))
      : null;

  double get marginLeft =>
      getAttr('marginLeft') != null ? double.parse(getAttr('marginLeft')) : 0;

  double get marginTop =>
      getAttr('marginTop') != null ? double.parse(getAttr('marginTop')) : 0;

  double get marginRight =>
      getAttr('marginRight') != null ? double.parse(getAttr('marginRight')) : 0;

  double get marginBottom => getAttr('marginBottom') != null
      ? double.parse(getAttr('marginBottom'))
      : 0;

  double get paddingLeft =>
      getAttr('paddingLeft') != null ? double.parse(getAttr('paddingLeft')) : 0;

  double get paddingTop =>
      getAttr('paddingTop') != null ? double.parse(getAttr('paddingTop')) : 0;

  double get paddingRight => getAttr('paddingRight') != null
      ? double.parse(getAttr('paddingRight'))
      : 0;

  double get paddingBottom => getAttr('paddingBottom') != null
      ? double.parse(getAttr('paddingBottom'))
      : 0;

  String get action => getAttr('action');

  Widget build(DSLMethodInvoker invoker) {
    Widget widget = hasContainer()
        ? Container(
            width: width,
            height: height,
            color: backgroundColor,
            margin: EdgeInsets.only(
                left: marginLeft,
                top: marginTop,
                right: marginRight,
                bottom: marginBottom),
            padding: EdgeInsets.only(
                left: paddingLeft,
                top: paddingTop,
                right: paddingRight,
                bottom: paddingBottom),
            child: internalBuild(invoker),
          )
        : internalBuild(invoker);
    return action != null
        ? GestureDetector(
            child: widget,
            onTap: () {
              invoker?.invoke(action);
            },
          )
        : widget;
  }
}

class Attr {
  String name;
  String value;
}

class FlexNode extends TemplateNode {
  @override
  Widget internalBuild(DSLMethodInvoker invoker) {
    final innerChildrenWidget = <Widget>[];
    final outsideChildrenWidget = <Widget>[];
    children.forEach((node) {
      if (node.positionType == 'relative') {
        innerChildrenWidget.add(node.build(invoker));
      } else if (node.positionType == 'absolute') {
        outsideChildrenWidget.add(Positioned(
          child: node.build(invoker),
          left: node.positionLeft,
          top: node.positionTop,
          right: node.positionRight,
          bottom: node.positionBottom,
        ));
      }
    });
    final relativeWidget = isVertical
        ? Column(
            children: innerChildrenWidget,
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
          )
        : Row(
            children: innerChildrenWidget,
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
          );
    if (outsideChildrenWidget.isNotEmpty) {
      if (relativeWidget.children.isNotEmpty) {
        outsideChildrenWidget.insert(0, relativeWidget);
      }
      return Stack(
        children: outsideChildrenWidget,
      );
    } else {
      return relativeWidget;
    }
  }

  bool get isVertical => (getAttr('flexDirection') ?? 'column') == 'column';

  MainAxisAlignment get mainAxisAlignment {
    MainAxisAlignment alignment = MainAxisAlignment.start;
    final attrStr = getAttr('justifyContent');
    switch (attrStr) {
      case 'flex-start':
        alignment = MainAxisAlignment.start;
        break;
      case 'flex-end':
        alignment = MainAxisAlignment.end;
        break;
      case 'center':
        alignment = MainAxisAlignment.center;
        break;
      case 'space-between':
        alignment = MainAxisAlignment.spaceBetween;
        break;
      case 'space-around':
        alignment = MainAxisAlignment.spaceAround;
        break;
    }
    return alignment;
  }

  CrossAxisAlignment get crossAxisAlignment {
    CrossAxisAlignment alignment = CrossAxisAlignment.start;
    final attrStr = getAttr('justifyContent');
    switch (attrStr) {
      case 'flex-start':
        alignment = CrossAxisAlignment.start;
        break;
      case 'flex-end':
        alignment = CrossAxisAlignment.end;
        break;
      case 'center':
        alignment = CrossAxisAlignment.center;
        break;
      case 'baseline':
        alignment = CrossAxisAlignment.baseline;
        break;
      case 'stretch':
        alignment = CrossAxisAlignment.stretch;
        break;
    }
    return alignment;
  }
}

class TextNode extends TemplateNode {
  @override
  Widget internalBuild(DSLMethodInvoker invoker) {
    return Text(
      text,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: textSize,
        color: color,
        decoration: TextDecoration.none,
        fontWeight: fontWeight,
      ),
    );
  }

  String get text => getAttr('text') ?? '';

  double get textSize =>
      getAttr('textSize') != null ? double.parse(getAttr('textSize')) : 14.0;

  int get maxLines =>
      getAttr('maxLines') != null ? int.parse(getAttr('maxLines')) : null;

  Color get color {
    final attrStr = getAttr('textColor') ?? '#FFFFFF';
    final prefix = attrStr.length == 7 ? '0xFF' : '0x';
    final colorStr = prefix + attrStr.substring(1, attrStr.length);
    return Color(int.parse(colorStr));
  } 

  FontWeight get fontWeight {
    if (getAttr('textStyle') != null && getAttr('textStyle') == 'bold') {
      return FontWeight.bold;
    }

    return FontWeight.normal;
  }
}

class ImageNode extends TemplateNode {
  @override
  Widget internalBuild(DSLMethodInvoker invoker) {
    return Image.network(src);
  }

  String get src => getAttr('url') ?? '';
}

class EmptyNode extends TemplateNode {
  @override
  Widget internalBuild(DSLMethodInvoker invoker) {
    return Container();
  }
}
