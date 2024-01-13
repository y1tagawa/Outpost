// Copyright 2024 Yoshinori Tagawa. All rights reserved.

// 格子図データクラス

import 'package:flutter/cupertino.dart';

/// 単位図形データクラス
@immutable
class UnitData {
  final int floorType;
  final List<int> wallType; // N, (N)E, S, (N)W, SE, SW,
  final String onEnter;
  final String onLeave;
  final Map<String, String> floorProperties;
  final List<Map<String, String>> wallProperties;

  const UnitData({
    this.floorType = 0,
    this.wallType = const [0, 0, 0, 0, 0, 0],
    this.onEnter = '',
    this.onLeave = '',
    this.floorProperties = const {},
    this.wallProperties = const [{}, {}, {}, {}, {}, {}],
  });

//<editor-fold desc="Data Methods">
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnitData &&
          runtimeType == other.runtimeType &&
          floorType == other.floorType &&
          wallType == other.wallType &&
          onEnter == other.onEnter &&
          onLeave == other.onLeave &&
          floorProperties == other.floorProperties &&
          wallProperties == other.wallProperties);

  @override
  int get hashCode =>
      floorType.hashCode ^
      wallType.hashCode ^
      onEnter.hashCode ^
      onLeave.hashCode ^
      floorProperties.hashCode ^
      wallProperties.hashCode;

  @override
  String toString() {
    return 'UnitData{'
        ' floorType: $floorType,'
        ' wallType: $wallType,'
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
      wallType: wallType ?? this.wallType,
      onEnter: onEnter ?? this.onEnter,
      onLeave: onLeave ?? this.onLeave,
      floorProperties: floorProperties ?? this.floorProperties,
      wallProperties: wallProperties ?? this.wallProperties,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'floorType': this.floorType,
      'wallType': this.wallType,
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
  final List<String> floorTypeNames;
  final List<String> wallTypeNames;
  final Map<String, String> gridProperties;

  GridData({
    required this.unitShape,
    required this.columnCount,
    required this.rowCount,
    required this.floorTypeNames,
    required this.wallTypeNames,
    this.gridProperties = const {},
  }) : _units = List.generate(columnCount * rowCount, (index) => const UnitData());

  GridData setFloorType(int column, int row, int floorType) {
    return _setUnit(column, row, unitAt(column, row).copyWith(floorType: floorType));
  }

  UnitData unitAt(int column, int row) {
    assert(column >= 0 && column < columnCount);
    assert(row >= 0 && row < rowCount);
    return _units[row * rowCount + column];
  }

  GridData _setUnit(int column, int row, UnitData unitData) {
    assert(column >= 0 && column < columnCount);
    assert(row >= 0 && row < rowCount);
    final newUnits = [..._units];
    newUnits[row * rowCount + column] = unitData;
    return copyWith(units: newUnits);
  }

  const GridData._copy({
    required this.unitShape,
    required this.columnCount,
    required this.rowCount,
    required List<UnitData> units,
    required this.floorTypeNames,
    required this.wallTypeNames,
    required this.gridProperties,
  }) : _units = units;

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
          floorTypeNames == other.floorTypeNames &&
          wallTypeNames == other.wallTypeNames &&
          gridProperties == other.gridProperties);

  @override
  int get hashCode =>
      unitShape.hashCode ^
      columnCount.hashCode ^
      rowCount.hashCode ^
      _units.hashCode ^
      floorTypeNames.hashCode ^
      wallTypeNames.hashCode ^
      gridProperties.hashCode;

  @override
  String toString() {
    return 'GridData{'
        ' unitShape: $unitShape,'
        ' columnCount: $columnCount,'
        ' rowCount: $rowCount,'
        ' _units: $_units,'
        ' unitTypeNames: $floorTypeNames,'
        ' wallTypeNames: $wallTypeNames,'
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
    return GridData._copy(
      unitShape: unitShape ?? this.unitShape,
      columnCount: columnCount ?? this.columnCount,
      rowCount: rowCount ?? this.rowCount,
      units: units ?? this._units,
      floorTypeNames: floorTypeNames ?? this.floorTypeNames,
      wallTypeNames: wallTypeNames ?? this.wallTypeNames,
      gridProperties: gridProperties ?? this.gridProperties,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'unitShape': this.unitShape,
      'columnCount': this.columnCount,
      'rowCount': this.rowCount,
      'units': this._units,
      'unitTypeNames': this.floorTypeNames,
      'wallTypeNames': this.wallTypeNames,
      'gridProperties': this.gridProperties,
    };
  }

  factory GridData.fromMap(Map<String, dynamic> map) {
    return GridData._copy(
      unitShape: map['unitShape'] as UnitShape,
      columnCount: map['columnCount'] as int,
      rowCount: map['rowCount'] as int,
      units: map['units'] as List<UnitData>,
      floorTypeNames: map['unitTypeNames'] as List<String>,
      wallTypeNames: map['wallTypeNames'] as List<String>,
      gridProperties: map['gridProperties'] as Map<String, String>,
    );
  }

//</editor-fold>
}
