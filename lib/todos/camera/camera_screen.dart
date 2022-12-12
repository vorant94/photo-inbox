import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../inbox/inbox_screen.dart';
import 'preview_screen.dart';

@immutable
class CameraScreen extends StatefulWidget {
  static const routeName = 'camera';
  static final route = GoRoute(
    name: CameraScreen.routeName,
    path: '/${CameraScreen.routeName}',
    builder: (context, state) => const CameraScreen(),
  );

  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final _controller = CameraController(
    cameras[0],
    ResolutionPreset.max,
    enableAudio: false,
  );

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
    _controller.initialize().then((value) {
      if (mounted) setState(() {});
    });
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
        child: _controller.value.isInitialized
            ? Column(
                children: [
                  CameraPreview(_controller),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: _goToInbox,
                        child: const Text('Inbox'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: _takePicture,
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Future<void> _takePicture() async {
    if (_controller.value.isTakingPicture) return;
    final file = File((await _controller.takePicture()).path);
    if (mounted) context.pushNamed(PreviewScreen.routeName, extra: file);
  }

  void _goToInbox() {
    context.goNamed(InboxScreen.routeName);
  }
}

late List<CameraDescription> cameras;
