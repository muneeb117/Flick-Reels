import 'package:flick_reels/screens/teleprompting/src/ui/textScroller/text_scroller_options_component.dart';
import 'package:flick_reels/screens/teleprompting/src/ui/textScroller/text_scroller_oriented_component.dart';
import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:provider/provider.dart';

import '../../data/state/teleprompter_state.dart';
import '../../shared/app_logger.dart';
import '../../shared/my_snack_bar.dart';
import '../timer/stopwatch_widget.dart';

/// This class represents the TextScrollerComponent, a StatefulWidget that provides
/// functionality for displaying text and controlling its scrolling behavior.
class TextScrollerComponent extends StatefulWidget {
  /// The title of the widget, typically used as the app bar title.
  final String title;

  /// The text content to be displayed and scrolled.
  final String text;

  /// A message to be displayed when the recording is successfully saved to the gallery.
  final String savedToGallery;

  /// An error message to be displayed when there is an issue saving the recording to the gallery.
  final String errorSavingToGallery;

  /// Widget to be used as start recording
  final Widget startRecordingButton;

  /// Widget to be used as stop recording
  final Widget stopRecordingButton;

  /// An optional shape border for the floating action button.
  final ShapeBorder? floatingButtonShape;

  const TextScrollerComponent({
    required this.title,
    required this.text,
    required this.savedToGallery,
    required this.errorSavingToGallery,
    required this.startRecordingButton,
    required this.stopRecordingButton,
    this.floatingButtonShape,
    super.key,
  });

  @override
  _TextScrollerComponentState createState() => _TextScrollerComponentState();
}

class _TextScrollerComponentState extends State<TextScrollerComponent>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final TeleprompterState teleprompterState =
        Provider.of<TeleprompterState>(context, listen: false);

    final ScrollController scrollController = ScrollController(
        initialScrollOffset: teleprompterState.getScrollPosition());
    scrollController.addListener(() {
      teleprompterState.setScrollPosition(scrollController.offset);
    });
    AppLogger()
        .debug('scroll controller clients: ${scrollController.hasClients}');

    if (teleprompterState.isScrolling()) {
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          final double maxExtent = scrollController.position.maxScrollExtent;
          final double distanceDifference = maxExtent - scrollController.offset;
          final double durationDouble =
              distanceDifference / teleprompterState.getSpeedFactor();

          final double max = scrollController.position.maxScrollExtent;
          AppLogger().debug('animate to $max');
          scrollController.animateTo(max,
              duration: Duration(seconds: durationDouble.toInt()),
              curve: Curves.linear);
        },
      );
    } else {
      if (scrollController.hasClients) {
        Future.delayed(Duration.zero, () {
          scrollController.animateTo(scrollController.offset,
              duration: Duration.zero, curve: Curves.linear);
        });
      }
    }

    return Scaffold(
      backgroundColor:Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: teleprompterState.isRecording()
            ? const StopwatchWidget()
            : FittedBox(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.black,
                  ),

                ),
              ),
        actions: [
          teleprompterState.isRecording()
              ? IconButton(
                  onPressed: () async {
                    final bool success =
                        await teleprompterState.stopRecording();
                    teleprompterState.refresh();

                    if (success && mounted) {
                      MySnackBar.show(
                        context: context,
                        text: widget.savedToGallery,
                      );
                    } else if (mounted) {
                      MySnackBar.showError(
                        context: context,
                        text: widget.errorSavingToGallery,
                      );
                    }
                  },
                  icon: widget.stopRecordingButton,
                )
              : IconButton(
                  onPressed: () {
                    teleprompterState.startRecording(teleprompterState);
                    teleprompterState.refresh();
                  },
                  icon: widget.startRecordingButton,
                )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: NativeDeviceOrientationReader(
              builder: (context) {
                final orientation =
                    NativeDeviceOrientationReader.orientation(context);
                AppLogger().debug('Received new orientation: $orientation');

                return TextScrollerOrientedComponent(
                  scrollController,
                  orientation,
                  text: widget.text,
                );
              },
            ),
          ),
          TextScrollerOptionsComponent(
              index: teleprompterState.getOptionIndex(),
              updateIndex: (int index) {
                teleprompterState.updateOptionIndex(index);
                teleprompterState.refresh();
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: widget.floatingButtonShape,
        onPressed: teleprompterState.toggleStartStop,
        child: teleprompterState.isScrolling()
            ? const Icon(Icons.pause)
            : const Icon(Icons.play_arrow),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
