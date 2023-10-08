// Copyright 2023 Yoshinori Tagawa. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hello_flutter_db/prefecture_checkbox.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'asset_database_helper.dart';
import 'daos/links_dao.dart';
import 'daos/names_dao.dart';
import 'daos/pois_dao.dart';
import 'poi_list_view.dart';

// データベース
final dbProvider = FutureProvider<Database>((ref) async {
  return await AssetDatabaseHelper.openAssetDatabase('pois.sqlite3', readOnly: true);
});

// 起動時ロードデータ
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

// 都道府県フィルタ
final prefectureFilterProvider = StateProvider<List<bool>>(
  (ref) => List<bool>.filled(PrefectureCheckbox.prefectureNames.length, true),
);

// サブタイトル言語
final languageProvider = StateProvider<int>((ref) => 0);

// メイン
void main() {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
  }
  databaseFactory = databaseFactoryFfi;

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainData = ref.watch(mainDataProvider);
    final language = ref.watch(languageProvider);

    // サブタイトル言語設定ダイアログ
    void showLanguageDialog(BuildContext context) async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: ListView(
              itemExtent: 48,
              shrinkWrap: true,
              children: [
                RadioListTile(
                  value: 0,
                  groupValue: language,
                  title: const Text('日本語'),
                  onChanged: (_) {
                    ref.watch(languageProvider.notifier).state = 0;
                    Navigator.pop(context);
                  },
                ),
                RadioListTile(
                  value: 1,
                  groupValue: language,
                  title: const Text('English'),
                  onChanged: (_) {
                    ref.watch(languageProvider.notifier).state = 1;
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    // 都道府県フィルタ設定ダイアログ
    void showPrefectureFilterDialog(BuildContext context) async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                child: Column(
                  children: [
                    Expanded(
                      child: PrefectureCheckbox(
                        value: ref.watch(prefectureFilterProvider),
                        onChanged: (value) {
                          assert(value.length == PrefectureCheckbox.prefectureNames.length);
                          setState(
                            () => ref.watch(prefectureFilterProvider.notifier).state = value,
                          );
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    )
                  ],
                ),
              );
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('POIs'),
      ),
      body: mainData.when(
        data: (data) => Column(
          children: [
            // 設定パネル
            SizedBox(
              height: 48,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => showLanguageDialog(context),
                    icon: const Icon(Icons.language),
                  ),
                  IconButton(
                    onPressed: () => showPrefectureFilterDialog(context),
                    icon: const Icon(Icons.public),
                  ),
                ],
              ),
            ),
            // POIリスト
            Expanded(
              child: PoiListView(
                pois: data.pois,
                names: data.names,
                links: data.links,
                prefectureFilter: ref.watch(prefectureFilterProvider),
                language: language,
              ),
            ),
          ],
        ),
        error: (error, _) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
