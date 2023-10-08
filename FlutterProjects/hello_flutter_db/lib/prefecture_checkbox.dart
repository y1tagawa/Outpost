// Copyright 2023 Yoshinori Tagawa. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'daos/names_dao.dart';
import 'tts_helper.dart';

class PrefectureCheckbox extends StatelessWidget {
  static const prefectureNames = [
    '北海道',
    '青森県', '岩手県', '宮城県', '秋田県', '山形県', '福島県', // 東北
    '茨城県', '栃木県', '群馬県', '埼玉県', '千葉県', '東京都', '神奈川県', // 関東
    '新潟県', '富山県', '石川県', '福井県', // 北陸
    '山梨県', '長野県', // 甲信
    '岐阜県', '静岡県', '愛知県', '三重県', // 東海
    '滋賀県', '京都府', '大阪府', '兵庫県', '奈良県', '和歌山県', // 近畿
    '鳥取県', '島根県', '岡山県', '広島県', '山口県', // 中国
    '徳島県', '香川県', '愛媛県', '高知県', // 四国
    '福岡県', '佐賀県', '長崎県', '熊本県', '大分県', '宮崎県', '鹿児島県', // 九州
    '沖縄県',
    '伊豆・小笠原諸島'
  ];

  static final regions_ = {
    '東北地方': [1, 2, 3, 4, 5, 6],
    '関東地方': [7, 8, 9, 10, 11, 12, 47, 13],
    '北陸地方': [14, 15, 16, 17],
    '甲信地方': [18, 19],
    '東海地方': [20, 21, 22, 23],
    '近畿地方': [24, 25, 26, 27, 28, 29],
    '中国地方': [30, 31, 32, 33, 34],
    '四国地方': [35, 36, 37, 38],
    '九州地方': [39, 40, 41, 42, 43, 44, 45],
  }.entries.toList();

  final Map<String, Name> names;
  final int language;
  final FlutterTts tts;
  final List<bool> value;
  final void Function(List<bool>)? onChanged;

  const PrefectureCheckbox({
    super.key,
    required this.names,
    required this.language,
    required this.tts,
    required this.value,
    this.onChanged,
  }) : assert(value.length == prefectureNames.length);

  @override
  Widget build(BuildContext context) {
    // 全国チェック値
    final allValue = value.every((it) => it)
        ? true
        : value.every((it) => !it)
            ? false
            : null;

    // 各地方チェック値
    final regionValue = [
      for (final region in regions_)
        region.value.every((it) => value[it])
            ? true
            : region.value.every((it) => !value[it])
                ? false
                : null,
    ];

    // 全国チェックボックス
    Widget allListTile() {
      const name = '全国';
      return GestureDetector(
        onLongPress: () async => await tts.speakName(names[name]!, language),
        child: CheckboxListTile(
          value: allValue,
          tristate: true,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
          title: Text(language == 1 ? names[name]!.nameEn : name),
          onChanged: (_) {
            onChanged?.call(List<bool>.filled(value.length, allValue != true));
          },
        ),
      );
    }

    // 各地方チェックボックス
    Widget regionListTile(int index) {
      final name = regions_[index].key;
      return GestureDetector(
        onLongPress: () async => await tts.speakName(names[name]!, language),
        child: CheckboxListTile(
          value: regionValue[index],
          tristate: true,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
          title: Text(language == 1 ? names[name]!.nameEn : name),
          onChanged: (_) {
            final newValue = [...value];
            final f = regionValue[index] != true;
            for (final i in regions_[index].value) {
              newValue[i] = f;
            }
            onChanged?.call(newValue);
          },
        ),
      );
    }

    // 各都道府県チェックボックス
    Widget prefectureListTile(int index) {
      final name = prefectureNames[index];
      return GestureDetector(
        onLongPress: () async => await tts.speakName(names[name]!, language),
        child: CheckboxListTile(
          value: value[index],
          tristate: false,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(28, 0, 0, 0),
          title: Text(language == 1 ? names[name]!.nameEn : name),
          onChanged: (_) {
            final newValue = [...value];
            newValue[index] = !value[index];
            onChanged?.call(newValue);
          },
        ),
      );
    }

    return ListView(
      itemExtent: 36,
      children: [
        // 全国
        allListTile(),
        // 北海道
        prefectureListTile(0),
        // 各地方
        for (int i = 0; i < regions_.length; ++i) ...[
          regionListTile(i),
          // 各都府県
          for (final j in regions_[i].value) prefectureListTile(j),
        ],
        // 沖縄
        prefectureListTile(46),
      ],
    );
  }
}
