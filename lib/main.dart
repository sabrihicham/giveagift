import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:giveagift/app_navigation.dart';
import 'package:giveagift/core/classes/app_config.dart';
import 'package:giveagift/core/localization/local.dart';
import 'package:giveagift/core/themes.dart';
import 'package:giveagift/core/utiles/image_utils.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/on_boarding_page.dart';
import 'package:giveagift/splash_screen.dart';
import 'package:giveagift/view/cards/controller/cards_controller.dart';
import 'package:giveagift/view/cart/controller/cart_controller.dart';
import 'package:giveagift/view/home/controllers/home_controller.dart';
import 'package:giveagift/view/profile/controller/profile_controller.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lottie/lottie.dart';
import 'firebase_options.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

// late final LottieComposition? composition;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPrefs.initialize();
  await FirebaseNotification.init();
  // await dotenv.load(fileName: ".env");

  AppConfig.init();
  runApp(const GiveAGift());
}

class GiveAGift extends StatelessWidget {
  const GiveAGift({super.key});
  final locales = const {'en': Locale('en'), 'ar': Locale('ar')};

  Locale get locale => SharedPrefs.instance.prefs.containsKey('lang')
      ? locales[SharedPrefs.instance.prefs.getString('lang')]!
      : locales['en']!;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        // splitScreenMode: true,
        // ensureScreenSize: true,

        builder: (context, child) {
          return GetMaterialApp(
            translations: MyLocal(),
            navigatorObservers: [routeObserver],
            locale: locale,
            themeMode: SharedPrefs.instance.prefs.getBool('isDark') ?? false
                ? ThemeMode.dark
                : ThemeMode.light,
            title: 'Give A Gift',
            debugShowCheckedModeBanner: false,
            initialBinding: BindingsBuilder(() {
              Get.put(ProfileController());
              Get.put(CartController());
              Get.put(CardsController());
              Get.put(HomeController());
            }),
            darkTheme: Themes.darkTheme,
            theme: Themes.lightTheme,
            // home: AppNavigation(
            //   key: appNavigationKey,
            // ),
            home: !SharedPrefs.instance.isLogedIn.value
              ? const OnBoardingPage()
              : const SplashScreen(),
          );
        });
  }
}

class FirebaseNotification {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<bool> requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission();

    debugPrint(settings.authorizationStatus.toString());

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      SharedPrefs.instance.setNotificationIsOn(true);
    } else {
      SharedPrefs.instance.setNotificationIsOn(false);
    }

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  static Future<void> init() async {
    requestPermission();

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (SharedPrefs.instance.notificationIsOn) {
      try {
        final token = await _firebaseMessaging.getToken();
        debugPrint('FirebaseMessaging token: $token');
      } catch (e) {
        debugPrint('Error FirebaseMessaging: $e');
      }
    }

    onMessage();

    onMessageOpenedApp();

    onBackgroundMessage();
  }

  static Future<void> onMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }
    });
  }

  static Future<void> onMessageOpenedApp() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new onMessageOpenedApp event was published!');
      log('Message data: ${message.data}');
    });
  }

  static Future<void> onBackgroundMessage() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }
}
