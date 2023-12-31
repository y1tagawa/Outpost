// Copyright 2023 Yoshinori Tagawa. All rights reserved.

import 'package:sqflite/sqflite.dart';

import '../dtos/name.dart';

export '../dtos/name.dart';

class NamesDao {
  static final NamesDao instance = NamesDao._internal();
  NamesDao._internal();
  factory NamesDao() => instance;

  Future<Map<String /*name*/, Name>> getAll(Database database) async {
    List<Map> list = await database.rawQuery('SELECT * FROM names');
    var buffer = <String, Name>{};
    for (final row in list) {
      final name = row['name']!.toString();
      buffer[name] = Name(
        name: name,
        nameHira: row['name_hira']!.toString(),
        nameEn: row['name_en']!.toString(),
      );
    }
    return buffer;
  }
}
