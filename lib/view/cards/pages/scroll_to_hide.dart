import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

/// A widget that hides its child when the user scrolls down and shows it again when the user scrolls up.
/// This behavior is commonly used to hide elements like a bottom navigation bar to provide a more immersive user experience.
class ScrollToHide extends StatefulWidget {
  /// Creates a `ScrollToHide` widget.
  ///
  /// The [child], [scrollController], and [height] parameters are required.
  /// The [duration] parameter is optional and defaults to 300 milliseconds.
  ///
  /// The [child] is the widget that you want to hide/show based on the scroll direction.
  ///
  /// The [scrollController] is the `ScrollController` that is connected to the scrollable widget in your app.
  /// This is used to track the scroll position and determine whether to hide or show the child widget.
  ///
  /// The [height] is the initial height of the child widget. When the widget is hidden, its height will be animated to 0.
  const ScrollToHide({
    super.key,
    required this.child,
    required this.scrollController,
    this.duration = const Duration(milliseconds: 300),
    required this.hideDirection,
    this.width,
    this.height,
    this.reverse = false,
  });

  /// The widget that you want to hide/show based on the scroll direction.
  final Widget child;

  /// The `ScrollController` that is connected to the scrollable widget in your app.
  /// This is used to track the scroll position and determine whether to hide or show the child widget.
  final ScrollController scrollController;

  /// The duration of the animation when the child widget is hidden or shown.
  final Duration duration;

  /// The initial height of the child widget. When the widget is hidden, its height will be animated to 0.
  final double? height;

  /// The initial width of the child widget, its width will be animated to 0 .by providing width you want the hide direction to be horizontal.
  final Axis hideDirection;

  /// The initial width of the child widget, its width will be animated to 0 .by providing width you want the hide direction to be horizontal.
  final double? width;

  /// If true, the widget will be shown when the user scrolls down and hidden when the user scrolls up.
  final bool reverse;

  @override
  State<ScrollToHide> createState() => _ScrollToHideState();
}

class _ScrollToHideState extends State<ScrollToHide> {
  bool isShown = true;

  @override
  void initState() {
    widget.scrollController.addListener(listen);
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: isBottomScreen ? 0.milliseconds : widget.duration,
      height: widget.hideDirection == Axis.vertical
          ? (isShown ? widget.height : 0)
          : widget.height,
      width: widget.hideDirection == Axis.horizontal
          ? (isShown ? widget.width : 0)
          : widget.width,
      curve: Curves.linear,
      clipBehavior: Clip.none,
      child: Wrap(
        children: [
          widget.child,
        ],
      ),
    );
  }

  bool get isBottomScreen => widget.scrollController.position.pixels != 0 && widget.scrollController.position.pixels + 100 >= widget.scrollController.position.maxScrollExtent;

  /// Shows the child widget if it is currently hidden.
  void show() {
    if (!isShown && mounted) {
      setState(() => isShown = true);
    }
  }

  /// Hides the child widget if it is currently shown.
  void hide() {
    if (isShown && mounted) {
      setState(
        () => isShown = false,
      );
    }
  }

  bool close = false;

  void listen() {
    final direction = widget.scrollController.position.userScrollDirection;
    if (close) return;
     
    if (direction == ScrollDirection.forward) {
      if (widget.reverse) {
        hide();
      } else {
        show();
      }
    } else if (direction == ScrollDirection.reverse) {
      if (widget.reverse) {
        show();
      } else {
        if (isBottomScreen) {
          close = true;
          
          show();

          Future.delayed(
            const Duration(milliseconds: 70), 
            () async {
              await widget.scrollController.position.moveTo(
                widget.scrollController.position.maxScrollExtent, 
                duration: 1000.milliseconds, 
                curve: Curves.linear
              );

              close = false;
            }
          );

        } else {
          hide();
        }
      }
    }
  }
}
