// Copyright 2023 Yoshinori Tagawa. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

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
  ];

  static final areas = {
    '東北': [1, 2, 3, 4, 5, 6],
    '関東': [7, 8, 9, 10, 11, 12, 13],
    '北陸': [14, 15, 16, 17],
    '甲信': [18, 19],
    '東海': [20, 21, 22, 23],
    '近畿': [24, 25, 26, 27, 28, 29],
    '中国': [30, 31, 32, 33, 34],
    '四国': [35, 36, 37, 38],
    '九州': [39, 40, 41, 42, 43, 44, 45],
  }.entries.toList();

  final List<bool> value;
  final void Function(List<bool>)? onChanged;

  const PrefectureCheckbox({
    super.key,
    required this.value,
    this.onChanged,
  }) : assert(value.length == prefectureNames.length);

  @override
  Widget build(BuildContext context) {
    final allValue = value.every((it) => it)
        ? true
        : value.every((it) => !it)
            ? false
            : null;

    final areaValue = [
      for (final area in areas)
        area.value.every((it) => value[it])
            ? true
            : area.value.every((it) => !value[it])
                ? false
                : null,
    ];

    CheckboxListTile allListTile() {
      return CheckboxListTile(
        value: allValue,
        tristate: true,
        title: const Text('全国'),
        onChanged: (_) {
          onChanged?.call(List<bool>.filled(value.length, allValue != true));
        },
      );
    }

    CheckboxListTile areaListTile(int index) {
      return CheckboxListTile(
        value: areaValue[index],
        tristate: true,
        title: Text('  ${areas[index].key}'),
        onChanged: (_) {
          final newValue = [...value];
          final f = areaValue[index] != true;
          for (final i in areas[index].value) {
            newValue[i] = f;
          }
          onChanged?.call(newValue);
        },
      );
    }

    CheckboxListTile prefectureListTile(int index) {
      return CheckboxListTile(
        value: value[index],
        tristate: false,
        title: Text('    ${prefectureNames[index]}'),
        onChanged: (_) {
          final newValue = [...value];
          newValue[index] = !value[index];
          onChanged?.call(newValue);
        },
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
        for (int i = 0; i < areas.length; ++i) ...[
          areaListTile(i),
          // 各都府県
          for (final j in areas[i].value) prefectureListTile(j),
        ],
        // 沖縄
        prefectureListTile(46),
      ],
    );
  }
}
