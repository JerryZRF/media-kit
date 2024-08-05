/// This file is a part of media_kit (https://github.com/media-kit/media-kit).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:media_kit_video/src/subtitle/stroke_text.dart';

import 'package:media_kit_video/src/video_controller/video_controller.dart';

/// {@template subtitle_view}
/// SubtitleView
/// ------------
///
/// [SubtitleView] widget is used to display the subtitles on top of the [Video].
class SubtitleView extends StatefulWidget {
  /// The [VideoController] reference to control this [SubtitleView] output.
  final VideoController controller;

  /// The configuration to be used for the subtitles.
  final SubtitleViewConfiguration configuration;

  /// {@macro subtitle_view}
  const SubtitleView({
    Key? key,
    required this.controller,
    required this.configuration,
  }) : super(key: key);

  @override
  SubtitleViewState createState() => SubtitleViewState();
}

class SubtitleViewState extends State<SubtitleView> {
  late List<String> subtitle = widget.controller.player.state.subtitle;
  late EdgeInsets padding = widget.configuration.padding;
  late Duration duration = const Duration(milliseconds: 100);

  // The [StreamSubscription] to listen to the subtitle changes.
  StreamSubscription<List<String>>? subscription;

  // The reference width for calculating the visible text scale factor.
  static const kTextScaleFactorReferenceWidth = 1920.0;
  // The reference height for calculating the visible text scale factor.
  static const kTextScaleFactorReferenceHeight = 1080.0;

  @override
  void initState() {
    subscription = widget.controller.player.stream.subtitle.listen((value) {
      setState(() {
        subtitle = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  /// Sets the padding to be used for the subtitles.
  ///
  /// The [duration] argument may be specified to set the duration of the animation.
  void setPadding(
    EdgeInsets padding, {
    Duration duration = const Duration(milliseconds: 100),
  }) {
    if (this.duration != duration) {
      setState(() {
        this.duration = duration;
      });
    }
    setState(() {
      this.padding = padding;
    });
  }

  /// {@macro subtitle_view}
  @override
  Widget build(BuildContext context) {
    padding = widget.configuration.padding;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the visible text scale factor.
        // final textScaleFactor = widget.configuration.textScaleFactor ??
        //     MediaQuery.of(context).textScaleFactor *
        //         sqrt(
        //           ((constraints.maxWidth * constraints.maxHeight) /
        //                   (kTextScaleFactorReferenceWidth *
        //                       kTextScaleFactorReferenceHeight))
        //               .clamp(0.0, 1.0),
        //         );
        return Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            padding: padding,
            duration: duration,
            alignment: Alignment.bottomCenter,
            child: StrokeText(
              [
                for (final line in subtitle)
                  if (line.trim().isNotEmpty) line.trim(),
              ].join('\n'),
              fontSize: widget.configuration.fontSize,
              color: widget.configuration.color,
              borderColor: widget.configuration.borderColor,
              fontFamily: widget.configuration.fontFamily,
            ),
          ),
        );
      },
    );
  }
}

/// {@template subtitle_view_configuration}
/// SubtitleViewConfiguration
/// -------------------------
///
/// Configurable options for customizing the [SubtitleView] behaviour.
/// {@endtemplate}
class SubtitleViewConfiguration {
  /// Whether the subtitles should be visible or not.
  final bool visible;

  /// The text color to be used for the subtitles.
  final Color color;

  /// The border color to be used for the subtitles.
  final Color? borderColor;

  /// The text size to be used for the subtitles.
  final double fontSize;

  // The font to be used for the subtitles.
  final String? fontFamily;

  /// The text scale factor to be used for the subtitles.

  /// The padding to be used for the subtitles.
  final EdgeInsets padding;

  /// {@macro subtitle_view_configuration}
  const SubtitleViewConfiguration({
    this.visible = true,
    this.color = Colors.pink,
    this.borderColor = Colors.white,
    this.fontSize = 40,
    this.fontFamily,
    this.padding = const EdgeInsets.fromLTRB(
      16.0,
      0.0,
      16.0,
      24.0,
    ),
  });
}
