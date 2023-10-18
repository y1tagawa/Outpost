import 'package:vector_math/vector_math_64.dart';

//
// メッシュ
//

class FaceVertex {
  final int vertexIndex;
  final int textureVertexIndex;
  final int normalIndex;

  const FaceVertex(
    this.vertexIndex,
    this.textureVertexIndex,
    this.normalIndex,
  );

//<editor-fold desc="Data Methods">
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FaceVertex &&
          runtimeType == other.runtimeType &&
          vertexIndex == other.vertexIndex &&
          textureVertexIndex == other.textureVertexIndex &&
          normalIndex == other.normalIndex);

  @override
  int get hashCode => vertexIndex.hashCode ^ textureVertexIndex.hashCode ^ normalIndex.hashCode;

  @override
  String toString() {
    return 'FaceVertex{'
        ' vertexIndex: $vertexIndex,'
        ' materialIndex: $textureVertexIndex,'
        ' normalIndex: $normalIndex,'
        '}';
  }

//</editor-fold>
}

class Face {
  final List<FaceVertex> vertices;
  final String materialName;

  const Face({
    required this.vertices,
    this.materialName = '',
  });

//<editor-fold desc="Data Methods">
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Face &&
          runtimeType == other.runtimeType &&
          vertices == other.vertices &&
          materialName == other.materialName);

  @override
  int get hashCode => vertices.hashCode ^ materialName.hashCode;

  @override
  String toString() {
    return 'Face{ vertices: $vertices, materialName: $materialName,}';
  }

//</editor-fold>
}

class MeshObject {
  final List<Face> faces;
  final String name;
  final String materialName;

  const MeshObject({
    required this.faces,
    this.name = '',
    this.materialName = '',
  });

//<editor-fold desc="Data Methods">
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeshObject &&
          runtimeType == other.runtimeType &&
          faces == other.faces &&
          name == other.name &&
          materialName == other.materialName);

  @override
  int get hashCode => faces.hashCode ^ name.hashCode ^ materialName.hashCode;

  @override
  String toString() {
    return 'MeshObject{ faces: $faces, name: $name, material: $materialName,}';
  }

//</editor-fold>
}

/// メッシュ
///
class Mesh {
  final List<Vector3> vertices;
  final List<Vector3> textureVertices;
  final List<Vector3> normals;
  final List<MeshObject> objects;

  const Mesh({
    this.vertices = const [],
    this.textureVertices = const [],
    this.normals = const [],
    this.objects = const [],
  });

//<editor-fold desc="Data Methods">
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Mesh &&
          runtimeType == other.runtimeType &&
          vertices == other.vertices &&
          normals == other.normals &&
          textureVertices == other.textureVertices &&
          objects == other.objects);

  @override
  int get hashCode =>
      vertices.hashCode ^ normals.hashCode ^ textureVertices.hashCode ^ objects.hashCode;

  @override
  String toString() {
    return 'Mesh{'
        ' vertices: $vertices,'
        ' normals: $normals,'
        ' materials: $textureVertices,'
        ' objects: $objects,'
        '}';
  }

//</editor-fold>
}

/// 直方体ビルダ
///
class CubeBuilder {
  static final _vertices = <Vector3>[
    Vector3(1.000000, 1.000000, -1.000000),
    Vector3(1.000000, -1.000000, -1.000000),
    Vector3(1.000000, 1.000000, 1.000000),
    Vector3(1.000000, -1.000000, 1.000000),
    Vector3(-1.000000, 1.000000, -1.000000),
    Vector3(-1.000000, -1.000000, -1.000000),
    Vector3(-1.000000, 1.000000, 1.000000),
    Vector3(-1.000000, -1.000000, 1.000000),
  ];

  static final _textureVertices = <Vector3>[
    Vector3(0.625000, 0.500000, 0),
    Vector3(0.875000, 0.500000, 0),
    Vector3(0.875000, 0.750000, 0),
    Vector3(0.625000, 0.750000, 0),
    Vector3(0.375000, 0.750000, 0),
    Vector3(0.625000, 1.000000, 0),
    Vector3(0.375000, 1.000000, 0),
    Vector3(0.375000, 0.000000, 0),
    Vector3(0.625000, 0.000000, 0),
    Vector3(0.625000, 0.250000, 0),
    Vector3(0.375000, 0.250000, 0),
    Vector3(0.125000, 0.500000, 0),
    Vector3(0.375000, 0.500000, 0),
    Vector3(0.125000, 0.750000, 0),
  ];

  static final _normals = <Vector3>[
    Vector3(0.0000, 1.0000, 0.0000),
    Vector3(0.0000, 0.0000, 1.0000),
    Vector3(-1.0000, 0.0000, 0.0000),
    Vector3(0.0000, -1.0000, 0.0000),
    Vector3(1.0000, 0.0000, 0.0000),
    Vector3(0.0000, 0.0000, -1.0000),
  ];

  static const _faces = <Face>[
    Face(vertices: [
      FaceVertex(1, 1, 1),
      FaceVertex(5, 2, 1),
      FaceVertex(7, 3, 1),
      FaceVertex(3, 4, 1),
    ]),
    Face(vertices: [
      FaceVertex(4, 5, 2),
      FaceVertex(3, 4, 2),
      FaceVertex(7, 6, 2),
      FaceVertex(8, 7, 2),
    ]),
    Face(vertices: [
      FaceVertex(8, 8, 3),
      FaceVertex(7, 9, 3),
      FaceVertex(5, 10, 3),
      FaceVertex(6, 11, 3),
    ]),
    Face(vertices: [
      FaceVertex(6, 12, 4),
      FaceVertex(2, 13, 4),
      FaceVertex(4, 5, 4),
      FaceVertex(8, 14, 4)
    ]),
    Face(vertices: [
      FaceVertex(2, 13, 5),
      FaceVertex(1, 1, 5),
      FaceVertex(3, 4, 5),
      FaceVertex(4, 5, 5),
    ]),
    Face(vertices: [
      FaceVertex(6, 11, 6),
      FaceVertex(5, 10, 6),
      FaceVertex(1, 1, 6),
      FaceVertex(2, 13, 6),
    ]),
  ];

  const CubeBuilder();

  Mesh toMesh({
    Vector3? offset,
    Vector3? scale,
    String objectName = '',
    String materialName = '',
  }) {
    offset ??= Vector3.zero();
    scale ??= Vector3.all(1);
    final vertices = <Vector3>[
      for (final vertex in _vertices)
        Vector3(
          vertex.x * scale.x + offset.x,
          vertex.y * scale.y + offset.y,
          vertex.z * scale.z + offset.z,
        ),
    ];
    return Mesh(
      vertices: vertices,
      textureVertices: _textureVertices,
      normals: _normals,
      objects: <MeshObject>[
        MeshObject(faces: _faces, name: objectName, materialName: materialName),
      ],
    );
  }
}
