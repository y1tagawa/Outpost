import 'dart:ui';

import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';

class Polygon3D extends Group3D {
  /// Points of the polygon.
  /// 面の場合、凸多角形しか対応していないので注意。
  final List<Vector3> points;
  final bool closed;

  /// Face color. Defaults to [DiTreDiConfig] setting.
  final Color? color;

  /// Creates a face with the given points.
  Polygon3D(this.points, {this.closed = true, this.color}) : super(_getFigures(points, color));

  static List<Model3D> _getFigures(List<Vector3> points, Color? color) {
    assert(points.length >= 3);
    return [
      for (int i = 0; i < points.length - 2; ++i)
        Face3D.fromVertices(points[i], points[i + 1], points[i + 2]),
    ];
  }

  /// Copies the face.
  Polygon3D copyWith({
    List<Vector3>? points,
    bool? closed,
    Color? color,
  }) {
    return Polygon3D(
      points ?? this.points,
      closed: closed ?? this.closed,
      color: color ?? this.color,
    );
  }

  @override
  Polygon3D clone() {
    return Polygon3D([...points], closed: closed, color: color);
  }

  @override
  List<Line3D> toLines() {
    assert(points.length >= 2);
    return [
      for (int i = 0; i < points.length - 1; ++i) Line3D(points[i], points[i + 1], color: color),
      if (closed) Line3D(points.last, points.first, color: color),
    ];
  }

  @override
  List<Point3D> toPoints() => [for (final point in points) Point3D(point, color: color)];

  @override
  int get hashCode => Object.hash(points, closed, color);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Polygon3D &&
            runtimeType == other.runtimeType &&
            points == other.points &&
            closed == other.closed &&
            color == other.color;
  }
}
