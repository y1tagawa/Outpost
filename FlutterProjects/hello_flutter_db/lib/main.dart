// Copyright 2023 Yoshinori Tagawa. All rights reserved.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'asset_database_helper.dart';
import 'daos/links_dao.dart';
import 'daos/names_dao.dart';
import 'daos/pois_dao.dart';
import 'poi_list_view.dart';
import 'prefecture_checkbox.dart';

final logger = Logger('hello_flutter_db');

// データベース
final _dbProvider = FutureProvider<Database>((ref) async {
  return await AssetDatabaseHelper.openAssetDatabase('pois.sqlite3', readOnly: true);
});

// 起動時ロードデータ
class _MainData {
  final Map<String, Poi> pois;
  final Map<String, Name> names;
  final Map<String, Map<String, Link>> links;
  final FlutterTts tts;
  // todo: prefecture
  const _MainData({
    required this.pois,
    required this.names,
    required this.links,
    required this.tts,
  });
}

final _mainDataProvider = FutureProvider<_MainData>((ref) async {
  final db = await ref.watch(_dbProvider.future);
  return _MainData(
    pois: await PoisDao.instance.getAll(db),
    names: await NamesDao.instance.getAll(db),
    links: await LinksDao.instance.getAll(db),
    tts: FlutterTts(), // todo: Android support
  );
});

// 都道府県フィルタ
final _prefectureFilterProvider = StateProvider<List<bool>>(
  (ref) => List<bool>.filled(PrefectureCheckbox.prefectureNames.length, true),
);

// サブタイトル言語
final _languageProvider = StateProvider<int>((ref) => 0);

// メイン
void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
  });

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
      theme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainData = ref.watch(_mainDataProvider);
    final language = ref.watch(_languageProvider);

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
                      ref.watch(_languageProvider.notifier).state = 0;
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
                      ref.watch(_languageProvider.notifier).state = 1;
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
                        value: ref.watch(_prefectureFilterProvider),
                        onChanged: (value) {
                          assert(value.length == PrefectureCheckbox.prefectureNames.length);
                          setState(
                            () => ref.watch(_prefectureFilterProvider.notifier).state = value,
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
        title: const Text('Hello Flutter DB'),
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
                prefectureFilter: ref.watch(_prefectureFilterProvider),
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
