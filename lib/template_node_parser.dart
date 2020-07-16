import 'package:flutter_dsl_demo/template_node.dart';
import 'package:xml/xml.dart';

class TemplateNodeParser {
  final _factory = TemplateNodeFactory();

  TemplateNode parse(XmlElement xmlElement) {
    final rootNode = _factory.createNode(xmlElement.name.toString());
    xmlElement.attributes.forEach((XmlAttribute attribute) {
      rootNode.setAttr(attribute.name.toString(), attribute.value);
    });
    rootNode.children = <TemplateNode>[];
    for (XmlNode childElement in xmlElement.children) {
      if (childElement is XmlElement) {
        final childNode = _parseNode(childElement);
        if (childNode != null) {
          rootNode.children.add(childNode);
        }
      }
    }
    return rootNode;
  }

  TemplateNode _parseNode(XmlElement xmlElement) {
    final node = _factory.createNode(xmlElement.name.toString());
    if (xmlElement == null) {
      return null;
    }
    xmlElement.attributes.forEach((XmlAttribute attribute) {
      node.setAttr(attribute.name.toString(), attribute.value);
    });
    node.children = <TemplateNode>[];
    for (XmlNode childElement in xmlElement.children) {
      if (childElement is XmlElement) {
        final childNode = _parseNode(childElement);
        if (childNode != null) {
          node.children.add(childNode);
        }
      }
    }
    return node;
  }
}

class TemplateNodeFactory {
  TemplateNode createNode(String elementName) {
    TemplateNode node = EmptyNode();
    switch (elementName) {
      case 'Flex':
        node = FlexNode();
        break;
      case 'Text':
        node = TextNode();
        break;
      case 'Image':
        node = ImageNode();
        break;
    }
    return node;
  }
}
