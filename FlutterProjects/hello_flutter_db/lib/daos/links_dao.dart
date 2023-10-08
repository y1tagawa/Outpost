// Copyright 2023 Yoshinori Tagawa. All rights reserved.

import 'package:sqflite/sqflite.dart';

import '../dtos/link.dart';

export '../dtos/link.dart';

class LinksDao {
  static final LinksDao instance = LinksDao._internal();
  LinksDao._internal();
  factory LinksDao() => instance;

  Future<Map<String /*name*/, Map<String /*type*/, Link>>> getAll(Database database) async {
    List<Map> list = await database.rawQuery('SELECT * FROM links');
    var buffer = <String, Map<String, Link>>{};
    for (final row in list) {
      final name = row['name']!.toString();
      final type = row['type_']!.toString();
      if (!buffer.containsKey(name)) {
        buffer[name] = <String, Link>{};
      }
      buffer[name]![type] = Link(
        name: name,
        type: type,
        url: row['url']!.toString(),
      );
    }
    return buffer;
  }
}
