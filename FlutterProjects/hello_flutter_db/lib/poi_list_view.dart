/// Copyright 2023 Yoshinori Tagawa

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'daos/links_dao.dart';
import 'daos/names_dao.dart';
import 'daos/pois_dao.dart';

/// POIリストビュー
///
class PoiListView extends ConsumerWidget {
  final Map<String /*name*/, Poi> pois;
  final Map<String /*name*/, Name> names;
  final Map<String /*name*/, Map<String /*type*/, Link>> links;
  final int language;

  // todo: sort order, filters
  const PoiListView({
    super.key,
    required this.pois,
    required this.names,
    required this.links,
    required this.language,
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
          subtitle: Text(
            language == 0 ? name.nameHira : name.nameEn,
          ),
          trailing: PopupMenuButton(
            itemBuilder: (BuildContext context) {
              final linkList = links[poi.name];
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
                if (linkList != null)
                  for (final type in linkList.keys)
                    PopupMenuItem(
                      child: Text(type),
                      onTap: () async {
                        await launchUrlString(linkList[type]!.url);
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
