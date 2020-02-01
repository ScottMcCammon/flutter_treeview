import 'package:flutter/widgets.dart';

const double _kDefaultExpanderSize = 30.0;

enum ExpanderPosition {
  start,
  end,
}

enum ExpanderType {
  caret,
  arrow,
  chevron,
  plusMinus,
}

enum ExpanderModifier {
  none,
  circleFilled,
  circleOutlined,
  squareFilled,
  squareOutlined,
}

class ExpanderThemeData {
  final ExpanderPosition position;
  final ExpanderType type;
  final double size;
  final Color color;
  final ExpanderModifier modifier;
  final bool animated;

  const ExpanderThemeData({
    this.color: const Color(0xFF000000),
    this.position: ExpanderPosition.start,
    this.type: ExpanderType.caret,
    this.size: _kDefaultExpanderSize,
    this.modifier: ExpanderModifier.none,
    this.animated: true,
  });

  const ExpanderThemeData.fallback()
      : color = const Color(0xFF000000),
        position = ExpanderPosition.start,
        type = ExpanderType.caret,
        modifier = ExpanderModifier.none,
        animated = true,
        size = _kDefaultExpanderSize;

  ExpanderThemeData copyWith({
    Color color,
    ExpanderType type,
    ExpanderPosition position,
    ExpanderModifier modifier,
    bool animated,
    double size,
  }) {
    return ExpanderThemeData(
      color: color ?? this.color,
      type: type ?? this.type,
      position: position ?? this.position,
      modifier: modifier ?? this.modifier,
      size: size ?? this.size,
      animated: animated ?? this.animated,
    );
  }

  ExpanderThemeData merge(ExpanderThemeData other) {
    if (other == null) return this;
    return copyWith(
      color: other.color,
      type: other.type,
      position: other.position,
      modifier: other.modifier,
      animated: other.animated,
      size: other.size,
    );
  }

  ExpanderThemeData resolve(BuildContext context) => this;

  bool get isConcrete => color != null && size != null;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is ExpanderThemeData &&
        other.color == color &&
        other.position == position &&
        other.type == type &&
        other.modifier == modifier &&
        other.animated == animated &&
        other.size == size;
  }

  @override
  int get hashCode =>
      hashValues(color, position, type, size, modifier, animated);
}
