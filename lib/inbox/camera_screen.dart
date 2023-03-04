import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/inbox/inbox_screen.dart';

import '../shared/camera/camera_value.dart';
import 'preview_screen.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();

  static const routeName = 'camera';
  static final route = GoRoute(
    name: CameraScreen.routeName,
    path: '/camera',
    builder: (context, state) => const CameraScreen(),
  );
  static late final List<CameraDescription> cameras;
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  late final CameraController controller;
  late final Future<void> initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

    controller = CameraController(
      CameraScreen.cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );
    initializeControllerFuture = controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    super.dispose();
  }

  Future<void> takePicture() async {
    await initializeControllerFuture;

    final xImage = await controller.takePicture();

    if (!mounted) {
      return;
    }

    context.pushNamed(
      PreviewScreen.routeName,
      extra: PreviewScreenExtra(
        xImage: xImage,
        aspectRatio: controller.value.aspectRatioInverted,
      ),
    );
  }

  void gotoInbox() async {
    context.goNamed(InboxScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FutureBuilder(
          future: initializeControllerFuture,
          builder: (context, snapshot) {
            return snapshot.connectionState != ConnectionState.done
                ? const CircularProgressIndicator()
                : AspectRatio(
                    aspectRatio: controller.value.aspectRatioInverted,
                    child: Stack(
                      children: [
                        CameraPreview(controller),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton(
                                        onPressed: gotoInbox,
                                        child: const Text('Inbox'),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: FloatingActionButton(
                                        onPressed: takePicture,
                                        child: const Icon(Icons.camera_alt),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
