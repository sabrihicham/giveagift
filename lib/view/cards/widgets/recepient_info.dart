import 'dart:ffi';

import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/core/classes/celebrate.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/view/cards/pages/custom_card_page.dart';
import 'package:giveagift/view/profile/transfer_balance.dart';
import 'package:giveagift/view/profile/update_profile.dart';
import 'package:giveagift/view/widgets/global_filled_button.dart';

class RecepientInfo extends StatefulWidget {
  const RecepientInfo(
      {super.key,
      required this.recepientNameConntroller,
      required this.recepientPhoneController,
      required this.onPhoneBegingin,
      required this.onTimeChange,
      required this.onCelebrateIconChange,
      required this.onCelebrateLinkChange,
      this.onSubmit,
      required this.submitTitle,
      this.later = false,
      this.formKey});

  final TextEditingController recepientNameConntroller, recepientPhoneController;
  final Function(String time) onPhoneBegingin;
  final Function(DateTime? time) onTimeChange;
  final Function(String? celebrate) onCelebrateIconChange, onCelebrateLinkChange;
  final String submitTitle;
  final Function()? onSubmit;
  final bool later;
  final GlobalKey<FormState>? formKey;

  @override
  State<RecepientInfo> createState() => _RecepientInfoState();
}

class _RecepientInfoState extends State<RecepientInfo> {
  String phoneBegingin = '966';
  String? _selectedCelebration;
  DateTime? receiveAt;

  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _formKey = widget.formKey ?? GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(
          //   'reciver_info'.tr,
          //   style: TextStyle(
          //     fontSize: 16,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: GlobalOutlineFormTextFeild(
                title: 'receiver_name'.tr,
                controller: widget.recepientNameConntroller,
                color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
                borderColor: const Color(0xEEEEEEEE),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please_enter_name'.tr;
                  }
                  return null;
                },
              ),
              // child: Column(
              //   children: [
              //     SizedBox(
              //       width: double.infinity,
              //       child: Text(
              //         'receiver_name'.tr,
              //         textAlign: TextAlign.start,
              //         style: const TextStyle(
              //           fontSize: 18,
              //         ),
              //       ),
              //     ),
              //     CupertinoTextFormFieldRow(
              //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              //       maxLines: 1,
              //       controller: widget.recepientNameConntroller,
              //       style: TextStyle(
              //         color: Get.isDarkMode ? Colors.white : Colors.black,
              //         fontSize: 16,
              //       ),
              //       textInputAction: TextInputAction.next,
              //       inputFormatters: [
              //         LengthLimitingTextInputFormatter(20),
              //       ],
              //       validator: (value) {
              //         if (value!.isEmpty) {
              //           return 'please_enter_name'.tr;
              //         }
              //         return null;
              //       },
              //       decoration: BoxDecoration(
              //         color: Get.isDarkMode ? Colors.grey[900]! : Colors.grey[200],
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //   ],
              // ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: GlobalOutlineFormTextFeild(
                      title: 'phone_number'.tr,
                      controller: widget.recepientPhoneController,
                      color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
                      borderColor: const Color(0xEEEEEEEE),
                      height: 44.h,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please_enter_phone'.tr;
                        } else if (value.startsWith("0")) {
                          return 'phone_sould_not_start_with_0'.tr;
                        } else if (value.length < 9) {
                          return 'phone_should_be_9_digits'.tr;
                        }

                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(9),
                      ],
                    ),
                  ),
                  SizedBox(width: 4.w),
                  OutlineContainer(
                    width: 67.w,
                    height: 42.h,
                    radius: 11.r,
                    margin: const EdgeInsets.only(bottom: 5),
                    child: CountriesButton(
                      hideFlag: true,
                      onCountryChange: (country) {
                        phoneBegingin = country.code;
                        widget.onPhoneBegingin.call(phoneBegingin);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          //   child: ConstrainedBox(
          //     constraints: const BoxConstraints(
          //       maxWidth: 500,
          //     ),
          //     child: Column(
          //       children: [
          //         SizedBox(
          //           width: double.infinity,
          //           child: Text(
          //             'phone_number'.tr,
          //             textAlign: TextAlign.start,
          //             style: const TextStyle(
          //               fontSize: 18,
          //             ),
          //           ),
          //         ),
          //         Directionality(
          //           textDirection: TextDirection.ltr,
          //           child: CupertinoTextFormFieldRow(
          //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          //             maxLines: 1,
          //             controller: widget.recepientPhoneController,
          //             style: TextStyle(
          //               color: Get.isDarkMode ? Colors.white : Colors.black,
          //               fontSize: 16,
          //             ),
          //             prefix: Container(
          //               decoration: BoxDecoration(
          //                 color: Get.isDarkMode ? Colors.grey[900]! : Colors.grey[200],
          //                 borderRadius: const BorderRadius.only(
          //                   topLeft: Radius.circular(10),
          //                   bottomLeft: Radius.circular(10),
          //                   topRight: Radius.circular(0),
          //                   bottomRight: Radius.circular(0),
          //                 ),
          //               ),
          //               child: Padding(
          //                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          //                   child: CountriesButton(
          //                     onCountryChange: (country) {
          //                       phoneBegingin = country.code;
          //                     },
          //                   )),
          //             ),
          //             validator: (value) {
          //               if (value!.isEmpty) {
          //                 return 'please_enter_phone'.tr;
          //               }
          //               return null;
          //             },
          //             inputFormatters: [
          //               FilteringTextInputFormatter.digitsOnly,
          //               LengthLimitingTextInputFormatter(10),
          //             ],
          //             decoration: BoxDecoration(
          //               color: Get.isDarkMode ? Colors.grey[900]! : Colors.grey[200],
          //               borderRadius: const BorderRadius.only(
          //                 topLeft: Radius.circular(0),
          //                 bottomLeft: Radius.circular(0),
          //                 topRight: Radius.circular(10),
          //                 bottomRight: Radius.circular(10),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: OutlineContainer(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                radius: 11.r,
                title: 'sending_date'.tr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${'send_at'.tr} :',
                          style: const TextStyle(
                            // color: Colors.black,
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          receiveAt == null
                              ? 'now'.tr
                              : '${receiveAt!.day}/${receiveAt!.month}/${receiveAt!.year} ${receiveAt!.hour}:${receiveAt!.minute}',
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(
                            // color: Colors.black,
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    CupertinoButton(
                      onPressed: () async {
                        receiveAt = await showBoardDateTimePicker(
                          context: context,
                          pickerType: DateTimePickerType.datetime,
                          options: BoardDateTimeOptions(
                            weekend: const BoardPickerWeekendOptions(
                              saturdayColor: Colors.red,
                              sundayColor: Colors.red,
                            ),
                            pickerSubTitles: BoardDateTimeItemTitles(
                              year: 'year'.tr,
                              month: 'month'.tr,
                              day: 'day'.tr,
                              hour: 'hour'.tr,
                              minute: 'minute'.tr,
                              second: 'second'.tr,
                            ),
                            languages: const BoardPickerLanguages.en(),
                            activeColor: Colors.blue,
                            foregroundColor:
                                Get.isDarkMode ? null : Colors.white,
                            backgroundColor: Get.isDarkMode
                                ? Colors.grey[900]!
                                : Colors.grey[200],
                            startDayOfWeek: DateTime.sunday,
                            pickerFormat: PickerFormat.ymd,
                            // boardTitle: 'Board Picker',
                          ),
                        );

                        if (receiveAt != null &&
                            DateTime.now().compareTo(receiveAt!) == 1) {
                          receiveAt = null;
                        }

                        setState(() {});
                        widget.onTimeChange(receiveAt);
                      },
                      child: Text(
                        'choose_time'.tr,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontFamily: 'AraHamah1982',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Celebration
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Text(
                  'choose_celebration_shape'.tr,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
                SvgPicture.asset(
                  'assets/icons/pro.svg',
                  color: const Color.fromRGBO(255, 215, 0, 1),
                  width: 24,
                  height: 24,
                ),
                Tooltip(
                  message:
                      '${'celebration_shape_info'.tr} ${SharedPrefs.instance.appConfig!.celebrateIconPrice} ${'sar'.tr}',
                  triggerMode: TooltipTriggerMode.tap,
                  child: IconButton(
                    onPressed: null,
                    // onPressed: () {
                    //   Get.showSnackbar(
                    //     GetSnackBar(
                    //       message:
                    //           '${'celebration_info'.tr} ${SharedPrefs.instance.appConfig!.celebrateIconPrice} ${'sar'.tr}',
                    //       duration: const Duration(seconds: 3),
                    //       backgroundColor: Colors.red,
                    //       snackPosition: SnackPosition.BOTTOM,
                    //       snackStyle: SnackStyle.FLOATING,
                    //     ),
                    //   );
                    // },
                    icon: Icon(
                      Icons.info,
                      color:
                          Get.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: OutlineContainer(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              radius: 11.r,
              child: DropdownButton(
                value: _selectedCelebration,
                hint: Text('celebration_shape'.tr),
                borderRadius: BorderRadius.circular(10),
                icon: const Icon(Icons.keyboard_arrow_down),
                underline: const SizedBox.shrink(),
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                enableFeedback: true,
                items: [
                  for (final celebrate in CelebrateIcon.getIcons())
                    DropdownMenuItem(
                      child: Text(celebrate.label),
                      value: celebrate.value,
                    ),
                  // DropdownMenuItem(
                  //   child: Text('Birthday'),
                  //   value: 'Birthday',
                  // ),
                  // DropdownMenuItem(
                  //   child: Text('Anniversary'),
                  //   value: 'Anniversary',
                  // ),
                  // DropdownMenuItem(
                  //   child: Text('Graduation'),
                  //   value: 'Graduation',
                  // ),
                  // DropdownMenuItem(
                  //   child: Text('Wedding'),
                  //   value: 'Wedding',
                  // ),
                  // DropdownMenuItem(
                  //   child: Text('Other'),
                  //   value: 'Other',
                  // ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCelebration = value;
                  });
                  widget.onCelebrateIconChange(value);
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(
                  'choose_celebration_link'.tr,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
                SvgPicture.asset(
                  'assets/icons/pro.svg',
                  color: const Color.fromRGBO(255, 215, 0, 1),
                  width: 24,
                  height: 24,
                ),
                Tooltip(
                  message:
                      '${'celebration_link_info'.tr} ${SharedPrefs.instance.appConfig!.celebrateIconPrice} ${'sar'.tr}',
                  triggerMode: TooltipTriggerMode.tap,
                  child: IconButton(
                    onPressed: null,
                    // onPressed: () {
                    //   Get.showSnackbar(
                    //     GetSnackBar(
                    //       message:
                    //           '${'celebration_info'.tr} ${SharedPrefs.instance.appConfig!.celebrateIconPrice} ${'sar'.tr}',
                    //       duration: const Duration(seconds: 3),
                    //       backgroundColor: Colors.red,
                    //       snackPosition: SnackPosition.BOTTOM,
                    //       snackStyle: SnackStyle.FLOATING,
                    //     ),
                    //   );
                    // },
                    icon: Icon(
                      Icons.info,
                      color:
                          Get.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: OutlineContainer(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              radius: 11.r,
              child: TextFormField(
                maxLines: 1,
                onChanged: (value) {
                  widget.onCelebrateLinkChange(value);
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'celebration_link'.tr,
                  hintStyle: TextStyle(
                    color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // submit button
          Row(
            mainAxisAlignment: widget.later
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.center,
            children: [
              if (widget.onSubmit != null)
                GlobalFilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSubmit!();
                    }
                  },
                  height: 50.h,
                  width: 150.w,
                  text: widget.submitTitle,
                  // child: Text(
                  //   widget.submitTitle,
                  //   style: const TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ),
              const SizedBox.shrink(),
              if (widget.later)
                GlobalButton(
                  lable: 'later'.tr,
                  onTap: () {
                    // Get.back();
                    Navigator.pop(context);
                  },
                )
            ],
          ),
        ],
      ),
    );
  }
}
