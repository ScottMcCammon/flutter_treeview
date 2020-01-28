import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TreeView Example',
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
      Node(label: 'documents', key: 'docs', expanded: true, children: [
        Node(
            label: 'personal',
            key: 'd3',
            icon: NodeIcon.fromIconData(Icons.input),
            children: [
              Node(
                  label: 'Resume.docx',
                  key: 'pd1',
                  icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
              Node(
                  label: 'Cover Letter.docx',
                  key: 'pd2',
                  icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
            ]),
        Node(
          label: 'Inspection.docx',
          key: 'd1',
//          icon: NodeIcon.fromIconData(Icons.insert_drive_file),
        ),
        Node(
            label: 'Invoice.docx',
            key: 'd2',
            icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
      ]),
      Node(
          label: 'MeetingReport.xls',
          key: 'mrxls',
          icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
      Node(
          label: 'MeetingReport.pdf',
          key: 'mrpdf',
          icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
      Node(
          label: 'Demo.zip',
          key: 'demo',
          icon: NodeIcon.fromIconData(Icons.archive)),
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
      body: Container(
        padding: EdgeInsets.only(left: 5),
        child: TreeView(
          controller: _treeViewController,
          allowParentSelect: true,
          onExpansionChanged: (key, expanded) => _expandNode(key, expanded),
          onNodeSelect: (key) {
            debugPrint('Selected: $key');
            setState(() {
              _treeViewController =
                  _treeViewController.copyWith(selectedKey: key);
            });
          },
          theme: TreeViewTheme(
            arrowStyle: ArrowStyle.chevron,
//            style: TreeViewStyle.iOS,
            labelStyle: TextStyle(
//              fontFamily: 'Times',
              fontSize: 16,
              letterSpacing: 0.3,
            ),
            iconTheme: IconThemeData(
              size: 18,
              color: Colors.grey.shade800,
            ),
            colorScheme: Theme.of(context).brightness == Brightness.light
                ? ColorScheme.light(
                    primary: Colors.blue.shade50,
                    onPrimary: Colors.grey.shade900,
                    background: Colors.transparent,
                    onBackground: Colors.black,
                  )
                : ColorScheme.dark(
                    primary: Colors.black26,
                    onPrimary: Colors.white,
                    background: Colors.transparent,
                    onBackground: Colors.white70,
                  ),
          ),
        ),
      ),
    );
  }

  _expandNode(String key, bool expanded) {
    debugPrint('${expanded ? "Expanded" : "Collapsed"}: $key');
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
