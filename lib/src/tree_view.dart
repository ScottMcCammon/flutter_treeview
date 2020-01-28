import 'package:flutter/material.dart';
import 'package:flutter_treeview/src/tree_view_controller.dart';
import 'package:flutter_treeview/src/tree_view_theme.dart';

import 'models/node.dart';
import 'tree_node.dart';

class TreeView extends InheritedWidget {
  final TreeViewController controller;
  final Function(String) onNodeSelect;
  final Function(String, bool) onExpansionChanged;
  final TreeViewTheme theme;
  final bool allowParentSelect;
  final bool supportParentDoubleTap;

  TreeView({
    Key key,
    @required this.controller,
    this.onNodeSelect,
    this.onExpansionChanged,
    this.allowParentSelect: false,
    this.supportParentDoubleTap: false,
    TreeViewTheme theme,
  })  : this.theme = theme ?? const TreeViewTheme(),
        super(
          key: key,
          child: _TreeViewData(controller),
        );

  static TreeView of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType(aspect: TreeView);

  @override
  bool updateShouldNotify(TreeView oldWidget) {
    return oldWidget.controller.children != this.controller.children ||
        oldWidget.onNodeSelect != this.onNodeSelect ||
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
    return Theme(
      data: ThemeData(
        hoverColor: Colors.grey.shade100,
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
