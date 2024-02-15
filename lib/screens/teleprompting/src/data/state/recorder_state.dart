import 'package:camera/camera.dart';
import 'package:flick_reels/screens/teleprompting/src/data/state/teleprompter_state.dart';

import '../services/camera_service.dart';

mixin RecorderState {
  bool _isRecording = false;
  bool _isCameraReady = false;
  final CameraService _cameraService = CameraService();

  // Updated to accept a CameraLensDirection parameter
  Future<void> prepareCamera(CameraLensDirection direction) async {
    await _cameraService.startCameras();
    if (direction == CameraLensDirection.front) {
      await _cameraService.selectFrontCamera();
    } else {
      await _cameraService.selectBackCamera();
    }
    _isCameraReady = true;
  }

  bool isRecording() => _isRecording;

  Future<void> startRecording(TeleprompterState teleprompterState) async {
    if (!_isCameraReady) {
      // Log or handle the case where the camera is not ready
      return;
    }
    _isRecording = true;
    await _cameraService.startRecording(teleprompterState);
  }

  Future<bool> stopRecording() async {
    if (!_isRecording) {
      // Log or handle the case where there is no recording to stop
      return false;
    }
    _isRecording = false;
    return await _cameraService.stopRecording();
  }

  bool isCameraReady() => _isCameraReady;

  void disposeCamera() {
    if (_cameraService.cameraController != null) {
      _cameraService.cameraController!.dispose();
      _isCameraReady = false;
    }
  }
}
