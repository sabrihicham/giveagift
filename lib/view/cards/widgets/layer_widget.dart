import 'dart:async';

import 'package:flutter/material.dart';
import 'package:giveagift/view/cards/widgets/layer.dart';
import 'package:giveagift/view/cart/data/model/card.dart';



class LayerWidget extends StatefulWidget {
  final Layer layer;
  final Function() onDelete;
  final Function(bool isSelected)? onLayerSelected;

  const LayerWidget(
      {super.key,
      required this.layer,
      required this.onDelete,
      this.onLayerSelected});

  @override
  State<LayerWidget> createState() => _LayerWidgetState();
}

class _LayerWidgetState extends State<LayerWidget> {
  final FocusNode _focusNode = FocusNode();

  late OverlayEntry _posOverlayEntry;

  Timer? _timer;

  void _unselectAfter({Duration duration = const Duration(milliseconds: 2500)}) {
    _timer?.cancel();
    _timer = Timer(duration, () {
      widget.layer.isSelected.value = false;
    });
  }

  @override
  void initState() {
    widget.layer.onDelete = widget.onDelete;
    
    widget.layer.isSelected.addListener(() {
      if (widget.onLayerSelected != null && widget.layer.isSelected.value) {
        widget.onLayerSelected!(widget.layer.isSelected.value);
      }
      if (mounted) setState(() {});
    });

    // widget.layer.isSelected.addListener(() {
    //   if (widget.layer.isSelected.value) {
    //     this._posOverlayEntry =
    //         this._createPosOverlayEntry(widget.layer.containerKey);
    //     Overlay.of(context).insert(this._posOverlayEntry);
    //   } else {
    //     this._posOverlayEntry.remove();
    //   }
    // });

    widget.layer.rebuild.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((t) {
        if (mounted) setState(() {});
      });
    });

    _unselectAfter();
    
    super.initState();
  }

  OverlayEntry _createPosOverlayEntry(GlobalKey<State<StatefulWidget>> key) {
    return OverlayEntry(
      builder: (context) => StreamBuilder(
        stream: widget.layer.isDraging.stream,
        builder: (context, value) {
          print('isDragging: ${value.data}');
          final renderObject = key.currentContext!.findRenderObject() as RenderBox;

          var size = renderObject.size;
          var offset = renderObject.localToGlobal(Offset.zero);

          return Positioned(
            left: offset.dx,
            top: offset.dy - 30,
            width: size.width * widget.layer.scale,
            child: Material(
              color: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(5.0),
                child: Text('x: ${widget.layer.position.x.toStringAsFixed(2)}, y: ${widget.layer.position.y.toStringAsFixed(2)}'),
              ),
            ),
          );
        },
      ),
    );
  }

  void _rebuild() {
    if (mounted) {
      setState(() {});
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.layer.locked
          ? null
          : () {
              if (widget.layer.locked) return;
              widget.layer.isSelected.value = !widget.layer.isSelected.value;
              _unselectAfter();
              _rebuild();
            },
      behavior: widget.layer.isSelected.value ? HitTestBehavior.opaque : null,
      onScaleStart: (details) {
        if (widget.layer.locked) return;
        widget.layer.isSelected.value = true;

        // detect two fingers to reset internal factors
        // if (details.pointerCount == 2) {
        widget.layer.onScaleStart();
        // }

        // is selected
        if (!widget.layer.isSelected.value) {
          widget.layer.isSelected.value = true;
          _rebuild();
        }
      },
      onScaleUpdate: (d) {
        if (widget.layer.locked) return;
        _timer?.cancel();
        widget.layer.isDraging.add(true);
        widget.layer.position += Position(x: d.focalPointDelta.dx, y: d.focalPointDelta.dy);
        if (d.rotation != 0.0) {
          widget.layer.onRotateUpdate(d.rotation);
        }
        if (d.scale != 1.0) widget.layer.onScaleUpdate(d.scale);
        _rebuild();
      },
      onScaleEnd: (details) {
        widget.layer.isDraging.add(false);
        _unselectAfter();
      },
      child: widget.layer.build(context),
    );
  }
}