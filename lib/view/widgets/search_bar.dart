import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/app_navigation.dart';
import 'package:giveagift/constants/enums.dart';
import 'package:giveagift/main.dart';
import 'package:giveagift/view/cards/controller/cards_controller.dart';
import 'package:giveagift/view/cards/pages/ready_card_page.dart';

class SearchBar extends StatefulWidget {
  final EdgeInsetsGeometry margin;
  final Function(String value)? onSearch;

  const SearchBar({
    super.key,
    this.onSearch,
    this.margin =
        const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> with RouteAware {
  final TextEditingController _searchController = TextEditingController();
  CardsController get controller => Get.find();
  OverlayEntry? _searchOverlayEntry;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    appNavigationKey.currentState?.selectedTabStream.stream.listen((event) {
      if ((event != Pages.home && event != Pages.explore)) {
        _closeSearch();
      } else {
        if (!_focusNode.hasFocus) {
          if (_searchOverlayEntry != null) {
            _closeSearch();
          }
        } else {
          _showSearch();
        }
      }
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _closeSearch();
      } else {
        _showSearch();
      }
    });
    super.initState();
  }

  void _closeSearch() {
    _searchOverlayEntry?.remove();
    _searchOverlayEntry = null;
    controller.readyCardsSourceRepository.emptyFilter();
    controller.filterReadyCardsLocaly();
  }

  void _showSearch() {
    if (_searchOverlayEntry != null) {
      _closeSearch();
    }
    _searchOverlayEntry = _createSearchOverlayEntry();
    Overlay.of(context).insert(_searchOverlayEntry!);

    widget.onSearch?.call(_searchController.text);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // routeObserver is the global variable we created before
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPushNext() {
    _closeSearch();
  }

  @override
  void didPopNext() {
    if (ModalRoute.of(context) is PageRoute &&
        !ModalRoute.of(context)!.isCurrent) {
      _closeSearch();
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  OverlayEntry _createSearchOverlayEntry() {
    final renderObject = context.findRenderObject() as RenderBox;

    var size = renderObject.size;
    var offset = renderObject.localToGlobal(Offset.zero);

    return OverlayEntry(
      canSizeOverlay: true,
      builder: (context) => Positioned(
        top: offset.dy + size.height,
        // left: offset.dx,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - offset.dy - size.height,
        child: TapRegion(
          // onTapOutside: (event) {
          //   // if click dismiss
          //   if (event.down) {
          //     _closeSearch();
          //   }
          // },
          child: Material(
            color: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
              ),
              child: Scaffold(
                body: ReadyToUsePage(
                  controller: Get.find(),
                  hideAppBar: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 57.h,
      margin: widget.margin,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: Get.isDarkMode ? 5 : 19.9,
            spreadRadius: 0.2,
            color: Get.isDarkMode ? const Color.fromARGB(255, 0, 0, 0)! : Color.fromRGBO(168, 168, 168, 0.25),
          )
        ],
      ),
      child: Container(
        color: Get.isDarkMode ? Colors.white.withOpacity(0.1) : null,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                'assets/icons/search.svg',
                color: const Color.fromRGBO(191, 191, 191, 1),
                fit: BoxFit.contain,
                width: 20.w,
                height: 20.w,
              ),
            ),
            Expanded(
              child: TextField(
                focusNode: _focusNode,
                controller: _searchController,
                style: TextStyle(fontSize: 18.sp),
                onChanged: (value) {
                  if (mounted) {
                    setState(() {});
                  }
        
                  if (value.isEmpty) {
                    _closeSearch();
                    return;
                  }
        
                  _showSearch();
                },
                decoration: InputDecoration(
                  hintText: 'search'.tr,
                  hintStyle: TextStyle(
                    color: const Color.fromRGBO(191, 191, 191, 1),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(left: 20),
                ),
              ),
            ),
            if (_focusNode.hasFocus)
              IconButton(
                onPressed: () {
                  _searchController.clear();
                  _closeSearch();
                  _focusNode.unfocus();
                },
                icon: const Icon(
                  Icons.close,
                  color: Color.fromRGBO(191, 191, 191, 1),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
