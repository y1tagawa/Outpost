import 'dart:ui';

import 'package:ditredi/ditredi.dart';
import 'package:hello_flutter_ditredi/quad3d.dart';
import 'package:vector_math/vector_math_64.dart';

/// A 3D cuboid.
class Box3D extends Group3D {
  /// Cube size.
  final Aabb3 bounds;

  /// Cube color. Defaults to [DiTreDiConfig] setting.
  final Color? color;

  /// Creates a cube.
  Box3D(this.bounds, {this.color}) : super(_getFigures(bounds, color));

  static List<Model3D> _getFigures(Aabb3 bounds, Color? color) {
    final p = <Vector3>[
      Vector3(bounds.max.x, bounds.max.y, bounds.min.z),
      Vector3(bounds.max.x, bounds.min.y, bounds.min.z),
      bounds.max,
      Vector3(bounds.max.x, bounds.min.y, bounds.max.z),
      Vector3(bounds.min.x, bounds.max.y, bounds.min.z),
      bounds.min,
      Vector3(bounds.min.x, bounds.max.y, bounds.max.z),
      Vector3(bounds.min.x, bounds.min.y, bounds.max.z),
    ];
    return <Model3D>[
      // Face3D.fromVertices(p[0], p[6], p[4], color: color),
      // Face3D.fromVertices(p[0], p[2], p[6], color: color),
      // Face3D.fromVertices(p[3], p[6], p[2], color: color),
      // Face3D.fromVertices(p[3], p[7], p[6], color: color),
      // Face3D.fromVertices(p[7], p[4], p[6], color: color),
      // Face3D.fromVertices(p[7], p[5], p[4], color: color),
      // Face3D.fromVertices(p[5], p[3], p[1], color: color),
      // Face3D.fromVertices(p[5], p[7], p[3], color: color),
      // Face3D.fromVertices(p[1], p[2], p[0], color: color),
      // Face3D.fromVertices(p[1], p[3], p[2], color: color),
      // Face3D.fromVertices(p[5], p[0], p[4], color: color),
      // Face3D.fromVertices(p[5], p[1], p[0], color: color),
      Quad3D.fromVertices(p[0], p[2], p[6], p[4]),
      Quad3D.fromVertices(p[3], p[7], p[6], p[2]),
      Quad3D.fromVertices(p[7], p[5], p[4], p[6]),
      Quad3D.fromVertices(p[5], p[7], p[3], p[1]),
      Quad3D.fromVertices(p[1], p[3], p[2], p[0]),
      Quad3D.fromVertices(p[5], p[1], p[0], p[4]),
    ];
  }

  @override
  Group3D clone() {
    return Box3D(bounds, color: color);
  }

  /// Copies the cube.
  Box3D copyWith({
    Aabb3? bounds,
    Color? color,
  }) {
    return Box3D(
      bounds ?? this.bounds,
      color: color ?? this.color,
    );
  }

  @override
  int get hashCode => Object.hash(bounds, color);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Box3D &&
            runtimeType == other.runtimeType &&
            bounds == other.bounds &&
            color == other.color;
  }
}
