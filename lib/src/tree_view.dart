import 'package:flutter/material.dart';
import 'package:flutter_treeview/src/tree_view_controller.dart';
import 'package:flutter_treeview/src/tree_view_theme.dart';

import 'models/node.dart';
import 'tree_node.dart';

/// Defines the [TreeView] widget.
///
/// This is the main widget for the package. It requires a controller
/// and allows you to specify other optional properties that manages
/// the appearance and handle events.
///
/// ```dart
/// TreeView(
///   controller: _treeViewController,
///   allowParentSelect: false,
///   supportParentDoubleTap: false,
///   onExpansionChanged: _expandNodeHandler,
///   onNodeTap: (key) {
///     setState(() {
///       _treeViewController = _treeViewController.copyWith(selectedKey: key);
///     });
///   },
///   theme: treeViewTheme
/// ),
/// ```
class TreeView extends InheritedWidget {
  /// The controller for the [TreeView]. It manages the data and selected key.
  final TreeViewController controller;

  /// The tap handler for a node. Passes the node key.
  final Function(String) onNodeTap;

  /// The double tap handler for a node. Passes the node key.
  final Function(String) onNodeDoubleTap;

  /// The expand/collapse handler for a node. Passes the node key and the
  /// expansion state.
  final Function(String, bool) onExpansionChanged;

  /// The theme for [TreeView].
  final TreeViewTheme theme;

  /// Determines whether the user can select a parent node. If false,
  /// tapping the parent will expand or collapse the node. If true, the node
  /// will be selected and the use has to use the expander to expand or
  /// collapse the node.
  final bool allowParentSelect;

  /// Determines whether the parent node can receive a double tap. This is
  /// useful if [allowParentSelect] is true. This allows the user to double tap
  /// the parent node to expand or collapse the parent when [allowParentSelect]
  /// is true.
  /// ___IMPORTANT___
  /// _When true, the tap handler is delayed. This is because the double tap
  /// action requires a short delay to determine whether the user is attempting
  /// a single or double tap._
  final bool supportParentDoubleTap;

  TreeView({
    Key key,
    @required this.controller,
    this.onNodeTap,
    this.onNodeDoubleTap,
    this.onExpansionChanged,
    this.allowParentSelect: false,
    this.supportParentDoubleTap: false,
    TreeViewTheme theme,
  })
      : this.theme = theme ?? const TreeViewTheme(),
        super(
        key: key,
        child: _TreeViewData(controller),
      );

  static TreeView of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType(aspect: TreeView);

  @override
  bool updateShouldNotify(TreeView oldWidget) {
    return oldWidget.controller.children != this.controller.children ||
        oldWidget.onNodeTap != this.onNodeTap ||
        oldWidget.onExpansionChanged != this.onExpansionChanged ||
        oldWidget.theme != this.theme ||
        oldWidget.supportParentDoubleTap != this.supportParentDoubleTap ||
        oldWidget.allowParentSelect != this.allowParentSelect;
  }
}

class _TreeViewData extends StatelessWidget {
  final TreeViewController _controller;

  const _TreeViewData(this._controller);

  @override
  Widget build(BuildContext context) {
    ThemeData _parentTheme = Theme.of(context);
    return Theme(
      data: _parentTheme.copyWith(
          hoverColor: Colors.grey.shade100
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: _controller.children.map((Node node) {
          return TreeNode(node: node);
        }).toList(),
      ),
    );
  }
}
