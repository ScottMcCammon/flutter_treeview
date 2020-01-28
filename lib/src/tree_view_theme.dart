import 'package:flutter/material.dart';
import 'package:flutter_treeview/src/enums.dart';

class TreeViewTheme {
  const TreeViewTheme({
    this.colorScheme: const ColorScheme.light(),
    this.iconTheme: const IconThemeData(),
    this.labelStyle: const TextStyle(),
    this.levelPadding: 20,
    this.position: ExpanderPosition.start,
    this.expanderStyle: ExpanderStyle.arrow,
  });

  final ColorScheme colorScheme;
  final double levelPadding;
  final IconThemeData iconTheme;
  final TextStyle labelStyle;
  final ExpanderPosition position;
  final ExpanderStyle expanderStyle;

  TreeViewTheme copyWith({
    ColorScheme colorScheme,
    IconThemeData iconTheme,
    TextStyle labelStyle,
    ExpanderPosition position,
    ExpanderStyle arrowStyle,
    double levelPadding,
  }) {
    return TreeViewTheme(
      colorScheme: colorScheme ?? this.colorScheme,
      levelPadding: levelPadding ?? this.levelPadding,
      iconTheme: iconTheme ?? this.iconTheme,
      labelStyle: labelStyle ?? this.labelStyle,
      position: position ?? this.position,
      expanderStyle: arrowStyle ?? this.expanderStyle,
    );
  }

  @override
  int get hashCode {
    return hashValues(
      colorScheme,
      levelPadding,
      iconTheme,
      labelStyle,
      position,
      expanderStyle,
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
        other.position == position &&
        other.expanderStyle == expanderStyle &&
        other.labelStyle == labelStyle;
  }
}
