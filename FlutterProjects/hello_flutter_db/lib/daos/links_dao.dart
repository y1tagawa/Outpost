/// Copyright 2023 Yoshinori Tagawa

import 'package:sqflite/sqflite.dart';

class Link {
  final String name;
  final String type;
  final String url;

  Link({
    required this.name,
    required this.type,
    required this.url,
  });
}

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
