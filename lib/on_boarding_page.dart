import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/app_navigation.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

double map(
    double x, double in_min, double in_max, double out_min, double out_max) {
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacity;
  late Animation<double> rotation;
  late Animation<double> logoAnimation;

  Future<LottieComposition?> customDecoder(List<int> bytes) {
    return LottieComposition.decodeZip(bytes, filePicker: (files) {
      return files.firstWhereOrNull(
          (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'));
    });
  }

  // late Future<LottieComposition> compositionFuture;

  @override
  void initState() {
    FlutterNativeSplash.remove();

    // compositionFuture = AssetLottie(
    //   'assets/lottie/04.json',
    //   // bundle: NetworkAssetBundle(Uri.directory(Platform.script.path)),
    // ).load()..then((value) {
    //   composition = value;

    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //     controller?.duration = value.duration;
    //     controller!.forward();
    //   });

    // },);

    controller = AnimationController(
      // duration: const Duration(seconds: 10),
      vsync: this,
    );

    opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller.view,
        curve: const Interval(
          0.500,
          0.800,
          curve: Curves.ease,
        ),
      ),
    );

    rotation = Tween<double>(
      begin: -pi,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: controller.view,
        curve: const Interval(
          0.200,
          0.700,
          curve: Curves.easeOutBack,
        ),
      ),
    );
    
    logoAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller.view,
        curve: const Interval(
          0.500,
          0.900,
          curve: Curves.linear,
        ),
      ),
    );

    SharedPrefs.instance.setFirstTime();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        controller.duration = 5.seconds;
        controller.forward();
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    // composition = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Positioned(
          //   left: 577.w,
          //   top: 651.h,
          //   child: Opacity(
          //     opacity: 0.50,
          //     child: Container(
          //       width: 349.w,
          //       height: 322.h,
          //       decoration: const ShapeDecoration(
          //         gradient: SweepGradient(
          //           center: Alignment(0.14, 0.86),
          //           startAngle: 0,
          //           endAngle: 0.72,
          //           colors: [
          //             Color(0xFFFFB459),
          //             Color(0xFF171766),
          //             Color(0xFFEAA143),
          //             Colors.white
          //           ],
          //         ),
          //         shape: OvalBorder(),
          //       ),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   left: 57.w,
          //   top: -142.h,
          //   child: Container(
          //     width: 496.w,
          //     height: 496.w,
          //     decoration: ShapeDecoration(
          //       shape: OvalBorder(
          //         side: BorderSide(width: 3.w, color: const Color(0xFFF7F9FF)),
          //       ),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   left: 148.w,
          //   top: -327.h,
          //   child: Container(
          //     width: 635.w,
          //     height: 635.w,
          //     decoration: const ShapeDecoration(
          //       color: Color(0xFFF7F9FF),
          //       shape: OvalBorder(),
          //     ),
          //   ),
          // ),
          // DotLottieLoader.fromAsset(
          //   "assets/lottie/logo_cards.lottie",
          //   errorBuilder: (context, error, stackTrace) {
          //     return const Center(
          //       child: Text('Error loading animation'),
          //     );
          //   },
          //   frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
          //     if (dotlottie != null) {
          //       return Lottie.memory(
          //         dotlottie.animations.values.single,
          //         // imageProviderFactory: (asset) {
          //         //   timer.start();
          //         //   print("Start");
          //         //   final compressed_file = waitFor<XFile?>(ImageUtils.testCompressAndGetFile(File.fromRawPath(dotlottie.images[asset.fileName]!)));

          //         //   final compressed_image = compressed_file == null ? null : Image.file(File.fromRawPath(waitFor<Uint8List>(compressed_file.readAsBytes()))).image;

          //         //   timer.stop();

          //         //   print('Time: ${timer.elapsedMilliseconds / 1000}ms');

          //         //   return compressed_image;
          //         // },
          //       );
          //     } else {
          //       return const SizedBox.shrink();
          //     }
          //   },
          // ),
          // FutureBuilder(
          //   future: compositionFuture,
          //   builder: (context, snapshot) {
          //     return
          Lottie.asset(
            'assets/lottie/alll.json',
            // 'assets/lottie/logo_cards.json',
            // composition: snapshot.data == null ? null : composition,
            controller: controller,
            // filterQuality: FilterQuality.medium,
            renderCache: RenderCache.drawingCommands,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fill,
            // decoder: customDecoder,
            // renderCache: RenderCache.raster,
            onLoaded: (composition) {
              controller.duration = composition.duration;
              // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                controller.forward();
              // });
            },
          ),
          //   }
          // ),

          // Positioned(
          //   left: 119.17.w,
          //   top: 50.h,
          //   child: Transform.translate(
          //     offset: Offset(0, -300.h),
          //     child: AnimatedBuilder(
          //       animation: rotation,
          //       child: const Card1(),
          //       builder: (context, child) {
          //         return Transform.rotate(
          //           angle: rotation.value,
          //           child: Transform.translate(
          //             offset: Offset(0, 300.h),
          //             child: child,
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),

          // Positioned(
          //   left: 112.64.w,
          //   top: 450.h,
          //   child: Container(
          //     clipBehavior: Clip.antiAlias,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(100)
          //     ),
          //     child: Lottie.asset(
          //       'assets/lottie/splash_bg_logo.json',
          //       repeat: false,
          //       controller: logoAnimation,
          //       width: 700 *  MediaQuery.of(context).size.width / 1562,
          //       height: 530 * MediaQuery.of(context).size.height / 3384,
          //     ),
          //   ),
          // ),

          // Positioned(
          //   right: -135.w,
          //   top: 183.29.h,
          //   child: Transform.translate(
          //     offset: Offset(0, -300.h),
          //     child: AnimatedBuilder(
          //       animation: rotation,
          //       child: const Card2(),
          //       builder: (context, child) {
          //         return Transform.rotate(
          //           angle: rotation.value,
          //           child: Transform.translate(
          //             offset: Offset(0, 300.h),
          //             child: child,
          //             // child: rotation.status == AnimationStatus.forward ? child :
          //             //   Container(
          //             //     clipBehavior: Clip.antiAlias,
          //             //     decoration: BoxDecoration(
          //             //       borderRadius: BorderRadius.circular(36.33.r)
          //             //     ),
          //             //     child: Shimmer(
          //             //       duration: Duration(seconds: 2), //Default value
          //             //       interval: Duration(seconds: 3), //Default value: Duration(seconds: 0)
          //             //       color: Colors.white, //Default value
          //             //       colorOpacity: 0.3 , //Default value
          //             //       enabled: true, //Default value
          //             //       direction: const ShimmerDirection.fromRTLB(),  //Default Value
          //             //       child: child!,
          //             //     ),
          //             //   ),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),

          // RotationTransition(
          //   turns: rotation,
          //   child: ,
          // ),
          // RotationTransition(
          //   turns: rotation,
          //   child: const Card2()
          // ),

          // Positioned(
          //   left: 16.w,
          //   top: 592.h,
          //   child: SizedBox(
          //     width: 343.w,
          //     child: FadeTransition(
          //       opacity: opacity,
          //       child: Text(
          //         'أرسل واستلم بطاقات الهدايا بسهولة واحتفل باللحظات المميزة.',
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //           color: Colors.black,
          //           fontFamily: 'Cairo',
          //           fontSize: 20.sp,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   left: -153.60.w,
          //   top: 705.h,
          //   child: Container(
          //     width: 372.w,
          //     height: 372.w,
          //     decoration: ShapeDecoration(
          //       shape: RoundedRectangleBorder(
          //         side: BorderSide(width: 2.w, color: const Color(0xFFF1F4FF)),
          //       ),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   left: -264.70.w,
          //   top: 764.30.h,
          //   child: Container(
          //     width: 372.w,
          //     height: 372.w,
          //     decoration: ShapeDecoration(
          //       shape: RoundedRectangleBorder(
          //         side: BorderSide(width: 2.w, color: const Color(0xFFF1F4FF)),
          //       ),
          //     ),
          //   ),
          // ),
          Positioned(
            left: 16.w,
            top: 690.h,
            child: SizedBox(
              width: 343.w,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FadeTransition(
                      opacity: opacity,
                      child: Container(
                        height: 60.h,
                        // padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                        decoration: ShapeDecoration(
                          color: const Color(0xFF222A40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x33111F3A),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: CupertinoButton(
                          onPressed: () => Get.off(
                            () => AppNavigation(
                              key: appNavigationKey,
                              navigateToLogin: true,
                            )
                          ),
                          padding: EdgeInsets.zero,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'دخول',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Cairo',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16.w,
            top: 76.h,
            child: FadeTransition(
              opacity: opacity,
              child: CupertinoButton(
                onPressed: () => Get.to(() => AppNavigation(key: appNavigationKey)),
                padding: EdgeInsets.zero,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.w, 
                        color: const Color(0xFFF7F9FF),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0xFFFFFFFF),
                        blurRadius: 5.60,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'التسجيل لاحقاً',
                        style: TextStyle(
                          color: const Color(0xFF111F3A),
                          fontFamily: 'Cairo',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Card1 extends StatelessWidget {
  const Card1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      // angle: pi / 180 * 5,
      angle: 0,
      child: Image.asset(
        'assets/images/card_1.png',
        fit: BoxFit.fill,
        width: 366.w,
        height: 265.81.h,
      ),
      // child: Container(
      //   width: 366.w,
      //   height: 265.81.h,
      //   clipBehavior: Clip.antiAlias,
      //   decoration: ShapeDecoration(
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(36.33),
      //     ),
      //   ),
      //   child: Stack(
      //     children: [
      //       Positioned(
      //         left: 0,
      //         top: -0.65,
      //         child: Container(
      //           width: 366.w,
      //           height: 267.04.h,
      //           decoration: ShapeDecoration(
      //             color: const Color(0xFF222A40),
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(36.33),
      //             ),
      //           ),
      //         ),
      //       ),
      //       Positioned(
      //         left: 26.34.w,
      //         top: 25.37.h,
      //         child: SizedBox(
      //           width: 360.13.w,
      //           height: 294.91.h,
      //           child: Stack(
      //             children: [
      //               Positioned(
      //                 left: 117.16.w,
      //                 top: 113.87.h,
      //                 child: SizedBox(
      //                   width: 242.97.w,
      //                   height: 181.03.h,
      //                   child: Stack(
      //                     children: [
      //                       Positioned(
      //                         left: 81.10.w,
      //                         top: 49.97.h,
      //                         child: Opacity(
      //                           opacity: 0.50,
      //                           child: Container(
      //                             width: 134.63.w,
      //                             height: 134.63.w,
      //                             decoration: const ShapeDecoration(
      //                               color: Color(0xFF4E78CA),
      //                               shape: OvalBorder(),
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                       Positioned(
      //                         left: -0,
      //                         top: 26.04.h,
      //                         child: Container(
      //                           width: 113.76.w,
      //                           height: 113.76.w,
      //                           decoration: const ShapeDecoration(
      //                             color: Color(0xFF4E78CA),
      //                             shape: OvalBorder(),
      //                           ),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //               Positioned(
      //                 left: 0,
      //                 top: 43.94.h,
      //                 child: Text(
      //                   'بطاقات الهدايا المخصصة',
      //                   textDirection: TextDirection.rtl,
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontFamily: 'Cairo',
      //                     fontSize: 21.80.sp,
      //                     fontWeight: FontWeight.w400,
      //                   ),
      //                 ),
      //               ),
      //               Positioned(
      //                 left: 5.57.w,
      //                 top: 0,
      //                 child: SizedBox(
      //                   width: 43.59.w,
      //                   height: 43.59.w,
      //                   child: Stack(
      //                     children: [
      //                       Positioned(
      //                         left: 0,
      //                         top: 0,
      //                         child: Container(
      //                           width: 43.59.w,
      //                           height: 43.59.w,
      //                           decoration: const ShapeDecoration(
      //                             color: Color(0x4CF5F5F5),
      //                             shape: OvalBorder(),
      //                           ),
      //                         ),
      //                       ),
      //                       Positioned(
      //                         left: 17.26.w,
      //                         top: 9.99.h,
      //                         child: Text(
      //                           '1',
      //                           style: TextStyle(
      //                             color: Colors.white,
      //                             fontSize: 18.16.sp,
      //                             fontFamily: 'Raleway',
      //                             fontWeight: FontWeight.w600,
      //                           ),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //               Positioned(
      //                 left: 0.91.w,
      //                 top: 86.02.h,
      //                 child: SizedBox(
      //                   width: 311.51.w,
      //                   height: 127.75.h,
      //                   child: Stack(
      //                     children: [
      //                       Positioned(
      //                         left: 0,
      //                         top: 62.36.h,
      //                         child: Container(
      //                           width: 311.51.w,
      //                           height: 65.39.h,
      //                           decoration: ShapeDecoration(
      //                             color: const Color(0x33F5F5F5),
      //                             shape: RoundedRectangleBorder(
      //                               borderRadius: BorderRadius.circular(36.33),
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                       Positioned(
      //                         left: 8.14.w,
      //                         top: 0,
      //                         child: SizedBox(
      //                           width: 212.w,
      //                           height: 114.40.h,
      //                           child: Stack(
      //                             children: [
      //                               Positioned(
      //                                 left: 0,
      //                                 top: 0,
      //                                 child: Text(
      //                                   'أنشئ بطاقة هدايا مخصصة لأحبائك',
      //                                   textDirection: TextDirection.rtl,
      //                                   style: TextStyle(
      //                                     color: Colors.white,
      //                                     fontFamily: 'Cairo',
      //                                     fontSize: 14.53.sp,
      //                                     fontWeight: FontWeight.w400,
      //                                   ),
      //                                 ),
      //                               ),
      //                               Positioned(
      //                                 left: 113.50,
      //                                 top: 77.40,
      //                                 child: Text(
      //                                   '10 ر.س',
      //                                   style: TextStyle(
      //                                     color: Colors.white,
      //                                     fontFamily: 'Cairo',
      //                                     fontSize: 20.sp,
      //                                     fontWeight: FontWeight.w400,
      //                                   ),
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class Card2 extends StatelessWidget {
  const Card2({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      // angle: pi / 180 * -4.75,
      angle: 0,
      child: Image.asset(
        'assets/images/card_2.png',
        fit: BoxFit.fill,
        width: 366.w,
        height: 265.81.h,
      ),
      // child: Container(
      //   width: 366.w,
      //   height: 265.81.h,
      //   clipBehavior: Clip.antiAlias,
      //   decoration: ShapeDecoration(
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(36.33),
      //     ),
      //   ),
      //   child: Stack(
      //     children: [
      //       Positioned(
      //         left: 0,
      //         top: -0.65.h,
      //         child: Container(
      //           width: 366.w,
      //           height: 267.04.h,
      //           decoration: ShapeDecoration(
      //             color: const Color(0xFFB62026),
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(36.33),
      //             ),
      //           ),
      //         ),
      //       ),
      //       Positioned(
      //         left: 26.34.w,
      //         top: 25.37.h,
      //         child: SizedBox(
      //           width: 360.13.w,
      //           height: 294.91.h,
      //           child: Stack(
      //             children: [
      //               Positioned(
      //                 left: 87.16.w,
      //                 top: 113.87.h,
      //                 child: SizedBox(
      //                   width: 242.97.w,
      //                   height: 181.03.h,
      //                   child: Stack(
      //                     children: [
      //                       Align(
      //                         // left: 81.10.w,
      //                         // top: 49.97.h,
      //                         alignment: Alignment(map(301.10, 0, 375, -1, 1),
      //                             map(49.97, 0, 812, -1, 1)),
      //                         child: Opacity(
      //                           opacity: 0.50,
      //                           child: Container(
      //                             width: 134.63.w,
      //                             height: 134.63.w,
      //                             decoration: const BoxDecoration(
      //                               // color: Color(0xFF4E78CA),
      //                               shape: BoxShape.circle,
      //                               boxShadow: [
      //                                 BoxShadow(
      //                                     blurRadius: 30,
      //                                     spreadRadius: 2,
      //                                     color: Color.fromARGB(
      //                                         255, 78, 119, 202))
      //                               ],
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                       Align(
      //                         // left: 0,
      //                         // top: 26.04.h,
      //                         alignment: Alignment(map(0, 0, 375, -1, 1),
      //                             map(26.04, 0, 812, -1, 1)),
      //                         // Apply Blur
      //                         child: Container(
      //                           width: 113.76.w,
      //                           height: 113.76.w,
      //                           margin: const EdgeInsets.all(16),
      //                           decoration: const BoxDecoration(
      //                             // color: Color(0xFFE2555A),
      //                             shape: BoxShape.circle,
      //                             boxShadow: [
      //                               BoxShadow(
      //                                   blurRadius: 30,
      //                                   spreadRadius: 2,
      //                                   color:
      //                                       Color.fromARGB(255, 226, 85, 90))
      //                             ],
      //                           ),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //               Positioned(
      //                 left: 0,
      //                 top: 43.94.h,
      //                 child: Text(
      //                   'بطاقات جاهزة لك\n',
      //                   textDirection: TextDirection.rtl,
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontFamily: 'Cairo',
      //                     fontSize: 21.80.sp,
      //                     fontWeight: FontWeight.w400,
      //                   ),
      //                 ),
      //               ),
      //               Positioned(
      //                 left: 5.57.w,
      //                 top: 0,
      //                 child: SizedBox(
      //                   width: 43.59.w,
      //                   height: 43.59.w,
      //                   child: Stack(
      //                     children: [
      //                       Positioned(
      //                         left: 0,
      //                         top: 0,
      //                         child: Container(
      //                           width: 43.59.w,
      //                           height: 43.59.w,
      //                           decoration: const ShapeDecoration(
      //                             color: Color(0x4CF5F5F5),
      //                             shape: OvalBorder(),
      //                           ),
      //                         ),
      //                       ),
      //                       Positioned(
      //                         left: 17.26.w,
      //                         top: 9.99.h,
      //                         child: Text(
      //                           '2',
      //                           style: TextStyle(
      //                             color: Colors.white,
      //                             fontSize: 18.16.sp,
      //                             fontFamily: 'Raleway',
      //                             fontWeight: FontWeight.w600,
      //                           ),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //               Positioned(
      //                 left: 0.91.w,
      //                 top: 87.39.h,
      //                 child: SizedBox(
      //                   width: 311.51.w,
      //                   height: 126.38.h,
      //                   child: Stack(
      //                     children: [
      //                       Positioned(
      //                         left: 0,
      //                         top: 60.99.h,
      //                         child: Container(
      //                           width: 311.51.w,
      //                           height: 65.39.h,
      //                           decoration: ShapeDecoration(
      //                             color: const Color(0x33F5F5F5),
      //                             shape: RoundedRectangleBorder(
      //                               borderRadius:
      //                                   BorderRadius.circular(36.33),
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                       Positioned(
      //                         left: 24.60.w,
      //                         top: 0,
      //                         child: SizedBox(
      //                           width: 132.w,
      //                           height: 108.15.h,
      //                           child: Stack(
      //                             children: [
      //                               Positioned(
      //                                 left: 0,
      //                                 top: 0,
      //                                 child: Text(
      //                                   'بطاقات جاهزة لأحبائك',
      //                                   textDirection: TextDirection.rtl,
      //                                   style: TextStyle(
      //                                     color: Colors.white,
      //                                     fontFamily: 'Cairo',
      //                                     fontSize: 14.53.sp,
      //                                     fontWeight: FontWeight.w400,
      //                                   ),
      //                                 ),
      //                               ),
      //                               Positioned(
      //                                 left: 23.19.w,
      //                                 top: 71.16.h,
      //                                 child: Text(
      //                                   '10 ر.س',
      //                                   textDirection: TextDirection.rtl,
      //                                   style: TextStyle(
      //                                     color: Colors.white,
      //                                     fontFamily: 'Cairo',
      //                                     fontSize: 20.sp,
      //                                     fontWeight: FontWeight.w400,
      //                                   ),
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
