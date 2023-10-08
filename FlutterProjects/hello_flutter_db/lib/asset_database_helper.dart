// Copyright 2023 Yoshinori Tagawa. All rights reserved.

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// sqflite3用アセットデータベースヘルパ
///
class AssetDatabaseHelper {
  /// assetsフォルダ直下に置かれたデータベースファイルをプラットフォームのデータベースフォルダにコピーして開く。
  ///
  static Future<Database> openAssetDatabase(String dbName, {bool readOnly = true}) async {
    final dbPath = join(await getDatabasesPath(), dbName);

    await deleteDatabase(dbPath);

    await Directory(dirname(dbPath)).create(recursive: true);
    final data = await rootBundle.load(url.join('assets', dbName));
    final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes, flush: true);

    return await openDatabase(dbPath, readOnly: true);
  }
}
