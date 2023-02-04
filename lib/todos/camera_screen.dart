import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../shared/camera/camera_value.dart';
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              return snapshot.connectionState != ConnectionState.done
                  ? const CircularProgressIndicator()
                  : AspectRatio(
                      aspectRatio: _controller.value.aspectRatioInverted,
                      child: Stack(
                        children: [
                          CameraPreview(_controller),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              color: Colors.black54,
                              child: TextButton(
                                onPressed: _createTodo,
                                child: const Text('Take photo'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _createTodo() async {
    await _initializeControllerFuture;

    final todoNotifier = ref.read(todosProvider.notifier);

    final xFile = await _controller.takePicture();

    await todoNotifier.create(xImage: xFile);

    if (mounted) {
      context.pop();
    }
  }
}
