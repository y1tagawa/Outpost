// Copyright 2024 Yoshinori Tagawa. All rights reserved.

// 格子図データクラス

import 'package:flutter/material.dart';

import 'scope_functions.dart';

/// 単位図形データクラス
@immutable
class UnitData {
  final int floorType;
  final List<int> _wallType; // N, (N)E, S, (N)W, SE, SW,
  final String onEnter;
  final String onLeave;
  final Map<String, String> floorProperties; //todo
  final List<Map<String, String>> wallProperties; //todo

  const UnitData({
    this.floorType = 0,
    List<int> wallType = const [0, 0, 0, 0, 0, 0],
    this.onEnter = '',
    this.onLeave = '',
    this.floorProperties = const {},
    this.wallProperties = const [{}, {}, {}, {}, {}, {}],
  }) : _wallType = wallType;

//<editor-fold desc="Data Methods">
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnitData &&
          runtimeType == other.runtimeType &&
          floorType == other.floorType &&
          _wallType == other._wallType &&
          onEnter == other.onEnter &&
          onLeave == other.onLeave &&
          floorProperties == other.floorProperties &&
          wallProperties == other.wallProperties);

  @override
  int get hashCode =>
      floorType.hashCode ^
      _wallType.hashCode ^
      onEnter.hashCode ^
      onLeave.hashCode ^
      floorProperties.hashCode ^
      wallProperties.hashCode;

  @override
  String toString() {
    return 'UnitData{'
        ' floorType: $floorType,'
        ' _wallType: $_wallType,'
        ' onEnter: $onEnter,'
        ' onLeave: $onLeave,'
        ' floorProperties: $floorProperties,'
        ' wallProperties: $wallProperties,'
        '}';
  }

  UnitData copyWith({
    int? floorType,
    List<int>? wallType,
    String? onEnter,
    String? onLeave,
    Map<String, String>? floorProperties,
    List<Map<String, String>>? wallProperties,
  }) {
    return UnitData(
      floorType: floorType ?? this.floorType,
      wallType: wallType ?? this._wallType,
      onEnter: onEnter ?? this.onEnter,
      onLeave: onLeave ?? this.onLeave,
      floorProperties: floorProperties ?? this.floorProperties,
      wallProperties: wallProperties ?? this.wallProperties,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'floorType': this.floorType,
      'wallType': this._wallType,
      'onEnter': this.onEnter,
      'onLeave': this.onLeave,
      'unitProperties': this.floorProperties,
      'wallProperties': this.wallProperties,
    };
  }

  factory UnitData.fromMap(Map<String, dynamic> map) {
    return UnitData(
      floorType: map['floorType'] as int,
      wallType: map['wallType'] as List<int>,
      onEnter: map['onEnter'] as String,
      onLeave: map['onLeave'] as String,
      floorProperties: map['unitProperties'] as Map<String, String>,
      wallProperties: map['wallProperties'] as List<Map<String, String>>,
    );
  }

//</editor-fold>
}

/// 単位図形形状
enum UnitShape {
  square,
  hexagon,
}

/// 格子図データクラス
@immutable
class GridData {
  final UnitShape unitShape;
  final int columnCount;
  final int rowCount;
  final List<UnitData> _units;
  final Map<String, String> gridProperties; //todo

  GridData({
    required this.unitShape,
    required this.columnCount,
    List<UnitData>? units,
    required this.rowCount,
    this.gridProperties = const {},
  }) : _units = (units == null)
            ? List.generate(columnCount * rowCount, (index) => const UnitData())
            : units.also((_) {
                assert(units.length == columnCount * rowCount);
              });

  // GridData setFloorType(int column, int row, int floorType) {
  //   return setUnit(column, row, unitAt(column, row).copyWith(floorType: floorType));
  // }
  //
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
          runtimeType == other.runtimeType &&
          unitShape == other.unitShape &&
          columnCount == other.columnCount &&
          rowCount == other.rowCount &&
          _units == other._units &&
          gridProperties == other.gridProperties);

  @override
  int get hashCode =>
      unitShape.hashCode ^
      columnCount.hashCode ^
      rowCount.hashCode ^
      _units.hashCode ^
      gridProperties.hashCode;

  @override
  String toString() {
    return 'GridData{'
        ' unitShape: $unitShape,'
        ' columnCount: $columnCount,'
        ' rowCount: $rowCount,'
        ' _units: $_units,'
        ' gridProperties: $gridProperties,'
        '}';
  }

  GridData copyWith({
    UnitShape? unitShape,
    int? columnCount,
    int? rowCount,
    List<UnitData>? units,
    List<String>? floorTypeNames,
    List<String>? wallTypeNames,
    Map<String, String>? gridProperties,
  }) {
    return GridData(
      unitShape: unitShape ?? this.unitShape,
      columnCount: columnCount ?? this.columnCount,
      rowCount: rowCount ?? this.rowCount,
      units: units ?? this._units,
      gridProperties: gridProperties ?? this.gridProperties,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'unitShape': this.unitShape,
      'columnCount': this.columnCount,
      'rowCount': this.rowCount,
      'units': this._units,
      'gridProperties': this.gridProperties,
    };
  }

  factory GridData.fromMap(Map<String, dynamic> map) {
    return GridData(
      unitShape: map['unitShape'] as UnitShape,
      columnCount: map['columnCount'] as int,
      rowCount: map['rowCount'] as int,
      units: map['units'] as List<UnitData>,
      gridProperties: map['gridProperties'] as Map<String, String>,
    );
  }

//</editor-fold>
}
