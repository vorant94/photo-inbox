import 'package:camera/camera.dart';

extension AspectRatioInverted on CameraValue {
  get aspectRatioInverted => 1 / aspectRatio;
}
