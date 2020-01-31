import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_treeview/src/utilities.dart';

import 'node_icon.dart';

class Node {
  final String key;
  final String label;
  final NodeIcon icon;
  final bool expanded;
  final List<Node> children;

  Node({
    @required this.key,
    @required this.label,
    this.children: const [],
    this.expanded: false,
    this.icon,
  })  : assert(key != null),
        assert(label != null);

  factory Node.fromLabel(String label) {
    String _key = Utilities.generateRandom();
    return Node(
      key: _key,
      label: label,
    );
  }

  factory Node.fromMap(Map<String, dynamic> map) {
    String _key = map['key'];
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
      key: _key,
      label: map['label'] ?? '',
      icon: _icon,
      expanded: Utilities.truthful(map['expanded']),
      children: _children,
    );
  }

  Node copyWith({
    String key,
    String label,
    List<Node> children,
    bool expanded,
    NodeIcon icon,
  }) =>
      Node(
        key: key ?? this.key,
        label: label ?? this.label,
        icon: icon ?? this.icon,
        expanded: expanded ?? this.expanded,
        children: children ?? this.children,
      );

  bool get isParent => children.isNotEmpty;

  bool get hasIcon => icon != null && icon.icon != null;

  Map<String, dynamic> get asMap => {
        "key": key,
        "label": label,
        "icon": icon == null ? null : icon.asMap,
        "expanded": expanded,
        "children": children.map((Node child) => child.asMap).toList(),
      };

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
        other.children.length == children.length;
  }
}
