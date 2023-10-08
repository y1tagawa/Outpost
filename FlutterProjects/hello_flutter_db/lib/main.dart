// Copyright 2023 Yoshinori Tagawa. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'asset_database_helper.dart';
import 'daos/links_dao.dart';
import 'daos/names_dao.dart';
import 'daos/pois_dao.dart';
import 'poi_list_view.dart';
import 'prefecture_checkbox.dart';

// データベース
final dbProvider_ = FutureProvider<Database>((ref) async {
  return await AssetDatabaseHelper.openAssetDatabase('pois.sqlite3', readOnly: true);
});

// 起動時ロードデータ
class MainData {
  final Map<String, Poi> pois;
  final Map<String, Name> names;
  final Map<String, Map<String, Link>> links;
  final FlutterTts tts;
  // todo: prefecture
  const MainData({
    required this.pois,
    required this.names,
    required this.links,
    required this.tts,
  });
}

final mainDataProvider_ = FutureProvider<MainData>((ref) async {
  final db = await ref.watch(dbProvider_.future);
  return MainData(
    pois: await PoisDao.instance.getAll(db),
    names: await NamesDao.instance.getAll(db),
    links: await LinksDao.instance.getAll(db),
    tts: FlutterTts(), // todo: Android support
  );
});

// 都道府県フィルタ
final prefectureFilterProvider_ = StateProvider<List<bool>>(
  (ref) => List<bool>.filled(PrefectureCheckbox.prefectureNames.length, true),
);

// サブタイトル言語
final languageProvider_ = StateProvider<int>((ref) => 0);

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
    final mainData = ref.watch(mainDataProvider_);
    final language = ref.watch(languageProvider_);

    // サブタイトル言語設定ダイアログ
    void showLanguageDialog(
      BuildContext context,
      FlutterTts tts,
    ) async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: ListView(
              itemExtent: 48,
              shrinkWrap: true,
              children: [
                GestureDetector(
                  onLongPress: () async {
                    await tts.setLanguage('ja-JP');
                    await tts.speak('日本語');
                  },
                  child: RadioListTile(
                    value: 0,
                    groupValue: language,
                    title: const Text('日本語'),
                    onChanged: (_) {
                      ref.watch(languageProvider_.notifier).state = 0;
                      Navigator.pop(context);
                    },
                  ),
                ),
                GestureDetector(
                  onLongPress: () async {
                    await tts.setLanguage('en-US');
                    await tts.speak('English');
                  },
                  child: RadioListTile(
                    value: 1,
                    groupValue: language,
                    title: const Text('English'),
                    onChanged: (_) {
                      ref.watch(languageProvider_.notifier).state = 1;
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    // 都道府県フィルタ設定ダイアログ
    void showPrefectureFilterDialog(
      BuildContext context,
      Map<String, Name> names,
      int language,
      FlutterTts tts,
    ) async {
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
                        names: names,
                        language: language,
                        tts: tts,
                        value: ref.watch(prefectureFilterProvider_),
                        onChanged: (value) {
                          assert(value.length == PrefectureCheckbox.prefectureNames.length);
                          setState(
                            () => ref.watch(prefectureFilterProvider_.notifier).state = value,
                          );
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      onLongPress: () async {
                        if (language == 1) {
                          await tts.setLanguage('en-US');
                          await tts.speak('CLOSE');
                        } else {
                          await tts.setLanguage('ja-JP');
                          await tts.speak('閉じる');
                        }
                      },
                      child: const Text('CLOSE'),
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
                    onPressed: () => showLanguageDialog(context, data.tts),
                    icon: const Icon(Icons.language),
                  ),
                  IconButton(
                    onPressed: () => showPrefectureFilterDialog(
                      context,
                      data.names,
                      language,
                      data.tts,
                    ),
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
                prefectureFilter: ref.watch(prefectureFilterProvider_),
                language: language,
                tts: data.tts,
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
