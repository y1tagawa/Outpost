import 'dart:ui';

import 'package:ditredi/ditredi.dart';
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
      // X+
      Vector3(bounds.max.x, bounds.min.y, bounds.min.z),
      Vector3(bounds.max.x, bounds.min.y, bounds.max.z),
      bounds.max,
      Vector3(bounds.max.x, bounds.max.y, bounds.min.z),
      // X-
      Vector3(bounds.min.x, bounds.min.y, bounds.max.z),
      bounds.min,
      Vector3(bounds.min.x, bounds.max.y, bounds.min.z),
      Vector3(bounds.min.x, bounds.max.y, bounds.max.z),
      // Y+
      Vector3(bounds.min.x, bounds.max.y, bounds.max.z),
      Vector3(bounds.min.x, bounds.max.y, bounds.min.z),
      Vector3(bounds.max.x, bounds.max.y, bounds.min.z),
      bounds.max,
      // Y-
      bounds.min,
      Vector3(bounds.min.x, bounds.min.y, bounds.max.z),
      Vector3(bounds.max.x, bounds.min.y, bounds.max.z),
      Vector3(bounds.max.x, bounds.min.y, bounds.min.z),
      // Z+
      bounds.min,
      Vector3(bounds.max.x, bounds.min.y, bounds.min.z),
      Vector3(bounds.max.x, bounds.max.y, bounds.min.z),
      Vector3(bounds.min.x, bounds.max.y, bounds.min.z),
      // Z-
      Vector3(bounds.min.x, bounds.min.y, bounds.max.z),
      Vector3(bounds.min.x, bounds.max.y, bounds.max.z),
      bounds.max,
      Vector3(bounds.max.x, bounds.min.y, bounds.max.z),
    ];
    return <Model3D>[
      // X+
      Face3D.fromVertices(p[0], p[1], p[2], color: color),
      Face3D.fromVertices(p[0], p[2], p[3], color: color),
      // X-
      Face3D.fromVertices(p[4], p[5], p[6], color: color),
      Face3D.fromVertices(p[4], p[6], p[7], color: color),
      // Y+
      Face3D.fromVertices(p[8], p[9], p[10], color: color),
      Face3D.fromVertices(p[8], p[10], p[11], color: color),
      // Y-
      Face3D.fromVertices(p[12], p[13], p[14], color: color),
      Face3D.fromVertices(p[12], p[14], p[15], color: color),
      // Z+
      Face3D.fromVertices(p[16], p[17], p[18], color: color),
      Face3D.fromVertices(p[16], p[18], p[19], color: color),
      // Z-
      Face3D.fromVertices(p[20], p[21], p[22], color: color),
      Face3D.fromVertices(p[20], p[22], p[23], color: color),
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
