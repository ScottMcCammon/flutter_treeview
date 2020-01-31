import 'package:flutter/material.dart';
import 'package:flutter_treeview/src/expander_theme_data.dart';

const double _kDefaultLevelPadding = 20;

class TreeViewTheme {
  final ColorScheme colorScheme;
  final double levelPadding;
  final IconThemeData iconTheme;
  final ExpanderThemeData expanderTheme;
  final TextStyle labelStyle;

  const TreeViewTheme({
    this.colorScheme,
    this.iconTheme,
    this.expanderTheme,
    this.labelStyle,
    this.levelPadding,
  });

  const TreeViewTheme.fallback()
      : colorScheme = const ColorScheme.light(),
        iconTheme = const IconThemeData.fallback(),
        expanderTheme = const ExpanderThemeData.fallback(),
        labelStyle = const TextStyle(),
        levelPadding = _kDefaultLevelPadding;

  TreeViewTheme copyWith({
    ColorScheme colorScheme,
    IconThemeData iconTheme,
    ExpanderThemeData expanderTheme,
    TextStyle labelStyle,
    double levelPadding,
  }) {
    return TreeViewTheme(
      colorScheme: colorScheme ?? this.colorScheme,
      levelPadding: levelPadding ?? this.levelPadding,
      iconTheme: iconTheme ?? this.iconTheme,
      expanderTheme: expanderTheme ?? this.expanderTheme,
      labelStyle: labelStyle ?? this.labelStyle,
    );
  }

  TreeViewTheme merge(TreeViewTheme other) {
    if (other == null) return this;
    return copyWith(
      colorScheme: other.colorScheme,
      levelPadding: other.levelPadding,
      iconTheme: other.iconTheme,
      expanderTheme: other.expanderTheme,
      labelStyle: other.labelStyle,
    );
  }

  TreeViewTheme resolve(BuildContext context) => this;

  @override
  int get hashCode {
    return hashValues(
      colorScheme,
      levelPadding,
      iconTheme,
      expanderTheme,
      labelStyle,
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
        other.expanderTheme == expanderTheme &&
        other.labelStyle == labelStyle;
  }
}
