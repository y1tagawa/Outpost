// Copyright 2023 Yoshinori Tagawa. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:sqflite/sqflite.dart';

class Poi {
  final String name;
  final double latitude;
  final double longitude;
  final String prefecture;

  Poi({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.prefecture,
  });
}

class PoisDao {
  static final PoisDao instance = PoisDao._internal();
  PoisDao._internal();
  factory PoisDao() => instance;

  Future<Map<String /*name*/, Poi>> getAll(Database database) async {
    List<Map> list = await database.rawQuery('SELECT * FROM pois');
    var buffer = <String, Poi>{};
    for (final row in list) {
      final name = row['name']!.toString();
      buffer[name] = Poi(
        name: name,
        latitude: double.parse(row['latitude']!.toString()),
        longitude: double.parse(row['longitude']!.toString()),
        prefecture: row['prefecture']!.toString(),
      );
    }
    return buffer;
  }
}
