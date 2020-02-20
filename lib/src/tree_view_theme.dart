import 'package:flutter/material.dart';
import 'package:flutter_treeview/src/expander_theme_data.dart';
import 'package:flutter_treeview/src/tree_node.dart';

const double _kDefaultLevelPadding = 20;

/// Defines the appearance of the [TreeView].
///
/// Used by [TreeView] to control the appearance of the sub-widgets
/// in the [TreeView] widget.
class TreeViewTheme {
  /// The [ColorScheme] for [TreeView] widget.
  final ColorScheme colorScheme;

  /// The horizontal padding for the children of a [TreeNode] parent.
  final double levelPadding;

  /// Whether the [TreeNode] is vertically dense.
  ///
  /// If this property is null then its value is based on [ListTileTheme.dense].
  ///
  /// A dense [TreeNode] defaults to a smaller height.
  final bool dense;

  /// The default appearance theme for [TreeNode] icons.
  final IconThemeData iconTheme;

  /// The appearance theme for [TreeNode] expander icons.
  final ExpanderThemeData expanderTheme;

  /// The text style for child [TreeNode] text.
  final TextStyle labelStyle;

  /// The text style for parent [TreeNode] text.
  final TextStyle parentLabelStyle;

  const TreeViewTheme({
    this.colorScheme: const ColorScheme.light(),
    this.iconTheme: const IconThemeData.fallback(),
    this.expanderTheme: const ExpanderThemeData.fallback(),
    this.labelStyle: const TextStyle(),
    this.parentLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
    this.levelPadding: _kDefaultLevelPadding,
    this.dense: true,
  });

  /// Creates a [TreeView] theme with some reasonable default values.
  ///
  /// The [colorScheme] is [ColorScheme.light],
  /// the [iconTheme] is [IconThemeData.fallback],
  /// the [expanderTheme] is [ExpanderThemeData.fallback],
  /// the [labelStyle] is the default [TextStyle],
  /// the [parentLabelStyle] is the default [TextStyle] with bold weight,
  /// and the default [levelPadding] is 20.0.
  const TreeViewTheme.fallback()
      : colorScheme = const ColorScheme.light(),
        iconTheme = const IconThemeData.fallback(),
        expanderTheme = const ExpanderThemeData.fallback(),
        labelStyle = const TextStyle(),
        parentLabelStyle = const TextStyle(fontWeight: FontWeight.bold),
        dense = true,
        levelPadding = _kDefaultLevelPadding;

  /// Creates a copy of this theme but with the given fields replaced with
  /// the new values.
  TreeViewTheme copyWith({
    ColorScheme colorScheme,
    IconThemeData iconTheme,
    ExpanderThemeData expanderTheme,
    TextStyle labelStyle,
    TextStyle parentLabelStyle,
    bool dense,
    double levelPadding,
  }) {
    return TreeViewTheme(
      colorScheme: colorScheme ?? this.colorScheme,
      levelPadding: levelPadding ?? this.levelPadding,
      iconTheme: iconTheme ?? this.iconTheme,
      expanderTheme: expanderTheme ?? this.expanderTheme,
      labelStyle: labelStyle ?? this.labelStyle,
      dense: dense ?? this.dense,
      parentLabelStyle: parentLabelStyle ?? this.parentLabelStyle,
    );
  }

  /// Returns a new theme that matches this [TreeView] theme but with some values
  /// replaced by the non-null parameters of the given icon theme. If the given
  /// [TreeViewTheme] is null, simply returns this theme.
  TreeViewTheme merge(TreeViewTheme other) {
    if (other == null) return this;
    return copyWith(
      colorScheme: other.colorScheme,
      levelPadding: other.levelPadding,
      iconTheme: other.iconTheme,
      expanderTheme: other.expanderTheme,
      labelStyle: other.labelStyle,
      dense: other.dense,
      parentLabelStyle: other.parentLabelStyle,
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
      dense,
      parentLabelStyle,
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
        other.labelStyle == labelStyle &&
        other.dense == dense &&
        other.parentLabelStyle == parentLabelStyle;
  }
}
