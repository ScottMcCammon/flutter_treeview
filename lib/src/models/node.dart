import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_treeview/src/tree_node.dart';
import 'package:flutter_treeview/src/utilities.dart';
import 'package:flutter_treeview/tree_view.dart';

import 'node_icon.dart';

/// Defines the data used to display a [TreeNode].
///
/// Used by [TreeView] to display a [TreeNode].
///
/// This object allows the creation of key, label and icon to display
/// a node on the [TreeView] widget. The key and label properties are
/// required. The key is needed for events that occur on the generated
/// [TreeNode]. It should always be unique.
class Node<T> {
  /// The unique string that identifies this object.
  final String key;

  /// The string value that is displayed on the [TreeNode].
  final String label;

  /// An optional icon that is displayed on the [TreeNode].
  final NodeIcon icon;

  /// The open or closed state of the [TreeNode]. Applicable only if the
  /// node is a parent
  final bool expanded;

  /// Generic data model that can be assigned to the [TreeNode]. This makes
  /// it useful to assign and retrieve data associated with the [TreeNode]
  final T data;

  /// The sub [Node]s of this object.
  final List<Node> children;

  Node({
    @required this.key,
    @required this.label,
    this.children: const [],
    this.expanded: false,
    this.icon,
    this.data,
  })  : assert(key != null),
        assert(label != null);

  /// Creates a [Node] from a string value. It generates a unique key.
  factory Node.fromLabel(String label) {
    String _key = Utilities.generateRandom();
    return Node(
      key: '${_key}_$label',
      label: label,
    );
  }

  /// Creates a [Node] from a Map<String, dynamic> map. The map
  /// should contain a "label" value. If the key value is
  /// missing, it generates a unique key.
  /// If the expanded value, if present, can be any 'truthful'
  /// value. Excepted values include: 1, yes, true and their
  /// associated string values.
  factory Node.fromMap(Map<String, dynamic> map) {
    String _key = map['key'];
    String _label = map['label'];
    NodeIcon _icon;
    List<Node> _children = [];
    if (_key == null) {
      _key = Utilities.generateRandom();
    }
    if (map['icon'] != null) {
      _icon = NodeIcon.fromMap(map['icon']);
    }
    if (map['children'] != null) {
      List<Map<String, dynamic>> _childrenMap = List.from(map['children']);
      _children = _childrenMap
          .map((Map<String, dynamic> child) => Node.fromMap(child))
          .toList();
    }
    return Node(
      key: '$_key',
      label: _label,
      icon: _icon,
      expanded: Utilities.truthful(map['expanded']),
      children: _children,
    );
  }

  /// Creates a copy of this object but with the given fields
  /// replaced with the new values.
  Node copyWith({
    String key,
    String label,
    List<Node> children,
    bool expanded,
    NodeIcon icon,
    T data,
  }) =>
      Node(
        key: key ?? this.key,
        label: label ?? this.label,
        icon: icon ?? this.icon,
        expanded: expanded ?? this.expanded,
        children: children ?? this.children,
        data: data ?? this.data,
      );

  /// Whether this object has children [Node].
  bool get isParent => children.isNotEmpty;

  /// Whether this object has a non-null icon.
  bool get hasIcon => icon != null && icon.icon != null;

  /// Whether this object has data associated with it.
  bool get hasData => data != null;

  /// Map representation of this object
  Map<String, dynamic> get asMap {
    Map<String, dynamic> _map = {
      "key": key,
      "label": label,
      "icon": icon == null ? null : icon.asMap,
      "expanded": expanded,
      "children": children.map((Node child) => child.asMap).toList(),
    };
    //TODO: figure out a means to check for getter or method on generic to include map from generic
    return _map;
  }

  @override
  String toString() {
    return JsonEncoder().convert(asMap);
  }

  @override
  int get hashCode {
    return hashValues(
      key,
      label,
      icon,
      expanded,
      children,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Node &&
        other.key == key &&
        other.label == label &&
        other.icon == icon &&
        other.expanded == expanded &&
        other.data.runtimeType == T &&
        other.children.length == children.length;
  }
}
