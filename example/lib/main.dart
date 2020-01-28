import 'package:flutter/cupertino.dart';
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
  bool docsOpen = true;
  final Map<ExpanderPosition, Widget> expansionPositionOptions = const {
    ExpanderPosition.start: Text('Start'),
    ExpanderPosition.end: Text('End'),
  };
  final List<Map<String, dynamic>> _expanderStyleOptions = [
    {"value": ExpanderStyle.arrow, "label": "Arrow"},
    {"value": ExpanderStyle.box, "label": "Box"},
    {"value": ExpanderStyle.chevron, "label": "Chevron"},
    {"value": ExpanderStyle.circle, "label": "Circle"},
    {"value": ExpanderStyle.filledCircle, "label": "Filled Circle"},
    {"value": ExpanderStyle.longArrow, "label": "Long Arrow"},
  ];
  ExpanderPosition _expanderPosition = ExpanderPosition.start;
  bool _allowParentSelect = false;
  bool _supportParentDoubleTap = false;
  int _expanderStyleIndex = 0;

  @override
  void initState() {
    _nodes = [
      Node(
        label: 'documents',
        key: 'docs',
        expanded: docsOpen,
        icon: NodeIcon(
          codePoint:
              docsOpen ? Icons.folder_open.codePoint : Icons.folder.codePoint,
          color: "blue",
        ),
        children: [
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
        ],
      ),
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

  ListTile _makeExpanderPosition() {
    return ListTile(
      title: Text('Expander Position'),
      trailing: CupertinoSlidingSegmentedControl(
        children: expansionPositionOptions,
        groupValue: _expanderPosition,
        onValueChanged: (ExpanderPosition newValue) {
          setState(() {
            _expanderPosition = newValue;
          });
        },
      ),
    );
  }

  SwitchListTile _makeAllowParentSelect() {
    return SwitchListTile.adaptive(
      title: Text('Allow Parent Select'),
      value: _allowParentSelect,
      onChanged: (v) {
        setState(() {
          _allowParentSelect = v;
        });
      },
    );
  }

  SwitchListTile _makeSupportParentDoubleTap() {
    return SwitchListTile.adaptive(
      title: Text('Support Parent Double Tap'),
      value: _supportParentDoubleTap,
      onChanged: (v) {
        setState(() {
          _supportParentDoubleTap = v;
        });
      },
    );
  }

  ListTile _makeExpanderType() {
    return ListTile(
      title: Text('Expander Style'),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              _expanderStyleOptions.elementAt(_expanderStyleIndex)['label'],
              style: Theme.of(context).textTheme.caption,
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
      onTap: () async {
        final int styleIndex = await showCupertinoDialog(
            context: context,
            builder: (context) {
              Map<int, Map<String, dynamic>> _options =
                  _expanderStyleOptions.asMap();
              return SimpleDialog(
                titlePadding: EdgeInsets.only(left: 10),
                title: Row(
                  children: <Widget>[
                    Expanded(child: Text('Expander Style')),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () =>
                          Navigator.pop(context, _expanderStyleIndex),
                    ),
                  ],
                ),
                children: _options.keys.map((int itemIndex) {
                  Map<String, dynamic> item =
                      _expanderStyleOptions.elementAt(itemIndex);
                  return SimpleDialogOption(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.check,
                          color: _expanderStyleIndex == itemIndex
                              ? Colors.blue
                              : Colors.transparent,
                        ),
                        Expanded(child: Text(item['label'])),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pop(context, itemIndex);
                    },
                  );
                }).toList(),
              );
            });
        if (styleIndex != null)
          setState(() {
            _expanderStyleIndex = styleIndex;
          });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey.shade200,
        padding: EdgeInsets.all(20),
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              child: Column(
                children: <Widget>[
                  _makeExpanderPosition(),
                  _makeAllowParentSelect(),
                  _makeSupportParentDoubleTap(),
                  _makeExpanderType(),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(10),
                child: TreeView(
                  controller: _treeViewController,
                  allowParentSelect: _allowParentSelect,
                  supportParentDoubleTap: _supportParentDoubleTap,
                  onExpansionChanged: (key, expanded) =>
                      _expandNode(key, expanded),
                  onNodeSelect: (key) {
                    debugPrint('Selected: $key');
                    setState(() {
                      _treeViewController =
                          _treeViewController.copyWith(selectedKey: key);
                    });
                  },
                  theme: TreeViewTheme(
                    expanderStyle: _expanderStyleOptions
                        .elementAt(_expanderStyleIndex)['value'],
                    position: _expanderPosition,
                    labelStyle: TextStyle(
//              fontFamily: 'Times',
                      fontSize: 16,
                      letterSpacing: 0.3,
                    ),
                    iconTheme: IconThemeData(
                      size: 18,
                      color: Colors.grey.shade800,
                    ),
                    colorScheme:
                        Theme.of(context).brightness == Brightness.light
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
            ),
          ],
        ),
      ),
    );
  }

  _expandNode(String key, bool expanded) {
    String msg = '${expanded ? "Expanded" : "Collapsed"}: $key';
    debugPrint(msg);
    Node node = _treeViewController.getNode(key);
    if (node != null) {
      List<Node> updated;
      if (key == 'docs') {
        updated = _treeViewController.updateNode(
          key,
          node.copyWith(
              expanded: expanded,
              icon: NodeIcon(
                codePoint: expanded
                    ? Icons.folder_open.codePoint
                    : Icons.folder.codePoint,
                color: expanded ? "blue600" : "grey700",
              )),
        );
      } else {
        updated = _treeViewController.updateNode(
            key, node.copyWith(expanded: expanded));
      }
      setState(() {
        if (key == 'docs') docsOpen = expanded;
        _treeViewController = _treeViewController.copyWith(children: updated);
      });
    }
  }
}
