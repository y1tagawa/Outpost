import 'dart:ui';

import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';

class Quad3D extends Group3D {
  /// Points of the quad.
  final Quad quad;

  /// Face color. Defaults to [DiTreDiConfig] setting.
  final Color? color;

  /// Creates a face with the given points.
  Quad3D(this.quad, {this.color})
      : super([
          Face3D.fromVertices(quad.point0, quad.point1, quad.point2, color: color),
          Face3D.fromVertices(quad.point0, quad.point2, quad.point3, color: color),
        ]);

  /// Creates a face from vertices.
  factory Quad3D.fromVertices(
    Vector3 a,
    Vector3 b,
    Vector3 c,
    Vector3 d, {
    Color? color,
  }) {
    return Quad3D(Quad.points(a, b, c, d), color: color);
  }

  /// Copies the face.
  Quad3D copyWith({
    Quad? quad,
    Color? color,
  }) {
    return Quad3D(quad ?? this.quad, color: color ?? this.color);
  }

  @override
  Quad3D clone() {
    return Quad3D(Quad.copy(quad), color: color);
  }

  @override
  List<Line3D> toLines() {
    return [
      Line3D(quad.point0, quad.point1, color: color),
      Line3D(quad.point1, quad.point2, color: color),
      Line3D(quad.point2, quad.point3, color: color),
      Line3D(quad.point3, quad.point0, color: color),
    ];
  }

  @override
  List<Point3D> toPoints() => [
        Point3D(quad.point0, color: color),
        Point3D(quad.point1, color: color),
        Point3D(quad.point2, color: color),
        Point3D(quad.point3, color: color),
      ];

  @override
  Aabb3 getBounds() {
    return Aabb3.fromQuad(quad);
  }

  @override
  int get hashCode => Object.hash(quad, color);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Quad3D &&
            runtimeType == other.runtimeType &&
            quad == other.quad &&
            color == other.color;
  }
}
