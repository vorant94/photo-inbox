import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'state/todos.dart';

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
  late final CameraController _controller;
  late final Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
    _controller = CameraController(
      CameraScreen.cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme
        .of(context)
        .primaryColor;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FutureBuilder(
          // TODO why _controller.initialize() can't be used here right away?
          //  (it fails upon second camera opening or even crashes)
          future: _initializeControllerFuture,
          builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.done
              ? Column(
            children: [
              CameraPreview(_controller),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: _createCamera,
                    style: IconButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Future<void> _createCamera() async {
    await _initializeControllerFuture;

    final notifier = ref.read(todosProvider.notifier);

    final xFile = await _controller.takePicture();

    await notifier.create(xImage: xFile);

    if (mounted) {
      context.pop();
    }
  }
}
