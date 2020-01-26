import 'package:flutter/material.dart';
import 'package:flutter_treeview/src/enums.dart';
import 'package:flutter_treeview/src/tree_view_controller.dart';

import 'models/node.dart';
import 'tree_node.dart';

class TreeView extends InheritedWidget {
  final TreeViewController controller;
  final Function(String) onNodeSelect;
  final Function(String) onNodeExpand;
  final Function(String) onNodeCollapse;
  final TreeViewStyle style;
  final bool allowParentSelect;

  TreeView({
    Key key,
    @required this.controller,
    this.onNodeSelect,
    this.onNodeExpand,
    this.onNodeCollapse,
    this.style: TreeViewStyle.classic,
    this.allowParentSelect: false,
  }) : super(key: key, child: _TreeViewData(controller, style: style));

  static TreeView of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType(aspect: TreeView);

  @override
  bool updateShouldNotify(TreeView oldWidget) {
    return oldWidget.controller.children != this.controller.children ||
        oldWidget.onNodeSelect != this.onNodeSelect ||
        oldWidget.onNodeExpand != this.onNodeExpand ||
        oldWidget.onNodeCollapse != this.onNodeCollapse ||
        oldWidget.style != this.style ||
        oldWidget.allowParentSelect != this.allowParentSelect;
  }
}

class _TreeViewData extends StatelessWidget {
  final TreeViewController _controller;
  final TreeViewStyle _style;

  const _TreeViewData(this._controller, {TreeViewStyle style})
      : this._style = style ?? TreeViewStyle.classic;

  @override
  Widget build(BuildContext context) {
    switch(_style){
      case TreeViewStyle.iOS:
        return buildIOSView();
      default:
        return buildClassicView();
    }
  }

  ListView buildClassicView() {
    return ListView(
      children: _controller.children.map((Node node) {
        return TreeNode(node: node);
      }).toList(),
    );
  }

  Widget buildIOSView() {
    return ListView(
      children: <Widget>[
        ExpansionTile(
          title: Text('Desktop'),
          children: <Widget>[
            ExpansionTile(
              title: Text('documents'),
              children: <Widget>[
                ListTile(title: Text('Resume.docx')),
                ListTile(title: Text('Billing-Info.docx')),
              ],
            ),
            ListTile(title: Text('MeetingReport.xls')),
            ListTile(title: Text('MeetingReport.pdf')),
            ListTile(title: Text('Demo.zip')),
          ],
        ),
      ],
    );
  }
}
