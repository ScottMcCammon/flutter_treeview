import 'package:flutter/material.dart';
import 'package:flutter_treeview/src/enums.dart';

class TreeViewTheme {
  const TreeViewTheme({
    this.colorScheme: const ColorScheme.light(),
    this.iconTheme: const IconThemeData(),
    this.labelStyle: const TextStyle(),
    this.levelPadding: 25,
    this.style: TreeViewStyle.classic,
    this.arrowStyle: ArrowStyle.arrow,
  });

  final ColorScheme colorScheme;
  final double levelPadding;
  final IconThemeData iconTheme;
  final TextStyle labelStyle;
  final TreeViewStyle style;
  final ArrowStyle arrowStyle;

  TreeViewTheme copyWith({
    ColorScheme colorScheme,
    IconThemeData iconTheme,
    TextStyle labelStyle,
    TreeViewStyle style,
    ArrowStyle arrowStyle,
    double levelPadding,
  }) {
    return TreeViewTheme(
      colorScheme: colorScheme ?? this.colorScheme,
      levelPadding: levelPadding ?? this.levelPadding,
      iconTheme: iconTheme ?? this.iconTheme,
      labelStyle: labelStyle ?? this.labelStyle,
      style: style ?? this.style,
      arrowStyle: arrowStyle ?? this.arrowStyle,
    );
  }

  @override
  int get hashCode {
    return hashValues(
      colorScheme,
      levelPadding,
      iconTheme,
      labelStyle,
      style,
      arrowStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is TreeViewTheme &&
        other.colorScheme == colorScheme &&
        other.levelPadding == levelPadding &&
        other.iconTheme == iconTheme &&
        other.style == style &&
        other.arrowStyle == arrowStyle &&
        other.labelStyle == labelStyle;
  }
}
