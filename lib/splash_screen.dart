import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:giveagift/app_navigation.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/on_boarding_page.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  late Future<LottieComposition> compositionFuture;

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

    // when animation ends navigate to OnBoardingScreen
    controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //   builder: (context) =>
        // ));
        Get.off(
          () => !SharedPrefs.instance.isLogedIn.value
              ? const OnBoardingPage()
              : AppNavigation(
                  key: appNavigationKey,
                ),
          transition: Transition.fadeIn,
        );
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    // composition = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          // child: FutureBuilder(
          //   future: compositionFuture,
          //   builder: (context, snapshot) {
          // return
          child: Lottie.asset(
        'assets/lottie/alll.json',
        // 'assets/lottie/lo  go_cards.json',
        // composition: snapshot.data == null ? null : composition,
        controller: controller,
        // renderCache: RenderCache.drawingCommands,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Text('Error loading animation'),
          );
        },
        onLoaded: (composition) {
          controller?.duration = composition.duration;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            controller?.forward();
          });
        },
      )),
    );
  }
}
