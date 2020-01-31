import 'dart:convert';

import 'models/node.dart';

enum InsertMode {
  prepend,
  append,
  insert,
}

class TreeViewController {
  final List<Node> children;
  final String selectedKey;

  TreeViewController({
    this.children: const [],
    this.selectedKey,
  });

  TreeViewController copyWith({List<Node> children, String selectedKey}) {
    return TreeViewController(
      children: children ?? this.children,
      selectedKey: selectedKey ?? this.selectedKey,
    );
  }

  Node getNode(String key, {Node parent}) {
    Node _found;
    List<Node> _children = parent == null ? this.children : parent.children;
    Iterator iter = _children.iterator;
    while (iter.moveNext()) {
      Node child = iter.current;
      if (child.key == key) {
        _found = child;
        break;
      } else {
        if (child.isParent) {
          _found = this.getNode(key, parent: child);
          if (_found != null) {
            break;
          }
        }
      }
    }
    return _found;
  }

  Node getParent(String key, {Node parent}) {
    Node _found;
    List<Node> _children = parent == null ? this.children : parent.children;
    Iterator iter = _children.iterator;
    while (iter.moveNext()) {
      Node child = iter.current;
      if (child.key == key) {
        _found = parent ?? child;
        break;
      } else {
        if (child.isParent) {
          _found = this.getParent(key, parent: child);
          if (_found != null) {
            break;
          }
        }
      }
    }
    return _found;
  }

  List<Node> addNode(
    String key,
    Node newNode, {
    Node parent,
    InsertMode mode: InsertMode.append,
    int index,
  }) {
    List<Node> _children = parent == null ? this.children : parent.children;
    return _children.map((Node child) {
      if (child.key == key) {
        List<Node> _children = child.children;
        if (mode == InsertMode.prepend) {
          _children.insert(0, newNode);
        } else if (mode == InsertMode.insert) {
          _children.insert(index ?? _children.length, newNode);
        } else {
          _children.add(newNode);
        }
        return child.copyWith(children: _children);
      } else {
        return child.copyWith(
          children: addNode(
            key,
            newNode,
            parent: child,
            mode: mode,
            index: index,
          ),
        );
      }
    }).toList();
  }

  List<Node> updateNode(String key, Node newNode, {Node parent}) {
    List<Node> _children = parent == null ? this.children : parent.children;
    return _children.map((Node child) {
      if (child.key == key) {
        return newNode;
      } else {
        if (child.isParent) {
          return child.copyWith(
            children: updateNode(
              key,
              newNode,
              parent: child,
            ),
          );
        }
        return child;
      }
    }).toList();
  }

  List<Node> deleteNode(String key, {Node parent}) {
    List<Node> _children = parent == null ? this.children : parent.children;
    List<Node> _filteredChildren = [];
    Iterator iter = _children.iterator;
    while (iter.moveNext()) {
      Node child = iter.current;
      if (child.key != key) {
        if (child.isParent) {
          _filteredChildren.add(child.copyWith(
            children: deleteNode(key, parent: child),
          ));
        } else {
          _filteredChildren.add(child);
        }
      }
    }
    return _filteredChildren;
  }

  List<Map<String, dynamic>> get asMap {
    return children.map((Node child) => child.asMap).toList();
  }

  @override
  String toString() {
    return JsonEncoder().convert(asMap);
  }
}
