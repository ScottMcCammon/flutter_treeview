import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';

import 'models/node.dart';

class TreeNode extends StatefulWidget {
  final Node node;

  const TreeNode({Key key, @required this.node}) : super(key: key);

  @override
  _TreeNodeState createState() => _TreeNodeState();
}

class _TreeNodeState extends State<TreeNode>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TreeView treeView = TreeView.of(context);
    assert(treeView != null, 'TreeView must exist in context');
    bool isSelected = treeView.controller.selectedKey != null &&
        treeView.controller.selectedKey == widget.node.key;
    bool canSelectParent = treeView.allowParentSelect;
    Function _parentExpand = () {
      if (widget.node.expanded) {
        if (treeView.onNodeCollapse != null) {
          treeView.onNodeCollapse(widget.node.key);
        }
      } else {
        if (treeView.onNodeExpand != null) {
          treeView.onNodeExpand(widget.node.key);
        }
      }
    };
    Function _parentSelect = () {
      if (treeView.onNodeSelect != null) {
        treeView.onNodeSelect(widget.node.key);
      }
    };
    Function _select = () {
      if (treeView.onNodeSelect != null) {
        treeView.onNodeSelect(widget.node.key);
      }
    };
    IconData arrow;
    if (treeView.theme.arrowStyle == ArrowStyle.chevron) {
      arrow = widget.node.expanded ? Icons.expand_more : Icons.chevron_right;
    } else if (treeView.theme.arrowStyle == ArrowStyle.longArrow) {
      arrow = widget.node.expanded ? Icons.arrow_downward : Icons.arrow_forward;
    } else if (treeView.theme.arrowStyle == ArrowStyle.box) {
      arrow =
          widget.node.expanded ? Icons.indeterminate_check_box : Icons.add_box;
    } else if (treeView.theme.arrowStyle == ArrowStyle.filledCircle) {
      arrow = widget.node.expanded ? Icons.remove_circle : Icons.add_circle;
    } else if (treeView.theme.arrowStyle == ArrowStyle.circle) {
      arrow = widget.node.expanded
          ? Icons.remove_circle_outline
          : Icons.add_circle_outline;
    } else {
      arrow = widget.node.expanded ? Icons.arrow_drop_down : Icons.arrow_right;
    }
    final arrowContainer = widget.node.isParent
        ? GestureDetector(
            onTap: _parentExpand,
            child: Container(
              width: treeView.theme.levelPadding,
              margin: EdgeInsets.only(right: 10),
              alignment: Alignment.bottomRight,
              child: Icon(
                arrow,
                size: 24,
                color: treeView.theme.iconTheme.color,
              ),
            ),
          )
        : Container(
            width: treeView.theme.levelPadding,
            margin: EdgeInsets.only(right: 10),
          );
    final icon = widget.node.hasIcon
        ? Container(
            padding: EdgeInsets.only(left: 10),
            child: Icon(
              widget.node.icon.icon,
              size: treeView.theme.iconTheme.size,
              color:
                  widget.node.icon.iconColor ?? treeView.theme.iconTheme.color,
            ),
          )
        : Container();
    final labelContainer = Container(
      width: double.infinity,
      color: isSelected
          ? treeView.theme.colorScheme.primary
          : treeView.theme.colorScheme.background,
      child: Row(
        children: <Widget>[
          icon,
          Expanded(
            child: ListTile(
              title: Text(
                widget.node.label,
                style: treeView.theme.labelStyle.copyWith(
                    color: isSelected
                        ? treeView.theme.colorScheme.onPrimary
                        : treeView.theme.colorScheme.onBackground),
              ),
              dense: true,
            ),
          ),
        ],
      ),
    );
    final labelExpanded = widget.node.isParent
        ? Expanded(
            child: GestureDetector(
              onTap: canSelectParent ? _parentSelect : _parentExpand,
//TODO: having doubleTap included makes the select delayed
//              onDoubleTap: _parentExpand,
              child: labelContainer,
            ),
          )
        : Expanded(
            child: GestureDetector(
              onTap: _select,
              child: labelContainer,
            ),
          );
    final nodeLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[arrowContainer, labelExpanded],
    );
    return widget.node.isParent
        ? Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              nodeLabel,
              AnimatedSize(
                vsync: this,
                curve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: 150),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: treeView.theme.levelPadding),
                  child: widget.node.expanded
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.node.children.map((Node node) {
                            return TreeNode(node: node);
                          }).toList(),
                        )
                      : null,
                ),
              ),
            ],
          )
        : nodeLabel;
  }
}
