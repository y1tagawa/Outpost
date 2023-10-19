// Copyright 2023 Yoshinori Tagawa. All rights reserved.

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

final logger = Logger('hello_flutter_camera');

final cameraControllerProvider = FutureProvider.autoDispose<CameraController>(
  (ref) async {
    final cameras = await availableCameras();
    final controller = CameraController(cameras[0], ResolutionPreset.max, enableAudio: false);
    await controller.initialize();
    return controller;
  },
);

ScreenshotController screenshotController = ScreenshotController();

final screenshotEnabledProvider = StateProvider<bool>((ref) => true);

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello Flutter Camera',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Hello Flutter Camera'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(cameraControllerProvider);
    final screenshotEnabled = ref.watch(screenshotEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: controller.when(
        data: (data) => Center(
          child: Screenshot(
            controller: screenshotController,
            child: CameraPreview(data, child: LayoutBuilder(
              builder: (context, constraints) {
                double? height;
                double? width;
                if (constraints.biggest.width > constraints.biggest.height) {
                  if (constraints.hasBoundedHeight) {
                    height = constraints.biggest.height * 0.8;
                  }
                } else {
                  if (constraints.hasBoundedWidth) {
                    width = constraints.biggest.width * 0.8;
                  }
                }
                return Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    'assets/my_dash/my_dash.png',
                    width: width,
                    height: height,
                  ),
                );
              },
            )),
          ),
        ),
        error: (error, _) => Text(error.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: kIsWeb
          ? null
          : FloatingActionButton(
              backgroundColor: screenshotEnabled ? null : Theme.of(context).disabledColor,
              onPressed: screenshotEnabled
                  ? () {
                      ref.read(screenshotEnabledProvider.notifier).state = false;
                      Future.delayed(Duration.zero, () async {
                        final directory = (await getApplicationDocumentsDirectory()).path;
                        final fileName = '${DateTime.now().microsecondsSinceEpoch}.png';
                        logger.info('directory: $directory filename: $fileName');
                        final path = await screenshotController.captureAndSave(directory,
                            fileName: fileName);
                        logger.info('path: $path');

                        if (Platform.isAndroid) {
                          logger.info('the platform is Android.');
                          final result = await ImageGallerySaver.saveFile(path!);
                          if (result is! Map<Object?, Object?> || result['isSuccess'] != true) {
                            throw Exception('ImageGallerySaver.saveFile failed. $result');
                          }
                          logger.info('ImageGallerySaver.saveFile ok.');
                        }
                        ref.read(screenshotEnabledProvider.notifier).state = true;
                      });
                    }
                  : null,
              child: const Icon(Icons.camera_alt_outlined),
            ),
    );
  }
}
