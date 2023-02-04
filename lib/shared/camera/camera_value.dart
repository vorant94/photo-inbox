import 'package:camera/camera.dart';

extension CameraValueExt on CameraValue {
  get aspectRatioInverted => 1 / aspectRatio;
}
