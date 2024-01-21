// Copyright 2024 Yoshinori Tagawa. All rights reserved.

// 格子図データクラス

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'scope_functions.dart';

const _currentVersion = 1;

/// 単位図形形状
enum TileShape {
  square,
  hexagon;

//<editor-fold desc="Data Methods">
  dynamic toEncodable() {
    return index;
  }

  factory TileShape.fromEncodable(dynamic value) {
    final index = value as int;
    assert(index >= 0 && index < values.length);
    return TileShape.values[index];
  }
//</editor-fold>
}

/// 地形タイプ
enum LandType {
  floor,
  rock,
  water,
  air;

//<editor-fold desc="Data Methods">
  dynamic toEncodable() {
    return index;
  }

  factory LandType.fromEncodable(dynamic value) {
    final index = value as int;
    assert(index >= 0 && index < values.length);
    return LandType.values[index];
  }
//</editor-fold>
}

/// 地形特徴
/// 隣に接続可能な特徴や地形があると接続する。
enum LandFeature {
  none,
  river,
  road,
  castle,
  bridge,
  watergate,
  gate;

//<editor-fold desc="Data Methods">
  dynamic toEncodable() {
    return index;
  }

  factory LandFeature.fromEncodable(dynamic value) {
    final index = value as int;
    assert(index >= 0 && index < values.length);
    return LandFeature.values[index];
  }
//</editor-fold>
}

/// 壁タイプ
enum WallType {
  path,
  wall,
  door;

//<editor-fold desc="Data Methods">
  dynamic toEncodable() {
    return index;
  }

  factory WallType.fromEncodable(dynamic value) {
    final index = value as int;
    assert(index >= 0 && index < values.length);
    return WallType.values[index];
  }
//</editor-fold>
}

extension _WallTypeListHelper on List<WallType> {
  dynamic toEncodable() {
    return List.generate(length, (index) => this[index].toEncodable());
  }

  static List<WallType> fromEncodable(dynamic value) {
    final list = value as List<dynamic>;
    return List.generate(list.length, (index) => WallType.fromEncodable(list[index]));
  }
}

/// マーク
enum Mark {
  none,
  mark1,
  mark2,
  mark3,
  mark4,
  mark5,
  mark6,
  mark7,
  mark8,
  mark9;

//<editor-fold desc="Data Methods">
  dynamic toEncodable() {
    return index;
  }

  factory Mark.fromEncodable(dynamic value) {
    final index = value as int;
    assert(index >= 0 && index < values.length);
    return Mark.values[index];
  }
//</editor-fold>
}

extension _MarkListHelper on List<Mark> {
  dynamic toEncodable() {
    return List.generate(length, (index) => this[index].toEncodable());
  }

  static List<Mark> fromEncodable(dynamic value) {
    final list = value as List<dynamic>;
    return List.generate(list.length, (index) => Mark.fromEncodable(list[index]));
  }
}

/// 小属性値
/// タイルごとに0~3の数値に対応する属性値を持たせることができる。遭遇率とかダークゾーンとか。
enum Titbit {
  none,
  v1,
  v2,
  v3;

//<editor-fold desc="Data Methods">
  dynamic toEncodable() {
    return index;
  }

  factory Titbit.fromEncodable(dynamic value) {
    final index = value as int;
    assert(index >= 0 && index < values.length);
    return Titbit.values[index];
  }
//</editor-fold>
}

extension _TitbitListHelper on List<Titbit> {
  dynamic toEncodable() {
    return List.generate(length, (index) => this[index].toEncodable());
  }

  static List<Titbit> fromEncodable(dynamic value) {
    final list = value as List<dynamic>;
    return List.generate(list.length, (index) => Titbit.fromEncodable(list[index]));
  }
}

/// 単位図形データクラス
@immutable
class TileData {
  /// 方向の最大数（1タイルの壁の数）
  static const dirCount = 6; // N, (N)E, S, (N)W, SE, SW,
  /// 小属性値の数
  static const titbitCount = 3;

  final LandType landType;
  final LandFeature landFeature;
  final List<WallType> _wallTypes;
  final Mark landMark;
  final List<Mark> _wallMarks;
  final List<Titbit> _titbits;

  TileData({
    this.landType = LandType.floor,
    this.landFeature = LandFeature.none,
    List<WallType>? wallTypes,
    this.landMark = Mark.none,
    List<Mark>? wallMarks,
    List<Titbit>? titbits,
  })  : _wallTypes = (wallTypes == null)
            ? List.generate(dirCount, (_) => WallType.path)
            : wallTypes.also((it) {
                assert(it.length == dirCount);
              }),
        _wallMarks = (wallMarks == null)
            ? List.generate(dirCount, (_) => Mark.none)
            : wallMarks.also((it) {
                assert(it.length == dirCount);
              }),
        _titbits = (titbits == null)
            ? List.generate(titbitCount, (_) => Titbit.none)
            : titbits.also((it) {
                assert(it.length == titbitCount);
              });

  /// 壁タイプ[`dir`]
  WallType getWallType(int dir) {
    assert(dir >= 0 && dir < dirCount);
    return _wallTypes[dir];
  }

  /// 壁タイプ[`dir`]を変更したコピー
  TileData copyWithWallType(int dir, WallType newValue) {
    assert(dir >= 0 && dir < dirCount);
    final newWallTypes = [..._wallTypes];
    newWallTypes[dir] = newValue;
    return copyWith(wallTypes: newWallTypes);
  }

  /// 壁マーク[`dir`]
  Mark getWallMark(int dir) {
    assert(dir >= 0 && dir < dirCount);
    return _wallMarks[dir];
  }

  /// 壁マーク[`dir`]を変更したコピー
  TileData copyWithWallMark(int dir, Mark newValue) {
    assert(dir >= 0 && dir < dirCount);
    final newWallMarks = [..._wallMarks];
    newWallMarks[dir] = newValue;
    return copyWith(wallMarks: newWallMarks);
  }

  /// 小属性値[`index`]
  Titbit getTitbit(int index) {
    assert(index >= 0 && index < titbitCount);
    return _titbits[index];
  }

  /// 小属性値[`index`]を変更したコピー
  TileData copyWithTitbit(int index, Titbit newValue) {
    assert(index >= 0 && index < titbitCount);
    final newTitbits = [..._titbits];
    newTitbits[index] = newValue;
    return copyWith(titbits: newTitbits);
  }

//<editor-fold desc="Data Methods">
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TileData &&
          runtimeType == other.runtimeType &&
          landType == other.landType &&
          landFeature == other.landFeature &&
          _wallTypes == other._wallTypes &&
          landMark == other.landMark &&
          _wallMarks == other._wallMarks &&
          _titbits == other._titbits);

  @override
  int get hashCode =>
      landType.hashCode ^
      landFeature.hashCode ^
      _wallTypes.hashCode ^
      landMark.hashCode ^
      _wallMarks.hashCode ^
      _titbits.hashCode;

  @override
  String toString() {
    return 'TileData{'
        ' landType: $landType,'
        ' landFeature: $landFeature,'
        ' _wallTypes: $_wallTypes,'
        ' landMark: $landMark,'
        ' _wallMarks: $_wallMarks,'
        ' _titbits: $_titbits,'
        '}';
  }

  TileData copyWith({
    LandType? landType,
    LandFeature? landFeature,
    List<WallType>? wallTypes,
    Mark? landMark,
    List<Mark>? wallMarks,
    List<Titbit>? titbits,
  }) {
    return TileData(
      landType: landType ?? this.landType,
      landFeature: landFeature ?? this.landFeature,
      wallTypes: wallTypes ?? _wallTypes,
      landMark: landMark ?? this.landMark,
      wallMarks: wallMarks ?? _wallMarks,
      titbits: titbits ?? _titbits,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'landType': landType.toEncodable(),
      'landFeature': landFeature.toEncodable(),
      'wallTypes': _wallTypes.toEncodable(),
      'landMark': landMark.toEncodable(),
      'wallMarks': _wallMarks.toEncodable(),
      'titbits': _titbits.toEncodable(),
    };
  }

  factory TileData.fromMap(Map<String, dynamic> map) {
    return TileData(
      landType: LandType.fromEncodable(map['landType']),
      landFeature: LandFeature.fromEncodable(map['landFeature']),
      wallTypes: _WallTypeListHelper.fromEncodable(map['wallTypes']),
      landMark: Mark.fromEncodable(map['landMark']),
      wallMarks: _MarkListHelper.fromEncodable(map['wallMarks']),
      titbits: _TitbitListHelper.fromEncodable(map['titbits']),
    );
  }

//</editor-fold>
}

extension _TileListHelper on List<TileData> {
  dynamic toMap() {
    return List.generate(length, (index) => this[index].toMap());
  }

  static List<TileData> fromMap(dynamic value) {
    final list = value as List<dynamic>;
    return List.generate(
      list.length,
      (index) => TileData.fromMap(list[index] as Map<String, dynamic>),
    );
  }
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

  /// 単位図形[`row`][`column`]
  TileData getTile(int column, int row) {
    assert(column >= 0 && column < columnCount);
    assert(row >= 0 && row < rowCount);
    return _tiles[row * rowCount + column];
  }

  /// 単位図形[`row`][`column`]を変更したコピー
  GridData copyWithTile(int column, int row, TileData tileData) {
    assert(column >= 0 && column < columnCount);
    assert(row >= 0 && row < rowCount);
    final newTiles = [..._tiles];
    newTiles[row * rowCount + column] = tileData;
    return copyWith(tiles: newTiles);
  }

  /// 単位図形[`row`][`column`]の壁タイプ[`dir`]およびその背面を変更したコピー
  GridData copyWithWallType(
    int column,
    int row,
    int dir,
    WallType newWallType, {
    required bool bothSides,
  }) {
    // todo:6角形
    assert(tileShape == TileShape.square);

    assert(column >= 0 && column < columnCount);
    assert(row >= 0 && row < rowCount);
    final newTiles = [..._tiles];
    switch (dir) {
      case 0: // 北
        newTiles[row * rowCount + column] = getTile(column, row).copyWithWallType(0, newWallType);
        if (bothSides && row > 0) {
          newTiles[(row - 1) * rowCount + column] =
              getTile(column, row - 1).copyWithWallType(2, newWallType);
        }
        break;
      case 1: // 東
        newTiles[row * rowCount + column] = getTile(column, row).copyWithWallType(1, newWallType);
        if (bothSides && column < columnCount - 1) {
          newTiles[row * rowCount + (column + 1)] =
              getTile(column + 1, row).copyWithWallType(3, newWallType);
        }
        break;
      case 2: // 南
        newTiles[row * rowCount + column] = getTile(column, row).copyWithWallType(2, newWallType);
        if (bothSides && row < rowCount - 1) {
          newTiles[(row + 1) * rowCount + column] =
              getTile(column, row + 1).copyWithWallType(0, newWallType);
        }
        break;
      default: // 西
        newTiles[row * rowCount + column] = getTile(column, row).copyWithWallType(3, newWallType);
        if (bothSides && column > 0) {
          newTiles[row * rowCount + (column - 1)] =
              getTile(column - 1, row).copyWithWallType(1, newWallType);
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
    TileShape? tileShape,
    int? columnCount,
    int? rowCount,
    List<TileData>? tiles,
    List<String>? landTypeNames,
    List<String>? wallTypeNames,
    Map<String, String>? gridProperties,
  }) {
    return GridData(
      version: version ?? this.version,
      tileShape: tileShape ?? this.tileShape,
      columnCount: columnCount ?? this.columnCount,
      rowCount: rowCount ?? this.rowCount,
      tiles: tiles ?? _tiles,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'version': version,
      'tileShape': tileShape.toEncodable(),
      'columnCount': columnCount,
      'rowCount': rowCount,
      'tiles': _tiles.toMap(),
    };
  }

  factory GridData.fromMap(Map<String, dynamic> map) {
    return GridData(
      version: map['version'] as int,
      tileShape: TileShape.fromEncodable(map['tileShape']),
      columnCount: map['columnCount'] as int,
      rowCount: map['rowCount'] as int,
      tiles: _TileListHelper.fromMap(map['tiles']),
    );
  }

//</editor-fold>
}
