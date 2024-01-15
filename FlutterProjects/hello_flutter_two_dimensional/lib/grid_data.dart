// Copyright 2024 Yoshinori Tagawa. All rights reserved.

// 格子図データクラス

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'scope_functions.dart';

const _currentVersion = 1;

const _maxDirection = 6;

/// 単位図形形状
enum UnitShape {
  square,
  hexagon,
}

/// 床タイプ
enum LandType { rock, floor, water, air }

/// 壁タイプ
enum WallType { wall, path, door }

/// 地図上の印
enum MarkType { none, mark1, mark2, mark3, mark4, mark5, mark6, mark7, mark8, mark9 }

/// 単位図形データクラス
@immutable
class UnitData {
  final LandType landType;
  final List<WallType> _wallTypes; // N, (N)E, S, (N)W, SE, SW,
  final MarkType landMarkType;
  final List<MarkType> _wallMarkTypes; // =

  WallType getWall(int dir) => _wallTypes[dir];

  UnitData setWall(int dir, WallType newWallType) {
    final newWallTypes = [..._wallTypes];
    newWallTypes[dir] = newWallType;
    return copyWith(wallTypes: newWallTypes);
  }

  MarkType getWallMark(int dir) => _wallMarkTypes[dir];

  UnitData setWallMark(int dir, MarkType newWallMarkType) {
    final newWallMarkTypes = [..._wallMarkTypes];
    newWallMarkTypes[dir] = newWallMarkType;
    return copyWith(wallMarkTypes: newWallMarkTypes);
  }

  UnitData({
    this.landType = LandType.rock,
    List<WallType>? wallTypes,
    this.landMarkType = MarkType.none,
    List<MarkType>? wallMarkTypes,
  })  : _wallTypes = (wallTypes == null)
            ? List.generate(_maxDirection, (_) => WallType.wall)
            : wallTypes.also((it) {
                assert(it.length == _maxDirection);
              }),
        _wallMarkTypes = (wallMarkTypes == null)
            ? List.generate(_maxDirection, (_) => MarkType.none)
            : wallMarkTypes.also((it) {
                assert(it.length == _maxDirection);
              });

//<editor-fold desc="Data Methods">
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnitData &&
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

  UnitData copyWith({
    LandType? landType,
    List<WallType>? wallTypes,
    MarkType? landMarkType,
    List<MarkType>? wallMarkTypes,
  }) {
    return UnitData(
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

  factory UnitData.fromMap(Map<String, dynamic> map) {
    return UnitData(
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
  final UnitShape unitShape;
  final int columnCount;
  final int rowCount;
  final List<UnitData> _units;
  final Map<String, String> gridProperties; //todo

  GridData({
    this.version = _currentVersion,
    required this.unitShape,
    required this.columnCount,
    List<UnitData>? units,
    required this.rowCount,
    this.gridProperties = const {},
  }) : _units = (units == null)
            ? List.generate(columnCount * rowCount, (index) => UnitData()).also((_) {
                assert(columnCount > 0 && rowCount > 0);
              })
            : units.also((_) {
                assert(columnCount > 0 && rowCount > 0);
                assert(units.length == columnCount * rowCount);
              });

  UnitData getUnit(int column, int row) {
    assert(column >= 0 && column < columnCount);
    assert(row >= 0 && row < rowCount);
    return _units[row * rowCount + column];
  }

  GridData setUnit(int column, int row, UnitData unitData) {
    assert(column >= 0 && column < columnCount);
    assert(row >= 0 && row < rowCount);
    final newUnits = [..._units];
    newUnits[row * rowCount + column] = unitData;
    return copyWith(units: newUnits);
  }

//<editor-fold desc="Data Methods">
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GridData &&
          version == other.version &&
          runtimeType == other.runtimeType &&
          unitShape == other.unitShape &&
          columnCount == other.columnCount &&
          rowCount == other.rowCount &&
          _units == other._units &&
          gridProperties == other.gridProperties);

  @override
  int get hashCode =>
      version.hashCode ^
      unitShape.hashCode ^
      columnCount.hashCode ^
      rowCount.hashCode ^
      _units.hashCode ^
      gridProperties.hashCode;

  @override
  String toString() {
    return 'GridData{'
        ' unitShape: $unitShape,'
        ' version: $version,'
        ' columnCount: $columnCount,'
        ' rowCount: $rowCount,'
        ' _units: $_units,'
        ' gridProperties: $gridProperties,'
        '}';
  }

  GridData copyWith({
    int? version,
    UnitShape? unitShape,
    int? columnCount,
    int? rowCount,
    List<UnitData>? units,
    List<String>? landTypeNames,
    List<String>? wallTypeNames,
    Map<String, String>? gridProperties,
  }) {
    return GridData(
      version: version ?? this.version,
      unitShape: unitShape ?? this.unitShape,
      columnCount: columnCount ?? this.columnCount,
      rowCount: rowCount ?? this.rowCount,
      units: units ?? this._units,
      gridProperties: gridProperties ?? this.gridProperties,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'version': this.version,
      'unitShape': this.unitShape,
      'columnCount': this.columnCount,
      'rowCount': this.rowCount,
      'units': this._units,
      'gridProperties': this.gridProperties,
    };
  }

  factory GridData.fromMap(Map<String, dynamic> map) {
    return GridData(
      version: map['version'] as int,
      unitShape: map['unitShape'] as UnitShape,
      columnCount: map['columnCount'] as int,
      rowCount: map['rowCount'] as int,
      units: map['units'] as List<UnitData>,
      gridProperties: map['gridProperties'] as Map<String, String>,
    );
  }

//</editor-fold>
}
