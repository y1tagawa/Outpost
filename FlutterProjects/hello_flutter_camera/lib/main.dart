// Copyright 2023 Yoshinori Tagawa. All rights reserved.

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

final cameraControllerProvider = FutureProvider.autoDispose<CameraController>(
  (ref) async {
    final cameras = await availableCameras();
    final controller = CameraController(cameras[0], ResolutionPreset.max);
    await controller.initialize();
    return controller;
  },
);

ScreenshotController screenshotController = ScreenshotController();

void main() {
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

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: controller.when(
        data: (data) => Screenshot(
          controller: screenshotController,
          child: Stack(
            children: [
              Center(
                child: CameraPreview(data),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset('assets/my_dash/my_dash.png', scale: 0.25),
              ),
            ],
          ),
        ),
        error: (error, _) => Text(error.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: kIsWeb
          ? null
          : FloatingActionButton(
              onPressed: () async {
                final directory = (await getApplicationDocumentsDirectory()).path;
                final fileName = '${DateTime.now().microsecondsSinceEpoch}.png';
                Logger().i('$directory/$fileName');
                screenshotController.captureAndSave(directory, fileName: fileName);
              },
              child: const Icon(Icons.camera_alt_outlined),
            ),
    );
  }
}
