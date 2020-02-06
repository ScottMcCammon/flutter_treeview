import 'dart:convert';

import 'models/node.dart';

/// Defines the insertion mode adding a new [Node] to the [TreeView].
enum InsertMode {
  prepend,
  append,
  insert,
}

/// Defines the controller needed to display the [TreeView].
///
/// Used by [TreeView] to display the nodes and selected node.
///
/// This class also defines methods used to manipulate data in
/// the [TreeView]. The methods ([addNode], [updateNode],
/// and [deleteNode]) are non-mutilating, meaning they will not
/// modify the tree but instead they will return a mutilated
/// copy of the data. You can then use your own logic to appropriately
/// update the [TreeView]. e.g.
///
/// ```dart
/// TreeViewController controller = TreeViewController(children: nodes);
/// Node node = controller.getNode('unique_key');
/// Node updatedNode = node.copyWith(
///   key: 'another_unique_key',
///   label: 'Another Node',
/// );
/// List<Node> newChildren = controller.updateNode(node.key, updatedNode);
/// controller = TreeViewController(children: newChildren);
/// ```
class TreeViewController {
  /// The data for the [TreeView].
  final List<Node> children;

  /// The key of the select node in the [TreeView].
  final String selectedKey;

  TreeViewController({
    this.children: const [],
    this.selectedKey,
  });

  /// Creates a copy of this controller but with the given fields
  /// replaced with the new values.
  TreeViewController copyWith({List<Node> children, String selectedKey}) {
    return TreeViewController(
      children: children ?? this.children,
      selectedKey: selectedKey ?? this.selectedKey,
    );
  }

  /// Gets the node that has a key value equal to the specified key.
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

  /// Gets the parent of the node identified by specified key.
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

  /// Adds a new node to a node identified by specified key. It optionally
  /// accepts an [InsertMode] and index. If no [InsertMode] is specified,
  /// it appends the new node as a child at the end. This method returns
  /// a new list with the added node.
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
        List<Node> _children = child.children.toList(growable: true);
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

  /// Updates an existing node identified by specified key. This method
  /// returns a new list with the updated node.
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

  /// Deletes an existing node identified by specified key. This method
  /// returns a new list with the specified node removed.
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

  /// Map representation of this object
  List<Map<String, dynamic>> get asMap {
    return children.map((Node child) => child.asMap).toList();
  }

  @override
  String toString() {
    return JsonEncoder().convert(asMap);
  }
}
