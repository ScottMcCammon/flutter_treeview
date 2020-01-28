import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_treeview/src/utilities.dart';

class NodeIcon {
  final int codePoint;
  final String fontFamily;
  final String color;

  NodeIcon({this.codePoint, this.fontFamily, this.color})
      : assert(codePoint != null);

  factory NodeIcon.fromString(String icon) {
    IconData _icon = Utilities.getIcon(icon);
    return NodeIcon(
      codePoint: _icon.codePoint,
      fontFamily: _icon.fontFamily,
    );
  }

  factory NodeIcon.fromIconData(IconData icon) {
    return NodeIcon(
      codePoint: icon.codePoint,
      fontFamily: icon.fontFamily,
    );
  }

  factory NodeIcon.fromMap(Map<String, dynamic> map) {
    if (map['codePoint'] != null) {
      IconData _icon = IconData(map['codePoint'],
          fontFamily: map['fontFamily'] ?? 'MaterialIcons');
      return NodeIcon(
        codePoint: _icon.codePoint,
        fontFamily: _icon.fontFamily,
        color: map['color'],
      );
    }
    return null;
  }

  IconData get icon => IconData(codePoint, fontFamily: fontFamily);

  Color get iconColor => color == null ? null : Utilities.getColor(color);

  Map<String, dynamic> get asMap => {
        "codePoint": codePoint,
        "fontFamily": fontFamily,
        "color": color,
      };

  @override
  String toString() {
    return JsonEncoder().convert(asMap);
  }
}
