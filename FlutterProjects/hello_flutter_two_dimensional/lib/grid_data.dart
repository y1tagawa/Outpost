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
enum FloorType {
  floor,
  rock,
  water,
  cavity,
}

/// 壁タイプ
enum WallType {
  wall,
  path,
  door,
}

/// 単位図形データクラス
@immutable
class UnitData {
  final FloorType floorType;
  final List<WallType> _wallTypes; // N, (N)E, S, (N)W, SE, SW,
  final Map<String, String> floorProperties; //todo
  final List<Map<String, String>> wallProperties; //todo

  List<WallType> get wallTypes => [..._wallTypes];

  UnitData({
    this.floorType = FloorType.floor,
    List<WallType>? wallTypes,
    this.floorProperties = const {},
    this.wallProperties = const [{}, {}, {}, {}, {}, {}],
  }) : _wallTypes = (wallTypes == null)
            ? List.generate(_maxDirection, (_) => WallType.wall)
            : wallTypes.also((it) {
                assert(wallTypes.length == _maxDirection);
              });

//<editor-fold desc="Data Methods">
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnitData &&
          runtimeType == other.runtimeType &&
          floorType == other.floorType &&
          _wallTypes == other._wallTypes &&
          floorProperties == other.floorProperties &&
          wallProperties == other.wallProperties);

  @override
  int get hashCode =>
      floorType.hashCode ^ _wallTypes.hashCode ^ floorProperties.hashCode ^ wallProperties.hashCode;

  @override
  String toString() {
    return 'UnitData{'
        ' floorType: $floorType,'
        ' _wallType: $_wallTypes,'
        ' floorProperties: $floorProperties,'
        ' wallProperties: $wallProperties,'
        '}';
  }

  UnitData copyWith({
    FloorType? floorType,
    List<WallType>? wallTypes,
    String? onEnter,
    String? onLeave,
    Map<String, String>? floorProperties,
    List<Map<String, String>>? wallProperties,
  }) {
    return UnitData(
      floorType: floorType ?? this.floorType,
      wallTypes: wallTypes ?? this._wallTypes,
      floorProperties: floorProperties ?? this.floorProperties,
      wallProperties: wallProperties ?? this.wallProperties,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'floorType': this.floorType,
      'wallTypes': this._wallTypes,
      'unitProperties': this.floorProperties,
      'wallProperties': this.wallProperties,
    };
  }

  factory UnitData.fromMap(Map<String, dynamic> map) {
    return UnitData(
      floorType: map['floorType'] as FloorType,
      wallTypes: map['wallTypes'] as List<WallType>,
      floorProperties: map['unitProperties'] as Map<String, String>,
      wallProperties: map['wallProperties'] as List<Map<String, String>>,
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

  UnitData unitAt(int column, int row) {
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
    List<String>? floorTypeNames,
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
