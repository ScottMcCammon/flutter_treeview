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
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static Duration _kExpand = Duration(milliseconds: 200);
  static double _kIconSize = 28;

  AnimationController _controller;
  Animation<double> _heightFactor;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _isExpanded = widget.node.expanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleExpand() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {});
        });
      }
    });
    if (_treeView.onExpansionChanged != null)
      _treeView.onExpansionChanged(widget.node.key, _isExpanded);
  }

  void _handleSelect() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    if (_treeView.onNodeSelect != null) {
      _treeView.onNodeSelect(widget.node.key);
    }
  }

  Icon _buildExpandWidget() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    TreeViewTheme _theme = _treeView.theme;
    IconData arrow;
    if (_theme.arrowStyle == ArrowStyle.chevron) {
      arrow = widget.node.expanded ? Icons.expand_more : Icons.chevron_right;
    } else if (_theme.arrowStyle == ArrowStyle.longArrow) {
      arrow = widget.node.expanded ? Icons.arrow_downward : Icons.arrow_forward;
    } else if (_theme.arrowStyle == ArrowStyle.box) {
      arrow =
          widget.node.expanded ? Icons.indeterminate_check_box : Icons.add_box;
    } else if (_theme.arrowStyle == ArrowStyle.filledCircle) {
      arrow = widget.node.expanded ? Icons.remove_circle : Icons.add_circle;
    } else if (_theme.arrowStyle == ArrowStyle.circle) {
      arrow = widget.node.expanded
          ? Icons.remove_circle_outline
          : Icons.add_circle_outline;
    } else {
      arrow = widget.node.expanded ? Icons.arrow_drop_down : Icons.arrow_right;
    }
    return Icon(
      arrow,
      size: 24,
      color: _theme.iconTheme.color,
    );
  }

  Widget _buildNodeTitle() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    TreeViewTheme _theme = _treeView.theme;
    bool isSelected = _treeView.controller.selectedKey != null &&
        _treeView.controller.selectedKey == widget.node.key;
    bool canSelectParent = _treeView.allowParentSelect;
    final arrowContainer = widget.node.isParent
        ? GestureDetector(
            onTap: () => _handleExpand(),
            child: Container(
              width: _kIconSize,
              alignment: Alignment.centerLeft,
              child: _buildExpandWidget(),
            ),
          )
        : Container(
            width: _kIconSize,
          );
    final icon = Container(
      width: widget.node.hasIcon ? _kIconSize : 10,
      child: widget.node.hasIcon
          ? Icon(
              widget.node.icon.icon,
              size: _theme.iconTheme.size,
              color:
                  widget.node.icon != null && widget.node.icon.iconColor != null
                      ? widget.node.icon.iconColor
                      : _theme.iconTheme.color,
            )
          : null,
    );
    final labelContainer = Container(
      color: isSelected
          ? _theme.colorScheme.primary
          : _theme.colorScheme.background,
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 2),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            icon,
            Expanded(
              child: Text(
                widget.node.label,
                style: _theme.labelStyle.copyWith(
                    color: isSelected
                        ? _theme.colorScheme.onPrimary
                        : _theme.colorScheme.onBackground),
              ),
            ),
          ],
        ),
        dense: true,
      ),
    );
    final labelExpanded = widget.node.isParent
        ? Expanded(
            child: GestureDetector(
              onTap: canSelectParent ? _handleSelect : _handleExpand,
//              onDoubleTap: _parentExpand, //TODO: having doubleTap included makes the select delayed
              child: labelContainer,
            ),
          )
        : Expanded(
            child: GestureDetector(
              onTap: _handleSelect,
              child: labelContainer,
            ),
          );
    return Row(
      children: <Widget>[
        arrowContainer,
        labelExpanded,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    TreeViewTheme _theme = _treeView.theme;
    final bool closed = !_isExpanded && _controller.isDismissed;
    final nodeLabel = _buildNodeTitle();
    return widget.node.isParent
        ? AnimatedBuilder(
            animation: _controller.view,
            builder: (BuildContext context, Widget child) {
              return Container(
                padding: EdgeInsets.only(left: _kIconSize),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    nodeLabel,
                    ClipRect(
                      child: Align(
                        heightFactor: _heightFactor.value,
                        child: child,
                      ),
                    ),
                  ],
                ),
              );
            },
            child: closed
                ? null
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.node.children.map((Node node) {
                      return TreeNode(node: node);
                    }).toList()),
          )
        : Container(
            margin: EdgeInsets.only(left: _kIconSize),
            child: nodeLabel,
          );
  }
}
