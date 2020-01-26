import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_treeview/src/models/node.dart';
import 'package:flutter_treeview/src/models/node_icon.dart';

void main() {
  group('instantiate', () {
    test('from string', () {
      final Node node = Node.fromLabel('Home');
      expect(node.key.isNotEmpty, true);
      expect(node.label, 'Home');
      expect(node.icon, null);
      expect(node.expanded, false);
      expect(node.children.length, 0);
    });
    test('copyWith', () {
      final Node node = Node.fromLabel('Home');
      expect(node.label, 'Home');
      expect(node.icon, null);
      expect(node.expanded, false);
      expect(node.children.length, 0);
      final Node newNode = node.copyWith(label: 'New Home');
      expect(newNode.label, 'New Home');
      expect(newNode.icon, null);
      expect(newNode.expanded, false);
      expect(newNode.children.length, 0);
    });
    test('from map', () {
      final map = {
        "key": "12345",
        "label": "Home",
      };
      final expectedMap = {
        "key": "12345",
        "label": "Home",
        "icon": null,
        "expanded": false,
        "children": [],
      };
      final Node node = Node.fromMap(map);
      expect(node.key, '12345');
      expect(node.label, 'Home');
      expect(node.icon, null);
      expect(node.expanded, false);
      expect(node.children.length, 0);
      expect(node.isParent, false);
      expect(node.asMap, expectedMap);
    });
    test('from map', () {
      final map = {
        "label": "Home",
        "expanded": 1,
        "icon": {
          "codePoint": Icons.home.codePoint,
        },
        "children": [
          {
            "key": "12345b",
            "label": "Basement",
          },
          {
            "key": "12345k",
            "label": "Kitchen",
          }
        ],
      };
      final expectedMap = {
        "label": "Home",
        "icon": {
          "codePoint": Icons.home.codePoint,
          "color": null,
          "fontFamily": "MaterialIcons",
        },
        "expanded": true,
        "children": [
          {
            "key": "12345b",
            "label": "Basement",
            "icon": null,
            "expanded": false,
            "children": [],
          },
          {
            "key": "12345k",
            "label": "Kitchen",
            "icon": null,
            "expanded": false,
            "children": [],
          }
        ],
      };
      final Node node = Node.fromMap(map);
      expect(node.key.isNotEmpty, true);
      expect(node.label, 'Home');
      expect(node.icon.runtimeType, NodeIcon);
      expect(node.expanded, true);
      expect(node.children.length, 2);
      expect(node.isParent, true);
      Map nodeMap = node.asMap;
      nodeMap.remove('key');
      expect(nodeMap, expectedMap);
    });
  });
}
