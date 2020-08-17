## [0.6.0+1]

### Added
* Added support for importing data property during JSON and Map load

## [0.5.0+1]

### Added
* Added support for using shrinkWrap, primary, and physics property on TreeView 

## [0.4.2+1]

### Added
* Added support for using external font packages

## [0.4.1+1]

### Updated
* Updated TreeView widget so that it inherits the ThemeData from context

## [0.4.0+1]

### Added
* Added expandToNode method to TreeViewController to support expanding all nodes down to specified node. Returns List<Node>.
* Added collapseToNode method to TreeViewController to support collapsing all nodes down to specified node. Returns List<Node>.
* Added withExpandToNode method to TreeViewController to support expanding all nodes down to specified node. Returns TreeViewController.
* Added withCollapseToNode method to TreeViewController to support expanding all nodes down to specified node. Returns TreeViewController.

## [0.3.0+1]

### Added
* Added generic data property to Node class to support the use of custom data

## [0.2.0+1]

### Updated
* Added animation controller dispose to TreeNode to prevent memory leaks

### Added
* Added new dense property to TreeViewTheme
* Added new loadJSON and loadMap convenience methods to TreeViewController for data loading
* Added new convenience methods to TreeViewController: toggleNode, withToggleNode, selectedNode

## [0.1.0+2]

### Updated
* Updated links to repository documentation
* Cleaned up warnings

## [0.0.4+1]

### Updated
* Added logic to update TreeNode when expanded programmatically
* Fixed issue with adding new node to a TreeNode with new children

## [0.0.3+7]

### Added
* Added api documentation

### Updated
* Added parentLabelStyle to TreeViewTheme to support separate styling for parent node

## [0.0.2+1]

### Added
* Added ExpanderModifier

### Updated
* Updated open source license
* Simplified ExpanderType
* Refactored TreeNodeExpander class and added animation to icon
* Updated default expander size

### Removed
* Removed custom TreeView font

## [0.0.1]

* Initial package release
