import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class TemplateNode {
  Map<String, String> attrsMap = Map<String, String>();
  List<TemplateNode> children;

  Widget internalBuild();

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
        getAttr('padding') != null ||
        getAttr('margin') != null;
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

class Attr {
  String name;
  String value;
}

class FlexNode extends TemplateNode {
  @override
  Widget internalBuild() {
    final innerChildrenWidget = <Widget>[];
    final outsideChildrenWidget = <Widget>[];
    children.forEach((node) {
      if (node.positionType == 'relative') {
        innerChildrenWidget.add(node.build());
      } else if (node.positionType == 'absolute') {
        outsideChildrenWidget.add(Positioned(
          child: node.build(),
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
  Widget internalBuild() {
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
  Widget internalBuild() {
    return Image.network(src);
  }

  String get src => getAttr('url') ?? '';
}

class EmptyNode extends TemplateNode {
  @override
  Widget internalBuild() {
    return Container();
  }
}
