import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../inbox/inbox_screen.dart';
import 'preview_screen.dart';

@immutable
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();

  static const routeName = '/camera';
  static late final List<CameraDescription> cameras;
}

class _CameraScreenState extends State<CameraScreen> {
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
    final primaryColor = Theme.of(context).primaryColor;

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
                            TextButton(
                              onPressed: _goToInbox,
                              child: const Text('Inbox'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.camera_alt),
                              onPressed: _takePicture,
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

  Future<void> _takePicture() async {
    await _initializeControllerFuture;

    final xfile = await _controller.takePicture();
    final file = File(xfile.path);

    if (mounted) {
      Navigator.of(context).pushNamed(
        PreviewScreen.routeName,
        arguments: PreviewScreenArguments(cacheImage: file),
      );
    }
  }

  void _goToInbox() {
    Navigator.of(context).pushReplacementNamed(InboxScreen.routeName);
  }
}
