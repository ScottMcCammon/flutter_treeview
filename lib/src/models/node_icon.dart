import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_treeview/src/tree_node.dart';
import 'package:flutter_treeview/src/tree_view_theme.dart';
import 'package:flutter_treeview/src/utilities.dart';

/// Defines the data used to display icons on a [TreeNode].
///
/// Used by [TreeNode] to display a user specified icon.
///
/// By default, the Material Design icon font is used. The icon
/// can come from any user supplied icon font. If a different
/// font is used, just supply the font name using the [fontFamily]
/// property.
class NodeIcon {
  /// The codePoint value of the [IconData] used for this icon.
  final int codePoint;

  /// The font family of used for this icon.
  final String fontFamily;

  /// The name of the package from which the font family is included.
  final String fontPackage;

  /// The color of the icon. This value overrides the default value
  /// in the [TreeViewTheme]
  final String color;

  NodeIcon({
    this.codePoint,
    this.fontFamily: 'MaterialIcons',
    this.fontPackage,
    this.color,
  }) : assert(codePoint != null);

  /// Creates a [NodeIcon] from a string value. It assumes the
  /// default Material Design font and returns a [NodeIcon] object
  /// with an appropriate [codePoint] value and other defaults if the
  /// icon is found. If not found, it returns null.
  factory NodeIcon.fromString(String icon) {
    IconData _icon = Utilities.getIcon(icon);
    return _icon != null
        ? NodeIcon(
            codePoint: _icon.codePoint,
            fontFamily: _icon.fontFamily,
          )
        : null;
  }

  /// Creates a [NodeIcon] from an [IconData] object. It assumes the
  /// default Material Design font and returns a [NodeIcon] object
  /// with an appropriate [codePoint] value and other defaults.
  factory NodeIcon.fromIconData(IconData icon) {
    return NodeIcon(
        codePoint: icon.codePoint,
        fontFamily: icon.fontFamily,
        fontPackage: icon.fontPackage);
  }

  /// Creates a [NodeIcon] from a Map<String, dynamic> map. The map
  /// should contain a "codePoint" value. If the [codePoint] is
  /// missing or invalid, it returns null.
  factory NodeIcon.fromMap(Map<String, dynamic> map) {
    if (map['codePoint'] != null) {
      IconData _icon = IconData(
        map['codePoint'],
        fontFamily: map['fontFamily'] ?? 'MaterialIcons',
        fontPackage: map['fontPackage'],
      );
      return NodeIcon(
        codePoint: _icon.codePoint,
        fontFamily: _icon.fontFamily,
        fontPackage: _icon.fontPackage,
        color: map['color'],
      );
    }
    return null;
  }

  /// Getter to return the [IconData] icon
  IconData get icon => IconData(
        codePoint,
        fontFamily: fontFamily,
        fontPackage: fontPackage,
      );

  /// Getter to return the icon color
  Color get iconColor => color == null ? null : Utilities.getColor(color);

  /// Map representation of this object
  Map<String, dynamic> get asMap => {
        "codePoint": codePoint,
        "fontFamily": fontFamily,
        "fontPackage": fontPackage,
        "color": color,
      };

  @override
  String toString() {
    return JsonEncoder().convert(asMap);
  }

  @override
  int get hashCode {
    return hashValues(
      codePoint,
      color,
      icon,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is NodeIcon &&
        other.color == color &&
        other.codePoint == codePoint &&
        other.icon == icon;
  }
}
