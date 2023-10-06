import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'asset_database_helper.dart';

//

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
      final name = row['name'].toString();
      buffer[name] = Name(
        name: name,
        nameHira: row['name_hira'].toString(),
        nameEn: row['name_en'].toString(),
      );
    }
    return buffer;
  }
}

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
      final name = row['name'].toString();
      buffer[name] = Poi(
        name: name,
        latitude: double.parse(row['latitude'].toString()),
        longitude: double.parse(row['longitude'].toString()),
        prefecture: row['prefecture'].toString(),
      );
    }
    return buffer;
  }
}

final dbProvider = FutureProvider<Database>((ref) async {
  return await AssetDatabaseHelper.openAssetDatabase('pois.sqlite3', readOnly: true);
});

class MainData {
  final Map<String, Poi> pois;
  final Map<String, Name> names;
  // todo: prefecture
  const MainData({
    required this.pois,
    required this.names,
  });
}

final mainDataProvider = FutureProvider<MainData>((ref) async {
  final db = await ref.watch(dbProvider.future);
  return MainData(
    pois: await PoisDao.instance.getAll(db),
    names: await NamesDao.instance.getAll(db),
  );
});

void main() {
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }
  databaseFactory = databaseFactoryFfi;

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// POIリストビュー
///
class PoiListView extends ConsumerWidget {
  final Map<String /*name*/, Poi> pois;
  final Map<String /*name*/, Name> names;

  // todo: sort order, filters
  const PoiListView({
    super.key,
    required this.pois,
    required this.names,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // todo: sort, filter
    final poiList = pois.values.toList(growable: false);

    return ListView.builder(
      itemBuilder: (BuildContext context_, int index) {
        final poi = poiList[index];
        final name = names[poi.name]!;
        return ListTile(
          title: Text(poi.name),
          subtitle: Text(name.nameHira), // todo: english
        );
      },
      itemCount: poiList.length,
      itemExtent: 54,
    );
  }
}

///
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainData = ref.watch(mainDataProvider);

    return MaterialApp(
      title: 'POIs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('POIs')),
        body: mainData.when(
          data: (data) => PoiListView(
            pois: data.pois,
            names: data.names,
          ),
          error: (error, _) => Center(child: Text(error.toString())),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
