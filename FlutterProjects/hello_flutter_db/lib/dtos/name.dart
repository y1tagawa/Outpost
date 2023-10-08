// Copyright 2023 Yoshinori Tagawa. All rights reserved.

class Name {
  final String name;
  final String nameHira;
  final String nameEn;

  Name({
    required this.name,
    required this.nameHira,
    required this.nameEn,
  });

  String canonicalName(int language) => language == 1 ? nameEn : name;
  String readableName(int language) => language == 1 ? nameEn : nameHira;
}
