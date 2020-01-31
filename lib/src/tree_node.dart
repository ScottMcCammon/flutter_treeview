import 'package:flutter/material.dart';
import 'package:flutter_treeview/src/tree_view_icons.dart';
import 'package:flutter_treeview/tree_view.dart';

import 'expander_theme_data.dart';
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

  void _handleTap() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    if (_treeView.onNodeTap != null) {
      _treeView.onNodeTap(widget.node.key);
    }
  }

  void _handleDoubleTap() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    if (_treeView.onNodeDoubleTap != null) {
      _treeView.onNodeDoubleTap(widget.node.key);
    }
  }

  Widget _buildNodeExpander() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    TreeViewTheme _theme = _treeView.theme;
    return widget.node.isParent
        ? GestureDetector(
            onTap: () => _handleExpand(),
            child: _TreeNodeExpander(
              expanded: widget.node.expanded,
              containerSize: _kIconSize,
              themeData: _theme.expanderTheme,
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
    Widget _tappable = _treeView.onNodeDoubleTap != null
        ? InkWell(
            hoverColor: Colors.blue,
            onTap: _handleTap,
            onDoubleTap: _handleDoubleTap,
            child: labelContainer,
          )
        : InkWell(
            hoverColor: Colors.blue,
            onTap: _handleTap,
            child: labelContainer,
          );
    if (widget.node.isParent) {
      if (_treeView.supportParentDoubleTap && canSelectParent) {
        _tappable = InkWell(
          onTap: canSelectParent ? _handleTap : _handleExpand,
          onDoubleTap: () {
            _handleExpand();
            _handleDoubleTap();
          },
          child: labelContainer,
        );
      } else if (_treeView.supportParentDoubleTap) {
        _tappable = InkWell(
          onTap: _handleExpand,
          onDoubleTap: _handleDoubleTap,
          child: labelContainer,
        );
      } else {
        _tappable = InkWell(
          onTap: canSelectParent ? _handleTap : _handleExpand,
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
        children: _theme.expanderTheme.position == ExpanderPosition.end
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

class _TreeNodeExpander extends StatelessWidget {
  final ExpanderThemeData themeData;
  final bool expanded;
  final double containerSize;

  const _TreeNodeExpander({
    this.themeData,
    this.expanded,
    this.containerSize,
  });

  @override
  Widget build(BuildContext context) {
    IconData arrow;
    if (themeData.position == ExpanderPosition.end) {
      switch (themeData.type) {
        case ExpanderType.arrow:
          arrow = expanded ? TreeViewIcons.arrow_down : TreeViewIcons.arrow_up;
          break;
        case ExpanderType.chevron:
          arrow = expanded ? TreeViewIcons.down : TreeViewIcons.up;
          break;
        case ExpanderType.circleChevron:
          arrow = expanded
              ? TreeViewIcons.down_circle_fill
              : TreeViewIcons.up_circle_fill;
          break;
        case ExpanderType.circleChevronOutline:
          arrow =
              expanded ? TreeViewIcons.down_circle : TreeViewIcons.up_circle;
          break;
        case ExpanderType.circlePlusMinus:
          arrow = expanded
              ? TreeViewIcons.minus_circle_fill
              : TreeViewIcons.plus_circle_fill;
          break;
        case ExpanderType.circlePlusMinusOutline:
          arrow =
              expanded ? TreeViewIcons.minus_circle : TreeViewIcons.plus_circle;
          break;
        case ExpanderType.plusMinus:
          arrow = expanded ? TreeViewIcons.minus : TreeViewIcons.plus;
          break;
        case ExpanderType.squareChevron:
          arrow = expanded
              ? TreeViewIcons.down_square_fill
              : TreeViewIcons.up_square_fill;
          break;
        case ExpanderType.squareChevronOutline:
          arrow =
              expanded ? TreeViewIcons.down_square : TreeViewIcons.up_square;
          break;
        case ExpanderType.squarePlusMinus:
          arrow = expanded
              ? TreeViewIcons.minus_square_fill
              : TreeViewIcons.plus_square_fill;
          break;
        case ExpanderType.squarePlusMinusOutline:
          arrow =
              expanded ? TreeViewIcons.minus_square : TreeViewIcons.plus_square;
          break;
        default:
          arrow = expanded ? TreeViewIcons.caret_down : TreeViewIcons.caret_up;
      }
    } else {
      switch (themeData.type) {
        case ExpanderType.arrow:
          arrow =
              expanded ? TreeViewIcons.arrow_down : TreeViewIcons.arrow_right;
          break;
        case ExpanderType.chevron:
          arrow = expanded ? TreeViewIcons.down : TreeViewIcons.right;
          break;
        case ExpanderType.circleChevron:
          arrow = expanded
              ? TreeViewIcons.down_circle_fill
              : TreeViewIcons.right_circle_fill;
          break;
        case ExpanderType.circleChevronOutline:
          arrow =
              expanded ? TreeViewIcons.down_circle : TreeViewIcons.right_circle;
          break;
        case ExpanderType.circlePlusMinus:
          arrow = expanded
              ? TreeViewIcons.minus_circle_fill
              : TreeViewIcons.plus_circle_fill;
          break;
        case ExpanderType.circlePlusMinusOutline:
          arrow =
              expanded ? TreeViewIcons.minus_circle : TreeViewIcons.plus_circle;
          break;
        case ExpanderType.plusMinus:
          arrow = expanded ? TreeViewIcons.minus : TreeViewIcons.plus;
          break;
        case ExpanderType.squareChevron:
          arrow = expanded
              ? TreeViewIcons.down_square_fill
              : TreeViewIcons.right_square_fill;
          break;
        case ExpanderType.squareChevronOutline:
          arrow =
              expanded ? TreeViewIcons.down_square : TreeViewIcons.right_square;
          break;
        case ExpanderType.squarePlusMinus:
          arrow = expanded
              ? TreeViewIcons.minus_square_fill
              : TreeViewIcons.plus_square_fill;
          break;
        case ExpanderType.squarePlusMinusOutline:
          arrow =
              expanded ? TreeViewIcons.minus_square : TreeViewIcons.plus_square;
          break;
        default:
          arrow =
              expanded ? TreeViewIcons.caret_down : TreeViewIcons.caret_right;
          break;
      }
    }
    return Container(
      width: containerSize,
      alignment: themeData.position == ExpanderPosition.end
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Icon(
        arrow,
        size: themeData.size,
        color: themeData.color,
      ),
    );
  }
}
