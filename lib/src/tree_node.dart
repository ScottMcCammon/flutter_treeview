import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';

import 'models/node.dart';

class TreeNode extends StatelessWidget {
  final double _leftPadding = 25; //TODO: move to themeData
  final Node node;

  const TreeNode({Key key, @required this.node}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TreeView treeView = TreeView.of(context);
    bool isSelected = treeView != null &&
        treeView.controller.selectedKey != null &&
        treeView.controller.selectedKey == node.key;
    bool canSelectParent = treeView != null && treeView.allowParentSelect;
    Function _parentExpand = () {
      TreeView treeView = TreeView.of(context);
      if (treeView != null) {
        if (node.expanded) {
          if (treeView.onNodeCollapse != null) {
            treeView.onNodeCollapse(node.key);
          }
        } else {
          if (treeView.onNodeExpand != null) {
            treeView.onNodeExpand(node.key);
          }
        }
      }
    };
    Function _parentSelect = () {
      TreeView treeView = TreeView.of(context);
      if (treeView != null) {
        if (treeView.onNodeSelect != null) {
          treeView.onNodeSelect(node.key);
        }
      }
    };
    Function _select = () {
      TreeView treeView = TreeView.of(context);
      if (treeView != null) {
        if (treeView.onNodeSelect != null) {
          treeView.onNodeSelect(node.key);
        }
      }
    };
    final arrow = node.isParent
        ? GestureDetector(
            onTap: _parentExpand,
            child: Container(
              width: _leftPadding,
              alignment: Alignment.bottomRight,
              child: Icon(
                  node.expanded ? Icons.arrow_drop_down : Icons.arrow_right),
            ),
          )
        : Container(width: _leftPadding);
    final label = node.isParent
        ? Expanded(
            child: GestureDetector(
              onTap: canSelectParent ? _parentSelect : _parentExpand,
              onDoubleTap: canSelectParent ? _parentExpand : null,
              child: Container(
                color: isSelected ? Colors.blue : Colors.transparent,
                child: ListTile(
                  title: Text(node.label),
                  dense: true,
                ),
              ),
            ),
          )
        : Expanded(
            child: GestureDetector(
              onTap: _select,
              child: Container(
                color: isSelected ? Colors.blue : Colors.transparent,
                child: ListTile(
                  title: Text(node.label),
                  dense: true,
                ),
              ),
            ),
          );
    final nodeLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[arrow, label],
    );
    return node.isParent
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              nodeLabel,
              AnimatedContainer(
                padding: EdgeInsets.only(left: _leftPadding - 5),
                duration: Duration(milliseconds: 500),
                child: node.expanded
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: node.children.map((Node node) {
                          return TreeNode(node: node);
                        }).toList(),
                      )
                    : Container(),
              ),
            ],
          )
        : nodeLabel;
  }
}
