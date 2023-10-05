import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';

//

class NamesDto {
  final String name;
  final String nameHira;
  final String nameEn;

  NamesDto({required this.name, required this.nameHira, required this.nameEn});
}

class NamesDao {
  static final NamesDao instance = NamesDao._internal();
  NamesDao._internal();
  factory NamesDao() => instance;

  Future<Map<String, NamesDto>> getAll(Database database) async {
    List<Map> list = await database.rawQuery('SELECT * FROM names');
    var buffer = <String, NamesDto>{};
    for (final row in list) {
      final name = row['name'].toString();
      buffer[name] = NamesDto(
        name: name,
        nameHira: row['name_hira'].toString(),
        nameEn: row['name_en'].toString(),
      );
    }
    return buffer;
  }
}

//

final dbProvider = FutureProvider<Database>(
  (ref) async => await openDatabase('data/pois.sqlite3'),
);

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'POIs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Example')),
        body: const Center(
          child: Row(
            children: [],
          ),
        ),
      ),
    );
  }
}
