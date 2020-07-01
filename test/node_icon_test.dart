import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_treeview/src/models/node_icon.dart';

void main() {
  group('instantiate', () {
    test('from string', () {
      final NodeIcon icon = NodeIcon.fromString('adb');
      expect(icon.codePoint, Icons.adb.codePoint);
      expect(icon.fontFamily, Icons.adb.fontFamily);
      expect(icon.iconColor, null);
      expect(icon.icon.runtimeType, IconData);
    });
    test('from iconData', () {
      final NodeIcon icon = NodeIcon.fromIconData(Icons.adb);
      expect(icon.codePoint, Icons.adb.codePoint);
      expect(icon.fontFamily, Icons.adb.fontFamily);
      expect(icon.iconColor, null);
      expect(icon.icon.runtimeType, IconData);
    });
    test('from map', () {
      final map = {"codePoint": Icons.help.codePoint, "color": "#990000"};
      final expectedMap = {
        "codePoint": Icons.help.codePoint,
        "color": "#990000",
        "fontFamily": "MaterialIcons",
        "fontPackage": null,
      };
      final NodeIcon icon = NodeIcon.fromMap(map);
      expect(icon.codePoint, Icons.help.codePoint);
      expect(icon.fontFamily, Icons.help.fontFamily);
      expect(icon.iconColor, Color(0xff990000));
      expect(icon.icon.runtimeType, IconData);
      expect(NodeIcon.fromMap({}), null);
      expect(icon.asMap, expectedMap);
    });
  });
}
