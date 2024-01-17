// Copyright 2024 Yoshinori Tagawa. All rights reserved.

// 格子図データクラス

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'scope_functions.dart';

const _currentVersion = 1;

/// 単位図形形状
enum TileShape {
  square,
  hexagon,
}

/// 床タイプ
enum LandType { floor, rock, water, air }

/// 壁タイプ
enum WallType { path, wall, door }

/// 印
enum MarkType { none, mark1, mark2, mark3, mark4, mark5, mark6, mark7, mark8, mark9 }

/// タイル値
//enum TileType { none, tile1, tile2, tile3 }

/// 建造物、特殊地形
//enum BuildingType
//enum FeatureType { river, road, wall }

/// todo: ランダム遭遇危険度 このへんは色濃度か？
/// todo: 道、川、城壁などの連続地形bit

/// 単位図形データクラス
@immutable
class TileData {
  /// 方向の最大数（1ユニットの壁の数）
  static const dirCount = 6; // N, (N)E, S, (N)W, SE, SW,

  static const tileCount = 6;

  final LandType landType;
  final List<WallType> _wallTypes;
  final MarkType landMarkType;
  final List<MarkType> _wallMarkTypes;

  TileData({
    this.landType = LandType.floor,
    List<WallType>? wallTypes,
    this.landMarkType = MarkType.none,
    List<MarkType>? wallMarkTypes,
  })  : _wallTypes = (wallTypes == null)
            ? List.generate(dirCount, (_) => WallType.path)
            : wallTypes.also((it) {
                assert(it.length == dirCount);
              }),
        _wallMarkTypes = (wallMarkTypes == null)
            ? List.generate(dirCount, (_) => MarkType.none)
            : wallMarkTypes.also((it) {
                assert(it.length == dirCount);
              });

  WallType getWallType(int dir) => _wallTypes[dir];

  TileData setWallType(int dir, WallType newWallType) {
    final newWallTypes = [..._wallTypes];
    newWallTypes[dir] = newWallType;
    return copyWith(wallTypes: newWallTypes);
  }

  MarkType getWallMarkType(int dir) => _wallMarkTypes[dir];

  TileData setWallMarkType(int dir, MarkType newWallMarkType) {
    final newWallMarkTypes = [..._wallMarkTypes];
    newWallMarkTypes[dir] = newWallMarkType;
    return copyWith(wallMarkTypes: newWallMarkTypes);
  }

//<editor-fold desc="Data Methods">
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TileData &&
          runtimeType == other.runtimeType &&
          landType == other.landType &&
          _wallTypes == other._wallTypes &&
          landMarkType == other.landMarkType &&
          _wallMarkTypes == other._wallMarkTypes);

  @override
  int get hashCode =>
      landType.hashCode ^ _wallTypes.hashCode ^ landMarkType.hashCode ^ _wallMarkTypes.hashCode;

  @override
  String toString() {
    return 'UnitData{'
        ' landType: $landType,'
        ' _wallType: $_wallTypes,'
        ' landMarkType: $landMarkType,'
        ' _wallMarkType: $_wallMarkTypes,'
        '}';
  }

  TileData copyWith({
    LandType? landType,
    List<WallType>? wallTypes,
    MarkType? landMarkType,
    List<MarkType>? wallMarkTypes,
  }) {
    return TileData(
      landType: landType ?? this.landType,
      wallTypes: wallTypes ?? this._wallTypes,
      landMarkType: landMarkType ?? this.landMarkType,
      wallMarkTypes: wallMarkTypes ?? this._wallMarkTypes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'landType': this.landType,
      'wallTypes': this._wallTypes,
      'landMarkType': this.landMarkType,
      'wallMarkTypes': this._wallMarkTypes,
    };
  }

  factory TileData.fromMap(Map<String, dynamic> map) {
    return TileData(
      landType: map['landType'] as LandType,
      wallTypes: map['wallTypes'] as List<WallType>,
      landMarkType: map['landMarkType'] as MarkType,
      wallMarkTypes: map['wallMarkTypes'] as List<MarkType>,
    );
  }

//</editor-fold>
}

/// 格子図データクラス
@immutable
class GridData {
  final int version;
  final TileShape tileShape;
  final int columnCount;
  final int rowCount;
  final List<TileData> _tiles;

  GridData({
    this.version = _currentVersion,
    required this.tileShape,
    required this.columnCount,
    List<TileData>? tiles,
    required this.rowCount,
  }) : _tiles = (tiles == null)
            ? List.generate(columnCount * rowCount, (index) => TileData()).also((_) {
                assert(columnCount > 0 && rowCount > 0);
              })
            : tiles.also((_) {
                assert(columnCount > 0 && rowCount > 0);
                assert(tiles.length == columnCount * rowCount);
              });

  TileData getTile(int column, int row) {
    assert(column >= 0 && column < columnCount);
    assert(row >= 0 && row < rowCount);
    return _tiles[row * rowCount + column];
  }

  GridData setTile(int column, int row, TileData tileData) {
    assert(column >= 0 && column < columnCount);
    assert(row >= 0 && row < rowCount);
    final newTiles = [..._tiles];
    newTiles[row * rowCount + column] = tileData;
    return copyWith(tiles: newTiles);
  }

  /// 対面の壁も同時にセットする
  GridData setWallTypes(int column, int row, int dir, WallType newWallType) {
    // とりあえず正方形のみ
    assert(tileShape == TileShape.square);

    assert(column >= 0 && column < columnCount);
    assert(row >= 0 && row < rowCount);
    final newTiles = [..._tiles];
    switch (dir) {
      case 0: // 北
        newTiles[row * rowCount + column] = getTile(column, row).setWallType(0, newWallType);
        if (row > 0) {
          newTiles[(row - 1) * rowCount + column] =
              getTile(column, row - 1).setWallType(2, newWallType);
        }
        break;
      case 1: // 東
        newTiles[row * rowCount + column] = getTile(column, row).setWallType(1, newWallType);
        if (column < columnCount - 1) {
          newTiles[row * rowCount + (column + 1)] =
              getTile(column + 1, row).setWallType(3, newWallType);
        }
        break;
      case 2: // 南
        newTiles[row * rowCount + column] = getTile(column, row).setWallType(2, newWallType);
        if (row < rowCount - 1) {
          newTiles[(row + 1) * rowCount + column] =
              getTile(column, row + 1).setWallType(0, newWallType);
        }
        break;
      default: // 西
        newTiles[row * rowCount + column] = getTile(column, row).setWallType(3, newWallType);
        if (column > 0) {
          newTiles[row * rowCount + (column - 1)] =
              getTile(column - 1, row).setWallType(1, newWallType);
        }
        break;
    }
    return copyWith(tiles: newTiles);
  }

//<editor-fold desc="Data Methods">
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GridData &&
          version == other.version &&
          runtimeType == other.runtimeType &&
          tileShape == other.tileShape &&
          columnCount == other.columnCount &&
          rowCount == other.rowCount &&
          _tiles == other._tiles);

  @override
  int get hashCode =>
      version.hashCode ^
      tileShape.hashCode ^
      columnCount.hashCode ^
      rowCount.hashCode ^
      _tiles.hashCode;

  @override
  String toString() {
    return 'GridData{'
        ' tileShale: $tileShape,'
        ' version: $version,'
        ' columnCount: $columnCount,'
        ' rowCount: $rowCount,'
        ' _tiles: $_tiles,'
        '}';
  }

  GridData copyWith({
    int? version,
    TileShape? tileShale,
    int? columnCount,
    int? rowCount,
    List<TileData>? tiles,
    List<String>? landTypeNames,
    List<String>? wallTypeNames,
    Map<String, String>? gridProperties,
  }) {
    return GridData(
      version: version ?? this.version,
      tileShape: tileShale ?? this.tileShape,
      columnCount: columnCount ?? this.columnCount,
      rowCount: rowCount ?? this.rowCount,
      tiles: tiles ?? this._tiles,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'version': this.version,
      'tileShale': this.tileShape,
      'columnCount': this.columnCount,
      'rowCount': this.rowCount,
      'tiles': this._tiles,
    };
  }

  factory GridData.fromMap(Map<String, dynamic> map) {
    return GridData(
      version: map['version'] as int,
      tileShape: map['tileShale'] as TileShape,
      columnCount: map['columnCount'] as int,
      rowCount: map['rowCount'] as int,
      tiles: map['tiles'] as List<TileData>,
    );
  }

//</editor-fold>
}
