import 'package:flutter/widgets.dart';

const double _kDefaultExpanderSize = 18.0;

enum ExpanderPosition {
  start,
  end,
}

enum ExpanderType {
  arrow,
  caret,
  chevron,
  circleChevron,
  circleChevronOutline,
  circlePlusMinus,
  circlePlusMinusOutline,
  plusMinus,
  squareChevron,
  squareChevronOutline,
  squarePlusMinus,
  squarePlusMinusOutline,
}

class ExpanderThemeData {
  final ExpanderPosition position;
  final ExpanderType type;
  final double size;
  final Color color;

  const ExpanderThemeData({this.color, this.position, this.type, this.size});

  const ExpanderThemeData.fallback()
      : color = const Color(0xFF000000),
        position = ExpanderPosition.start,
        type = ExpanderType.caret,
        size = _kDefaultExpanderSize;

  ExpanderThemeData copyWith(
      {Color color,
      ExpanderType type,
      ExpanderPosition position,
      double size}) {
    return ExpanderThemeData(
      color: color ?? this.color,
      type: type ?? this.type,
      position: position ?? this.position,
      size: size ?? this.size,
    );
  }

  ExpanderThemeData merge(ExpanderThemeData other) {
    if (other == null) return this;
    return copyWith(
      color: other.color,
      type: other.type,
      position: other.position,
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
        other.size == size;
  }

  @override
  int get hashCode => hashValues(color, position, type, size);
}
