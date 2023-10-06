import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'asset_database_helper.dart';

// DTOs

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

// DAOs

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

class LinksDao {
  static final LinksDao instance = LinksDao._internal();
  LinksDao._internal();
  factory LinksDao() => instance;

  Future<Map<String /*name*/, Map<String /*type*/, Link>>> getAll(Database database) async {
    List<Map> list = await database.rawQuery('SELECT * FROM links');
    var buffer = <String, Map<String, Link>>{};
    for (final row in list) {
      final name = row['name'].toString();
      final type = row['type_'].toString();
      if (!buffer.containsKey(name)) {
        buffer[name] = <String, Link>{};
      }
      buffer[name]![type] = Link(
        name: name,
        type: type,
        url: row['url'].toString(),
      );
    }
    return buffer;
  }
}

// providers

final dbProvider = FutureProvider<Database>((ref) async {
  return await AssetDatabaseHelper.openAssetDatabase('pois.sqlite3', readOnly: true);
});

class MainData {
  final Map<String, Poi> pois;
  final Map<String, Name> names;
  final Map<String, Map<String, Link>> links;
  // todo: prefecture
  const MainData({
    required this.pois,
    required this.names,
    required this.links,
  });
}

final mainDataProvider = FutureProvider<MainData>((ref) async {
  final db = await ref.watch(dbProvider.future);
  return MainData(
    pois: await PoisDao.instance.getAll(db),
    names: await NamesDao.instance.getAll(db),
    links: await LinksDao.instance.getAll(db),
  );
});

// main

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
  final Map<String /*name*/, Map<String /*type*/, Link>> links;

  // todo: sort order, filters
  const PoiListView({
    super.key,
    required this.pois,
    required this.names,
    required this.links,
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
          trailing: PopupMenuButton(
            itemBuilder: (BuildContext context) {
              final links_ = links[poi.name];
              return [
                PopupMenuItem(
                  child: const Text('Open Street Map'),
                  onTap: () async {
                    await launchUrl(
                      Uri(scheme: 'https', host: 'www.openstreetmap.org', queryParameters: {
                        'mlat': '${poi.latitude}',
                        'mlon': '${poi.longitude}',
                        'zoom': '12',
                        'layers': 'M',
                      }),
                    );
                  },
                ),
                if (links_ != null)
                  for (final type in links_.keys)
                    PopupMenuItem(
                      child: Text(type),
                      onTap: () async {
                        await launchUrlString(links_[type]!.url);
                      },
                    ),
              ];
            },
            child: const Icon(Icons.more_vert),
          ),
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
            links: data.links,
          ),
          error: (error, _) => Center(child: Text(error.toString())),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
