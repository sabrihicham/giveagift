import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/core/utiles/dialog_utils.dart';
import 'package:giveagift/core/utiles/loading_overlay.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/main.dart';
import 'package:giveagift/view/cards/pages/ready_card_preview.dart';
import 'package:giveagift/view/payment/payment.dart';
import 'package:giveagift/view/profile/controller/profile_controller.dart';
import 'package:giveagift/view/profile/join_us.dart';
import 'package:giveagift/view/profile/login.dart';
import 'package:giveagift/view/profile/orders.dart';
import 'package:giveagift/view/profile/refund_policy.dart';
import 'package:giveagift/view/profile/support.dart';
import 'package:giveagift/view/profile/terms_and_conditions.dart';
import 'package:giveagift/view/profile/update_profile.dart';
import 'package:giveagift/view/profile/wallet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: profileController,
      builder: (controller) {
        return Scaffold(
          backgroundColor: Get.isDarkMode ? Colors.grey.shade900 : null,
          appBar: AppBar(
            title: Text('my_account'.tr),
            backgroundColor: Get.isDarkMode ? Theme.of(context).cardColor : Colors.white,
            surfaceTintColor: Colors.transparent,
            actions: [
              // IconButton(
              //   onPressed: () {
              //     Get.to(const Settingspage());
              //   },
              //   icon: const Icon(Icons.settings_suggest_rounded),
              // ),
            ],
            // leading: IconButton(
            //   onPressed: () {
            //     Scaffold.of(context).openDrawer();
            //   },
            //   icon: Icon(
            //     Icons.menu_rounded,
            //   ),
            // ),
          ),
          body: !controller.isLoggedIn.value
            ? NotLogedIn(
              onLogIn: (value) {
                if (value) {
                  setState(() {});
                  controller.onInit();
                }
              },
            )
            : RefreshIndicator.adaptive(
                onRefresh: () async {
                  await controller.onRefresh();
                },
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: SizedBox(
                    // height: MediaQuery.of(context).size.height < MediaQuery.of(context).size.width
                    //   ? MediaQuery.of(context).size.width
                    //   :  MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          color: Get.isDarkMode ? Theme.of(context).cardColor : Colors.white,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    // Profile Image
                                    Container(
                                      width: 70,
                                      height: 70,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        color: Get.isDarkMode
                                          ? Colors.white.withOpacity(.1)
                                          : Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: "${API.BASE_URL}/users/${SharedPrefs.instance.user!.photo}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    // Full name
                                    SizedBox(
                                      child: Text(
                                        SharedPrefs.instance.user!.name!.capitalize!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Spacer(),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            SharedPrefs.instance.clearToken();
                                          },
                                          child: Icon(
                                            Icons.logout_rounded,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text('logout'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ]
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Orders and Support
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 600,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                GridView(
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 15
                                  ),
                                  shrinkWrap: true,
                                  children: [
                                    ProfileContainer(
                                      icon: FaIcon(
                                        FontAwesomeIcons.fileLines, size: 36,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      text: 'orders'.tr,
                                      onTap: () {
                                        Get.to(
                                          () => const OrdersPage(),
                                          duration: Get.isDarkMode ? 0.seconds : null
                                        );
                                      },
                                    ),
                                    ProfileContainer(
                                      icon: FaIcon(
                                        Icons.person_2, size: 36,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      text: 'my_info'.tr,
                                      onTap: () {
                                        Get.to(
                                          () => const UpdateProfile(),
                                          duration: Get.isDarkMode ? 0.seconds : null
                                        );
                                      },
                                    ),
                                    ProfileContainer(
                                      icon: FaIcon(
                                        Icons.support_agent_rounded, size: 36,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      text: 'contact_us'.tr,
                                      onTap: () {
                                        Get.to(
                                          () => const SupportPage(),
                                          duration: Get.isDarkMode ? 0.seconds : null
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //   children: [
                                //     GestureDetector(
                                //       onTap: () {
                                //         Get.to(() => const OrdersPage());
                                //       },
                                //       child: GlobalIcon(
                                //         icon: FontAwesomeIcons.fileLines,
                                //         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                //         iconSize: 25,
                                //         title: Text('orders'.tr, style: const TextStyle(fontWeight: FontWeight.w600,)),
                                //       ),
                                //     ),
                                //     GlobalIcon(
                                //       icon: Icons.support_agent_rounded,
                                //       padding: const EdgeInsets.all(10),
                                //       iconSize: 25,
                                //       title: Text('contact_us'.tr, style: const TextStyle(fontWeight: FontWeight.w600),),
                                //     )
                                //   ]
                                // ),
                                const SizedBox(height: 20,),
                                // My Info
                                // OutlineContainer(
                                //   title: 'my_account'.tr,
                                //   padding: const EdgeInsets.symmetric(vertical: 0),
                                //   margin: const EdgeInsets.only(bottom: 20),
                                //   color: Colors.white,
                                //   child: Column(
                                //     children: [
                                //       GlobalListTile(
                                //         click: true,
                                //         onTap: () {
                                //           Get.to(() => const UpdateProfile());
                                //         },
                                //         title: 'my_info'.tr,
                                //         leading: GlobalIcon(
                                //           color: Theme.of(context).primaryColor,
                                //           icon: Icons.person_2_rounded,
                                //         ),
                                //       )
                                //     ],
                                //   ),
                                // ),
                                // Settings
                                OutlineContainer(
                                  title: 'settings'.tr,
                                  padding: const EdgeInsets.symmetric(vertical: 0),
                                  color: Get.isDarkMode ? Colors.grey.shade800 : Colors.white,
                                  // height: 243.h,
                                  child: ListView.separated(
                                    itemCount: 7,
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    separatorBuilder: (context, inex) => Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.symmetric(horizontal: 10.h),
                                      height: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                    itemBuilder: (context, index) => [
                                      GlobalListTile(
                                        click: true,
                                        title: 'language'.tr,
                                        onTap: () {
                                          final newValue = Get.locale?.languageCode == 'ar' ? 'en' : 'ar';
                                          // save in shared preferences
                                          SharedPrefs.instance.prefs.setString('lang', newValue);
                                          // change language
                                          Get.updateLocale(Locale(newValue));
                                          // update app
                                          // appKey.currentState?.setState(() { });
                                          Get.appUpdate();
                                        },
                                        endWidget: Text(
                                          Get.locale?.languageCode == 'ar' ? 'العربية' : 'English'
                                        ),
                                        leading: GlobalIcon(
                                          color: Theme.of(context).primaryColor,
                                          assetPath: 'assets/icons/language.svg',
                                          iconSize: 20.w,
                                        ),
                                      ),
                                      GlobalListTile(
                                        title: 'notifications'.tr,
                                        onTap: () async {
                                          if (SharedPrefs.instance.notificationIsOn) {
                                              if (!(await FirebaseNotification.requestPermission())) {
                                                AppSettings.openAppSettings(type: AppSettingsType.notification);
                                                return;
                                              }
                                            }
                                          
                                          setState(() {
                                            SharedPrefs.instance.setNotificationIsOn(!SharedPrefs.instance.notificationIsOn);
                                          });

                                          if (!SharedPrefs.instance.notificationIsOn) {
                                            FirebaseMessaging.instance.deleteToken();
                                          } else {
                                            FirebaseMessaging.instance.getToken();
                                          }
                                        },
                                        endWidget: CupertinoSwitch(
                                          value: SharedPrefs.instance.notificationIsOn,
                                          onChanged: (value) async {
                                            if (value) {
                                              if (!(await FirebaseNotification.requestPermission())) {
                                                AppSettings.openAppSettings(type: AppSettingsType.notification);
                                                return;
                                              }
                                            }
                                            
                                            setState(() {
                                              SharedPrefs.instance.setNotificationIsOn(value);
                                            });

                                            if (!value) {
                                              FirebaseMessaging.instance.deleteToken();
                                            } else {
                                                await FirebaseMessaging.instance.getToken();
                                            }
                                          },
                                        ),
                                        leading: GlobalIcon(
                                          color: Theme.of(context).primaryColor,
                                          assetPath: 'assets/icons/notifications.svg',
                                          iconSize: 20.w,
                                        ),
                                      ),
                                      GlobalListTile(
                                        title: 'dark_mode'.tr,
                                        onTap: () async {
                                          final value = SharedPrefs.instance.prefs.getBool('isDark') ?? false;
                                          // setState(() {
                                            // change theme
                                            Get.changeThemeMode(!value ? ThemeMode.dark : ThemeMode.light);
                                            // save in shared preferences
                                            SharedPrefs.instance.prefs.setBool('isDark', !value);

                                            Get.updateLocale(Locale(Get.locale?.languageCode == 'ar' ? 'ar' : 'en'));
                                          // });
                                        },
                                        endWidget: CupertinoSwitch(
                                          value: SharedPrefs.instance.prefs.getBool('isDark') ?? false,
                                          onChanged: (value) async {
                                            // setState(() {
                                              // change theme
                                              Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                                              // save in shared preferences
                                              SharedPrefs.instance.prefs.setBool('isDark', value);

                                              Get.updateLocale(Locale(Get.locale?.languageCode == 'ar' ? 'ar' : 'en'));
                                            // });
                                          },
                                        ),
                                        leading: GlobalIcon(
                                          color: Theme.of(context).primaryColor,
                                          assetPath: 'assets/icons/eye.svg',
                                          iconSize: 18.w,
                                        ),
                                      ),
                                      GlobalListTile(
                                        title: 'join_us_msg'.tr,
                                        onTap: () {
                                          Get.to(
                                            () => const JoinUsPage(),
                                            duration: Get.isDarkMode ? 0.seconds : null
                                          );
                                        },
                                        leading: GlobalIcon(
                                          color: Theme.of(context).primaryColor,
                                          assetPath: 'assets/icons/user-add.svg',
                                          iconSize: 20.w,
                                        ),
                                      ),
                                      GlobalListTile(
                                        title: 'refund_policy'.tr,
                                        onTap: () {
                                          // save in shared preferences
                                          Get.to(
                                            () => const RefundPage(),
                                            duration: Get.isDarkMode ? 0.seconds : null
                                          );
                                        },
                                        leading: GlobalIcon(
                                          color: Theme.of(context).primaryColor,
                                          assetPath: 'assets/icons/refund.svg',
                                          iconSize: 20.w,
                                        ),
                                      ),
                                      GlobalListTile(
                                        title: 'terms_and_conditions'.tr,
                                        onTap: () {
                                          // save in shared preferences
                                          Get.to(
                                            () => const TermsAndConditionsPage(),
                                            duration: Get.isDarkMode ? 0.seconds : null
                                          );
                                        },
                                        leading: GlobalIcon(
                                          color: Theme.of(context).primaryColor,
                                          assetPath: 'assets/icons/privacy-policy.svg',
                                          iconSize: 20.w,
                                        ),
                                      ),
                                      GlobalListTile(
                                        title: 'delete_account'.tr,
                                        titleColor: Theme.of(context).primaryColor,
                                        onTap: () async {
                                          // save in shared preferences
                                          final isOk = await DialogUtils.globalShowDialog<bool?>(
                                            title: 'delete_account'.tr,
                                            confirmText: "delete".tr,
                                            content: [
                                              FittedBox(
                                                child: Text(
                                                  'delete_account_message'.tr
                                                )
                                              ),
                                            ],
                                          );

                                          if (isOk == true) {
                                            await OverlayUtils.showLoadingOverlay(
                                              asyncFunction: () async {
                                                await profileController.deleteAccount();
                                              },
                                            );

                                            bool isSuccess = false;
                                            String? _message;

                                            if (profileController.deleteAccountState is SubmissionError) {
                                              _message = (profileController.deleteAccountState as SubmissionError).exception.message;
                                            } else if (profileController.deleteAccountState is SubmissionSuccess) {
                                              isSuccess = true;
                                              _message = 'account_deleted'.tr;
                                              SharedPrefs.instance.clearToken();
                                            }

                                            Get.snackbar(
                                              isSuccess ? 'sucess'.tr : 'error'.tr,
                                              _message ?? 'error'.tr,
                                              snackPosition: SnackPosition.BOTTOM,
                                              backgroundColor: isSuccess ? Colors.green : Colors.red,
                                              colorText: Colors.white,
                                            );
                                          }
                                          
                                        },
                                        leading: GlobalIcon(
                                          color: Theme.of(context).primaryColor,
                                          assetPath: 'assets/icons/profile.svg',
                                          iconSize: 20.w,
                                        ),
                                      ),
                                    ][index],
                                  ),
                                ),
                                SizedBox(height: 140.h),
                                // const SizedBox (height: 20),
                                // // My wallet
                                // OutlineContainer(
                                //   title: 'wallet'.tr,
                                //   padding: const EdgeInsets.symmetric(vertical: 0),
                                //   margin: const EdgeInsets.only(bottom: 20),
                                //   color: Colors.white,
                                //   child: Column(
                                //     children: [
                                //       GlobalListTile(
                                //         click: true,
                                //         onTap: () {
                                //           Get.to(() => const WalletPage());
                                //         },
                                //         title: 'my_wallet'.tr,
                                //         leading: GlobalIcon(
                                //           color: Theme.of(context).colorScheme.secondary,
                                //           icon: Icons.wallet,
                                //         ),
                                //       )
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Current balance
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //       "current_balance".tr,
                        //       style: const TextStyle(fontSize: 20),
                        //     ),
                        //     // const SizedBox(width: 10),
                        //     // SvgPicture.asset(
                        //     //   'assets/icons/green_plus.svg',
                        //     //   height: 15,
                        //     //   width: 15,
                        //     //   color: Color.fromRGBO(0, 128, 0, 1),
                        //     // )
                        //   ],
                        // ),
                        // GetBuilder<ProfileController>(
                        //   init: profileController,
                        //   id: 'wallet',
                        //   // didChangeDependencies: (didChangeDependencies) {
                        //   //   if (controller is SubmissionError) {
                        //   //     Get.snackbar(
                        //   //       'error'.tr,
                        //   //       (controller.walletSubmissionState as SubmissionError).exception?.message ?? 'error'.tr,
                        //   //       backgroundColor: Colors.red,
                        //   //       colorText: Colors.white,
                        //   //     );
                        //   //   }
                        //   // },
                        //   builder: (context) {
                        //     Wallet? wallet;
                        //     String realBalance = '-', fractionBalance = '--';
                      
                        //     if (controller.walletState is SubmissionSuccess) {
                        //       wallet = controller.wallet;
                      
                        //       RegExp regExp = RegExp(r'(\d+)(\.(\d+))?');
                        //       final match = regExp.firstMatch(wallet!.balance.toString());
                      
                        //       realBalance = match?.group(1) ?? '0';
                        //       fractionBalance = match?.group(3)?.padRight(2, "0") ?? '00';
                        //     }
                      
                        //     return RichText(
                        //       text: TextSpan(
                        //         text: 'SAR ',
                        //         style: TextStyle(
                        //           color: Get.isDarkMode
                        //             ? Colors.white
                        //             : Colors.black,
                        //           fontSize: 14,
                        //           fontWeight: FontWeight.w500,
                        //         ),
                        //         children: [
                        //           // to integer
                        //           TextSpan(
                        //             text: realBalance,
                        //             style: TextStyle(
                        //               fontSize: 26,
                        //               color: Get.isDarkMode
                        //                 ? Colors.white
                        //                 : Colors.black,
                        //             ),
                        //           ),
                        //           // fraction font 14
                        //           TextSpan(
                        //             text: '.$fractionBalance',
                        //             style: TextStyle(
                        //               fontSize: 14,
                        //               color: Get.isDarkMode
                        //                 ? Colors.white
                        //                 : Colors.black,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     );
                      
                        //     //   return Container(
                        //     //     constraints: const BoxConstraints(maxWidth: 500, maxHeight: 300),
                        //     //     width: double.infinity,
                        //     //     padding: const EdgeInsets.all(10),
                        //     //     margin: const EdgeInsets.all(10),
                        //     //     decoration: BoxDecoration(
                        //     //       color: Get.isDarkMode
                        //     //           ? Colors.white.withOpacity(.1)
                        //     //           : Colors.grey.shade200,
                        //     //       borderRadius: BorderRadius.circular(10),
                        //     //     ),
                        //     //     child: Builder(
                        //     //       builder: (context) {
                      
                        //     //         if (controller.walletSubmissionState is Submitting) {
                        //     //           return CupertinoActivityIndicator(
                        //     //             radius: 20,
                        //     //             color: Get.isDarkMode
                        //     //                 ? Colors.white
                        //     //                 : Colors.grey,
                        //     //           );
                        //     //         }
                      
                        //     //         if (controller.walletSubmissionState is SubmissionError) {
                        //     //           return Column(
                        //     //             mainAxisAlignment: MainAxisAlignment.center,
                        //     //             children: [
                        //     //               Text(
                        //     //                 (controller.walletSubmissionState as SubmissionError).exception?.message ?? 'error'.tr,
                        //     //                 style: Theme.of(context).textTheme.titleMedium,
                        //     //               ),
                        //     //               CupertinoButton(
                        //     //                 onPressed: () {
                        //     //                   controller.getWallet();
                        //     //                 },
                        //     //                 child: Text('retry'.tr),
                        //     //               ),
                        //     //             ],
                        //     //           );
                        //     //         }
                      
                        //     //         return Column(
                        //     //           mainAxisAlignment: MainAxisAlignment.center,
                        //     //           children: [
                        //     //             Text(
                        //     //               'balance'.tr,
                        //     //               style: Theme.of(context).textTheme.titleLarge,
                        //     //             ),
                        //     //             const SizedBox(height: 10),
                        //     //             Text(
                        //     //               '${controller.wallet?.balance.toString() ?? "-"} ${'sar'.tr}',
                        //     //               style: Theme.of(context).textTheme.titleLarge,
                        //     //             ),
                        //     //             const SizedBox(height: 10),
                        //     //             Container(
                        //     //               height: 2,
                        //     //               width: 100,
                        //     //               color: Get.isDarkMode
                        //     //                   ? Colors.white.withOpacity(.1)
                        //     //                   : Colors.grey.shade200,
                        //     //             ),
                        //     //             const SizedBox(height: 10),
                        //     //             CupertinoButton(
                        //     //               onPressed: () {
                        //     //                 showBottomSheet(
                        //     //                   context: context,
                        //     //                   builder: (context) => Container(
                        //     //                     height: 200,
                        //     //                     color: Get.isDarkMode
                        //     //                         ? Colors.black
                        //     //                         : Colors.white,
                        //     //                     child: Column(
                        //     //                       children: [
                        //     //                         const SizedBox(height: 20),
                        //     //                         Text(
                        //     //                           'add_balance'.tr,
                        //     //                           style: Theme.of(context)
                        //     //                               .textTheme
                        //     //                               .titleLarge,
                        //     //                         ),
                        //     //                         const SizedBox(height: 20),
                        //     //                         CupertinoTextField(
                        //     //                           placeholder: 'amount'.tr,
                        //     //                           keyboardType: TextInputType.number,
                        //     //                           style: Theme.of(context)
                        //     //                               .textTheme
                        //     //                               .titleLarge,
                        //     //                         ),
                        //     //                         const SizedBox(height: 20),
                        //     //                         CupertinoButton(
                        //     //                           onPressed: () {
                        //     //                             Navigator.of(context).pop();
                        //     //                           },
                        //     //                           child: Text(
                        //     //                             'add_balance'.tr,
                        //     //                             style: Theme.of(context)
                        //     //                                 .textTheme
                        //     //                                 .titleSmall
                        //     //                                 ?.copyWith(
                        //     //                                   color: Colors.white,
                        //     //                                 ),
                        //     //                           ),
                        //     //                           color: Theme.of(context).primaryColor,
                        //     //                           borderRadius: BorderRadius.circular(10),
                        //     //                         ),
                        //     //                       ],
                        //     //                     ),
                        //     //                   ),
                        //     //                 );
                        //     //               },
                        //     //               child: Text(
                        //     //                 'add_balance'.tr,
                        //     //                 style: Theme.of(context)
                        //     //                     .textTheme
                        //     //                     .titleSmall
                        //     //                     ?.copyWith(
                        //     //                       color: Colors.white,
                        //     //                     ),
                        //     //               ),
                        //     //               color: Theme.of(context).primaryColor,
                        //     //               borderRadius: BorderRadius.circular(10),
                        //     //             ),
                        //     //           ],
                        //     //         );
                        //     //       }
                        //     //     ),
                        //     //   );
                        //   },
                        // ),
                        // const SizedBox(height: 20),
                        // // Payment methods
                        // GetBuilder<ProfileController>(
                        //   init: profileController,
                        //   tag: 'paymentMethods',
                        //   builder: (context) {
                        //     if (controller.paymentMethods == null) {
                        //       return const CupertinoActivityIndicator();
                        //     }
                      
                        //     return Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //       children: controller.paymentMethods!
                        //         .map(
                        //           (method) => Container(
                        //             width: 50,
                        //             height: 50,
                        //             margin:
                        //                 const EdgeInsets.symmetric(
                        //               horizontal: 10,
                        //             ),
                        //             child: CachedNetworkImage(
                        //               imageUrl: method.imageUrl,
                        //             ),
                        //           ),
                        //         )
                        //         .toList(),
                        //     );
                        //   },
                        // ),
                        // const SizedBox(height: 20),
                        // ConstrainedBox(
                        //   constraints: const BoxConstraints(
                        //     // maxHeight: 300,
                        //     maxWidth: 600,
                        //   ),
                        //   child: LayoutBuilder(
                        //     builder: (context, boxConstraints) {
                        
                        //       final child = GridView(
                        //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        //           crossAxisCount: 2,
                        //           childAspectRatio: 1.5,
                        //           mainAxisSpacing: 30,
                        //           crossAxisSpacing: 30,
                        //         ),
                        //         shrinkWrap: true,
                        //         physics: const NeverScrollableScrollPhysics(),
                        //         padding: const EdgeInsets.symmetric(
                        //           horizontal: 30,
                        //         ),
                        //         children: [
                        //           // ADD Money
                        //           SquareButton(
                        //             icon: Image.asset(
                        //               'assets/icons/profile_settings.png',
                        //               height: 24,
                        //               width: 24,
                        //               fit: BoxFit.contain,
                        //             ),
                        //             title: 'profile_settings'.tr,
                        //             onPressed: () {
                        //               Get.to(() => const UpdateProfile());
                        //               // Get.to(
                        //               //   ()=> PaymentPage(
                        //               //     type: PaymentType.DEPOSIT,
                        //               //   )
                        //               // );
                        //             },
                        //           ),
                        //           // Transfer Money
                        //           SquareButton(
                        //             icon: Image.asset(
                        //               'assets/icons/transfer_balance.png',
                        //               height: 24,
                        //               width: 24,
                        //               fit: BoxFit.contain,
                        //             ),
                        //             title: 'transfer_balance'.tr,
                        //             onPressed: () {
                        //               Get.to(() => TransferBalance());
                        //             },
                        //           ),
                        //           // My cards
                        //           SquareButton(
                        //             icon: Image.asset(
                        //               'assets/icons/my_cards.png',
                        //               height: 24,
                        //               width: 24,
                        //               fit: BoxFit.contain,
                        //             ),
                        //             title: 'orders'.tr,
                        //             onPressed: () {
                        //               Get.to(() => const OrdersPage());
                        //             },
                        //           ),
                        //           // Account Settings
                        //           SquareButton(
                        //             icon: Image.asset(
                        //               'assets/icons/support.png',
                        //               height: 24,
                        //               width: 24,
                        //               fit: BoxFit.contain,
                        //             ),
                        //             title: 'support'.tr,
                        //             onPressed: () {
                        //               // Get.to(() => const SupportPage());
                        //             },
                        //           ),
                        //         ],
                        //       );
                        
                        //       if (boxConstraints.maxWidth >= 500) {
                        //         return Center(
                        //           child: child,
                        //         );
                        //       }
                        
                        //       return child;
                        //     }
                        //   ),
                        // )
                      ]
                    ),
                  ),
                ),
              ),
        );
      },
    );
  }
}

class ProfileContainer extends StatelessWidget {
  final Widget icon;
  final String text;
  final Function()? onTap;

  const ProfileContainer({
    super.key,
    required this.icon,
    required this.text,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey.shade800 :Colors.white,
        border: Border.all(color: Color.fromRGBO(226, 232, 240, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            Text(
              text,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SquareButton extends StatelessWidget {
  final Widget icon;
  final String title;
  final Function()? onPressed;

  const SquareButton({
    super.key,
    required this.icon,
    required this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.white.withOpacity(.1) : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: CupertinoButton(
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotLogedIn extends StatelessWidget {
  final Function(bool)? onLogIn;

  const NotLogedIn({super.key, this.onLogIn});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'not_login_msg'.tr,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: CupertinoButton(
              onPressed: () async {
                final result = await Get.to(
                  () => const LoginPage(),
                  transition: Transition.cupertino,
                );

                if (result != null) {
                  onLogIn?.call(result);
                }
              },
              color: const Color.fromRGBO(253, 60, 132, 1),
              borderRadius: BorderRadius.circular(10),
              child: Text('login'.tr,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}