/// Copyright 2023 Yoshinori Tagawa

import 'package:sqflite/sqflite.dart';

class Name {
  final String name;
  final String nameHira;
  final String nameEn;

  Name({
    required this.name,
    required this.nameHira,
    required this.nameEn,
  });
}

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
