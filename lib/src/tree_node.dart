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

  Widget _buildNodeExpander() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    TreeViewTheme _theme = _treeView.theme;
    IconData arrow;
    if (_theme.expanderStyle == ExpanderStyle.chevron) {
      arrow = widget.node.expanded ? Icons.expand_more : Icons.chevron_right;
    } else if (_theme.expanderStyle == ExpanderStyle.longArrow) {
      arrow = widget.node.expanded ? Icons.arrow_downward : Icons.arrow_forward;
    } else if (_theme.expanderStyle == ExpanderStyle.box) {
      arrow =
          widget.node.expanded ? Icons.indeterminate_check_box : Icons.add_box;
    } else if (_theme.expanderStyle == ExpanderStyle.filledCircle) {
      arrow = widget.node.expanded ? Icons.remove_circle : Icons.add_circle;
    } else if (_theme.expanderStyle == ExpanderStyle.circle) {
      arrow = widget.node.expanded
          ? Icons.remove_circle_outline
          : Icons.add_circle_outline;
    } else {
      arrow = widget.node.expanded ? Icons.arrow_drop_down : Icons.arrow_right;
    }
    return widget.node.isParent
        ? GestureDetector(
            onTap: () => _handleExpand(),
            child: Container(
              width: _kIconSize,
              alignment: _theme.position == ExpanderPosition.end
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Icon(
                arrow,
                size: 24,
                color: _theme.iconTheme.color,
              ),
            ),
          )
        : Container(
            width: _kIconSize,
          );
  }

  Widget _buildNodeIcon() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    TreeViewTheme _theme = _treeView.theme;
    return Container(
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
  }

  Widget _buildNodeLabel() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    TreeViewTheme _theme = _treeView.theme;
    bool isSelected = _treeView.controller.selectedKey != null &&
        _treeView.controller.selectedKey == widget.node.key;
    final icon = _buildNodeIcon();
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 0,
      ),
      color: isSelected
          ? _theme.colorScheme.primary
          : _theme.colorScheme.background,
      child: Row(
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
                    : _theme.colorScheme.onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNodeTitle() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    TreeViewTheme _theme = _treeView.theme;
    bool isSelected = _treeView.controller.selectedKey != null &&
        _treeView.controller.selectedKey == widget.node.key;
    bool canSelectParent = _treeView.allowParentSelect;
    final arrowContainer = _buildNodeExpander();
    final labelContainer = _buildNodeLabel();
    Widget _tappable = InkWell(
      hoverColor: Colors.blue,
      onTap: _handleSelect,
      child: labelContainer,
    );
    if (widget.node.isParent) {
      if (_treeView.supportParentDoubleTap && canSelectParent) {
        _tappable = InkWell(
          onTap: canSelectParent ? _handleSelect : _handleExpand,
          onDoubleTap: _handleExpand,
          child: labelContainer,
        );
      } else {
        _tappable = InkWell(
          onTap: canSelectParent ? _handleSelect : _handleExpand,
          child: labelContainer,
        );
      }
    }
    return Container(
      color: isSelected
          ? _theme.colorScheme.primary
          : _theme.colorScheme.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _theme.position == ExpanderPosition.end
            ? <Widget>[
                Expanded(
                  child: _tappable,
                ),
                arrowContainer,
              ]
            : <Widget>[
                arrowContainer,
                Expanded(
                  child: _tappable,
                ),
              ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    final bool closed = !_isExpanded && _controller.isDismissed;
    final nodeLabel = _buildNodeTitle();
    return widget.node.isParent
        ? AnimatedBuilder(
            animation: _controller.view,
            builder: (BuildContext context, Widget child) {
              return Column(
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
              );
            },
            child: closed
                ? null
                : Container(
                    margin: EdgeInsets.only(left: _kIconSize),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.node.children.map((Node node) {
                          return TreeNode(node: node);
                        }).toList()),
                  ),
          )
        : Container(
            child: nodeLabel,
          );
  }
}
