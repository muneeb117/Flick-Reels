import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
import '../../shared/app_logger.dart';
import '../state/teleprompter_state.dart';
import 'cameraService/camera_dectector.dart';

class CameraService extends CameraDetector {
  static final CameraService _singleton = CameraService._internal();
  factory CameraService() => _singleton;
  CameraService._internal();

  Future<void> startRecording(TeleprompterState teleprompterState) async {
    try {
      if (cameraController == null || !cameraController!.value.isInitialized) {
        AppLogger().debug('Error: select a camera first.');
        return;
      }

      if (cameraController!.value.isRecordingVideo) {
        // A recording is already started, do nothing.
        return;
      }

      if (!teleprompterState.isCameraReady()) {

        // This assumes you have a way to access an instance of TeleprompterState here
        CameraLensDirection direction = teleprompterState.getCurrentCameraDirection();
        await teleprompterState.prepareCamera(direction);
      }
      await cameraController!.startVideoRecording();
    } on CameraException {
      try {
        // Try to select the front camera again
        await selectFrontCamera();
        await cameraController!.startVideoRecording();
        Future.delayed(Duration.zero, () => teleprompterState.refresh());
      } on CameraException {
        rethrow;
      }
    }
  }Future<bool> stopRecording() async {
    if (cameraController == null || !cameraController!.value.isRecordingVideo) {
      return false;
    }

    try {
      final XFile file = await cameraController!.stopVideoRecording();
      final bool? success = await GallerySaver.saveVideo(file.path);
      if (success == true) {
        return true;
      }
    } catch (e) {
      AppLogger().error('Error stopping recording or saving to gallery: $e');
    }


    return false;
  }

  Future<void> pauseVideoRecording() async {
    if (cameraController == null || !cameraController!.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController!.pauseVideoRecording();
    } on CameraException catch (e) {
      AppLogger().error(e);
      rethrow;
    }
  }
}
