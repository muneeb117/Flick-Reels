import 'package:camera/camera.dart';
import 'package:flick_reels/screens/teleprompting/src/data/state/recorder_state.dart';
import 'package:flick_reels/screens/teleprompting/src/data/state/teleprompter_settings_state.dart';
import 'package:flutter/material.dart';
import '../../shared/app_logger.dart';
import '../../ui/textScroller/options/teleprompter_color_picker_component.dart';

/// Provider to manage the state of the teleprompter
import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Ensure CameraLensDirection is accessible
import '../../shared/app_logger.dart';
import '../../ui/textScroller/options/teleprompter_color_picker_component.dart';

/// Provider to manage the state of the teleprompter
class TeleprompterState with ChangeNotifier, TeleprompterSettingsState, RecorderState {
  bool _scrolling = false; // Indicates if the teleprompter is scrolling
  int _optionIndex = 0; // Currently selected option index
  double _scrollPosition = 0; // Current scroll position
  CameraLensDirection _cameraDirection = CameraLensDirection.front; // Tracks the current camera direction

  // Constructor initializes the teleprompter state
  TeleprompterState(BuildContext context, Color defaultTextColor) {
    // Modify to use dynamic camera direction based on user preference or default setting
    prepareCamera(_cameraDirection).then((_) => refresh()); // Use updated prepareCamera method
    loadSettings(context, defaultTextColor).then((_) => refresh());
  }
// In TeleprompterState
  CameraLensDirection getCurrentCameraDirection() {
    return _cameraDirection;
  }

  // Toggle camera direction and re-prepare the camera
  void toggleCameraDirection() {
    _cameraDirection = _cameraDirection == CameraLensDirection.front ? CameraLensDirection.back : CameraLensDirection.front;
    prepareCamera(_cameraDirection).then((_) {
      AppLogger().debug('Camera toggled to: $_cameraDirection');
      refresh(); // Ensure the UI and camera preview are refreshed to reflect the change
    });
  }
  // Returns true if the teleprompter is scrolling, false otherwise
  bool isScrolling() => _scrolling;

  // Sets scrolling to false when the teleprompter completes scrolling
  void completedScroll() {
    stopScroll();
  }

  // Stops scrolling if the teleprompter is currently scrolling
  void stopScroll() {
    if (_scrolling) {
      _scrolling = false;
      refresh();
    }
  }

  // Toggles scrolling state between start and stop
  void toggleStartStop() {
    _scrolling = !_scrolling;
    refresh();
  }


  void refresh() {
    notifyListeners();
    AppLogger().debug('Teleprompter state refresh(), Camera Direction: $_cameraDirection');
  }

  // Increases the value for the given option index
  void increaseValueForIndex(int index) {
    setStepValueForIndex(index, getSteps()[index]!);
    refresh();
  }

  // Decreases the value for the given option index
  void decreaseValueForIndex(int index) {
    setStepValueForIndex(index, getSteps()[index]! * -1);
    refresh();
  }

  // Displays a color picker dialog when the option is clicked
  void hit(int index, BuildContext context) {
    showDialog<Widget>(
        context: context,
        builder: (
          BuildContext context,
        ) =>
            TeleprompterColorPickerComponent(this));
  }

  // Getter for the current option index
  int getOptionIndex() => _optionIndex;

  // Updates the current option index
  void updateOptionIndex(int index) => _optionIndex = index;

  // Getter for the current scroll position
  double getScrollPosition() => _scrollPosition;

  // Sets the current scroll position
  void setScrollPosition(double offset) => _scrollPosition = offset;
}
