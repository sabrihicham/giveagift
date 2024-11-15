
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// create GetListner with listner and builder
//
// class GetBuilder<T extends GetxController> extends StatefulWidget {
//   final GetControllerBuilder<T> builder;
//   final bool global;
//   final Object? id;
//   final String? tag;
//   final bool autoRemove;
//   final bool assignId;
//   final Object Function(T value)? filter;
//   final void Function(GetBuilderState<T> state)? initState,
//       dispose,
//       didChangeDependencies;
//   final void Function(GetBuilder oldWidget, GetBuilderState<T> state)?
//       didUpdateWidget;
//   final T? init;

//   const GetBuilder({
//     Key? key,
//     this.init,
//     this.global = true,
//     required this.builder,
//     this.autoRemove = true,
//     this.assignId = false,
//     this.initState,
//     this.filter,
//     this.tag,
//     this.dispose,
//     this.id,
//     this.didChangeDependencies,
//     this.didUpdateWidget,
//   }) : super(key: key);

//   // static T of<T extends GetxController>(
//   //   BuildContext context, {
//   //   bool rebuild = false,
//   // }) {
//   //   var widget = rebuild
//   //       ? context
//   //       .dependOnInheritedWidgetOfExactType<_InheritedGetxController<T>>()
//   //       : context
//   //           .getElementForInheritedWidgetOfExactType<
//   //               _InheritedGetxController<T>>()
//   //           ?.widget;

//   //   if (widget == null) {
//   //     throw 'Error: Could not find the correct dependency.';
//   //   } else {
//   //     return (widget as _InheritedGetxController<T>).model;
//   //   }
//   // }

//   @override
//   GetBuilderState<T> createState() => GetBuilderState<T>();
// }

// class GetBuilderState<T extends GetxController> extends State<GetBuilder<T>>
//     with GetStateUpdaterMixin {
//   T? controller;
//   bool? _isCreator = false;
//   VoidCallback? _remove;
//   Object? _filter;

//   @override
//   void initState() {
//     // _GetBuilderState._currentState = this;
//     super.initState();
//     widget.initState?.call(this);

//     var isRegistered = GetInstance().isRegistered<T>(tag: widget.tag);

//     if (widget.global) {
//       if (isRegistered) {
//         if (GetInstance().isPrepared<T>(tag: widget.tag)) {
//           _isCreator = true;
//         } else {
//           _isCreator = false;
//         }
//         controller = GetInstance().find<T>(tag: widget.tag);
//       } else {
//         controller = widget.init;
//         _isCreator = true;
//         GetInstance().put<T>(controller!, tag: widget.tag);
//       }
//     } else {
//       controller = widget.init;
//       _isCreator = true;
//       controller?.onStart();
//     }

//     if (widget.filter != null) {
//       _filter = widget.filter!(controller!);
//     }

//     _subscribeToController();
//   }

//   /// Register to listen Controller's events.
//   /// It gets a reference to the remove() callback, to delete the
//   /// setState "link" from the Controller.
//   void _subscribeToController() {
//     _remove?.call();
//     _remove = (widget.id == null)
//         ? controller?.addListener(
//             _filter != null ? _filterUpdate : getUpdate,
//           )
//         : controller?.addListenerId(
//             widget.id,
//             _filter != null ? _filterUpdate : getUpdate,
//           );
//   }

//   void _filterUpdate() {
//     var newFilter = widget.filter!(controller!);
//     if (newFilter != _filter) {
//       _filter = newFilter;
//       getUpdate();
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     widget.dispose?.call(this);
//     if (_isCreator! || widget.assignId) {
//       if (widget.autoRemove && GetInstance().isRegistered<T>(tag: widget.tag)) {
//         GetInstance().delete<T>(tag: widget.tag);
//       }
//     }

//     _remove?.call();

//     controller = null;
//     _isCreator = null;
//     _remove = null;
//     _filter = null;
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     widget.didChangeDependencies?.call(this);
//   }

//   @override
//   void didUpdateWidget(GetBuilder oldWidget) {
//     super.didUpdateWidget(oldWidget as GetBuilder<T>);
//     // to avoid conflicts when modifying a "grouped" id list.
//     if (oldWidget.id != widget.id) {
//       _subscribeToController();
//     }
//     widget.didUpdateWidget?.call(oldWidget, this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // return _InheritedGetxController<T>(
//     //   model: controller,
//     //   child: widget.builder(controller),
//     // );
//     return widget.builder(controller!);
//   }
// }

class GetListner<T extends GetxController> extends StatefulWidget {
  final GetControllerBuilder<T> builder;
  final bool global;
  final Object? id;
  final String? tag;
  final bool autoRemove;
  final bool assignId;
  final Object Function(T value)? filter;
  final void Function(GetListnerState<T> state)? initState,
      dispose,
      didChangeDependencies;
  final void Function(GetListner oldWidget, GetListnerState<T> state)?
      didUpdateWidget;
  final T? init;

  const GetListner({
    Key? key,
    this.init,
    this.global = true,
    required this.builder,
    this.autoRemove = true,
    this.assignId = false,
    this.initState,
    this.filter,
    this.tag,
    this.dispose,
    this.id,
    this.didChangeDependencies,
    this.didUpdateWidget,
  }) : super(key: key);

  @override
  GetListnerState<T> createState() => GetListnerState<T>();
}

class GetListnerState<T extends GetxController> extends State<GetListner<T>>
    with GetStateUpdaterMixin {
  T? controller;
  bool? _isCreator = false;
  VoidCallback? _remove;
  Object? _filter;

  @override
  void initState() {
    // _GetListnerState._currentState = this;
    super.initState();
    widget.initState?.call(this);

    var isRegistered = GetInstance().isRegistered<T>(tag: widget.tag);

    if (widget.global) {
      if (isRegistered) {
        if (GetInstance().isPrepared<T>(tag: widget.tag)) {
          _isCreator = true;
        } else {
          _isCreator = false;
        }
        controller = GetInstance().find<T>(tag: widget.tag);
      } else {
        controller = widget.init;
        _isCreator = true;
        GetInstance().put<T>(controller!, tag: widget.tag);
      }
    } else {
      controller = widget.init;
      _isCreator = true;
      controller?.onStart();
    }

    if (widget.filter != null) {
      _filter = widget.filter!(controller!);
    }

    _subscribeToController();
  }

  /// Register to listen Controller's events.
  /// It gets a reference to the remove() callback, to delete the
  /// setState "link" from the Controller.
  void _subscribeToController() {
    _remove?.call();
    _remove = (widget.id == null)
        ? controller?.addListener(
            _filter != null ? _filterUpdate : getUpdate,
          )
        : controller?.addListenerId(
            widget.id,
            _filter != null ? _filterUpdate : getUpdate,
          );
  }

  void _filterUpdate() {
    var newFilter = widget.filter!(controller!);
    if (newFilter != _filter) {
      _filter = newFilter;
      getUpdate();
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.dispose?.call(this);
    if (_isCreator! || widget.assignId) {
      if (widget.autoRemove && GetInstance().isRegistered<T>(tag: widget.tag)) {
        GetInstance().delete<T>(tag: widget.tag);
      }
    }

    _remove?.call();

    controller = null;
    _isCreator = null;
    _remove = null;
    _filter = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependencies?.call(this);
  }

  @override
  void didUpdateWidget(GetListner oldWidget) {
    super.didUpdateWidget(oldWidget as GetListner<T>);
    // to avoid conflicts when modifying a "grouped" id list.
    if (oldWidget.id != widget.id) {
      _subscribeToController();
    }
    widget.didUpdateWidget?.call(oldWidget, this);
  }

  @override
  Widget build(BuildContext context) {
    // return _InheritedGetxController<T>(
    //   model: controller,
    //   child: widget.builder(controller),
    // );
    return widget.builder(controller!);
  }
}