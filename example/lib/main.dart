import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TreeView Example',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'TreeView Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedNode;
  List<Node> _nodes;
  TreeViewController _treeViewController;

  @override
  void initState() {
    _nodes = [
      Node(label: 'documents', key: 'docs', children: [
        Node(label: 'personal', key: 'd3', children: [
          Node(label: 'Resume.docx', key: 'pd1'),
          Node(label: 'Cover Letter.docx', key: 'pd2'),
        ]),
        Node(label: 'Inspection.docx', key: 'd1'),
        Node(label: 'Invoice.docx', key: 'd2'),
      ]),
      Node(
        label: 'MeetingReport.xls',
        key: 'mrxls',
      ),
      Node(
        label: 'MeetingReport.pdf',
        key: 'mrpdf',
      ),
      Node(
        label: 'Demo.zip',
        key: 'demo',
      ),
    ];
    _treeViewController = TreeViewController(
      children: _nodes,
      selectedKey: _selectedNode,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: TreeView(
        controller: _treeViewController,
        allowParentSelect: true,
        onNodeCollapse: (key) => _expandNode(key, false),
        onNodeExpand: (key) => _expandNode(key, true),
        onNodeSelect: (key) {
          print('Selected: $key');
          setState(() {
            _treeViewController =
                _treeViewController.copyWith(selectedKey: key);
          });
        },
      ),
    );
  }

  _expandNode(String key, bool expanded) {
    print('${expanded ? "Expanded" : "Collapsed"}: $key');
    Node node = _treeViewController.getNode(key);
    if (node != null) {
      List<Node> updated = _treeViewController.updateNode(
          key, node.copyWith(expanded: expanded));
      setState(() {
        _treeViewController = _treeViewController.copyWith(children: updated);
      });
    }
  }
}
