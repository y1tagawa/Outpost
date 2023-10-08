/// Copyright 2023 Yoshinori Tagawa. All rights reserved.

import 'package:flutter_tts/flutter_tts.dart';

import 'dtos/name.dart';

extension TtsHelper on FlutterTts {
  Future<dynamic> speakName(Name name, int language) async {
    if (language == 1) {
      await setLanguage('en-US');
      final text = name.nameEn
          .toLowerCase()
          .replaceAll('ā', 'aa')
          .replaceAll('ē', 'ee')
          .replaceAll('ī', 'ii')
          .replaceAll('ō', 'oo')
          .replaceAll('ū', 'uu');
      return speak(text);
    } else {
      await setLanguage('ja-JP');
      return speak(name.nameHira);
    }
  }
}
