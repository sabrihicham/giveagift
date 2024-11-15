import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/core/utiles/loading_overlay.dart';
import 'package:giveagift/view/cards/pages/custom_card_page.dart';
import 'package:giveagift/view/cart/widgets/payment_dialog.dart';
import 'package:giveagift/view/profile/controller/profile_controller.dart';
import 'package:giveagift/view/widgets/global_filled_button.dart';

class TransferBalanceDialog extends StatefulWidget {
  const TransferBalanceDialog({super.key});

  @override
  State<TransferBalanceDialog> createState() => _TransferBalanceDialogState();
}

class _TransferBalanceDialogState extends State<TransferBalanceDialog> {
  ProfileController controller = Get.find<ProfileController>();

  final TextEditingController _amountController = TextEditingController();

  final TextEditingController _recipientPhoneController =
      TextEditingController();

  final _countriesButtonKey = GlobalKey<CountriesButtonState>();

  @override
  Widget build(BuildContext context) {
    return GlobalDialog(
      title: 'transfer_balance'.tr,
      doneText: 'transfer'.tr,
      onDonePressed: () async {
        OverlayUtils.showLoadingOverlay(
          asyncFunction: () async {
            final success = await controller.transferBalance(
              _countriesButtonKey.currentState!.country.code + _recipientPhoneController.text,
              num.parse(_amountController.text),
            );

            if (success) {
              Get.back();
            }

            Get.snackbar(
              'transfer_balance'.tr,
              success
                ? 'transfer_success'.tr
                : controller.submissionStates["transferBalance"] is SubmissionError
                  ? (controller.submissionStates["transferBalance"] as SubmissionError).exception.message
                  : '',
              snackStyle: SnackStyle.FLOATING,
              backgroundColor: success ? Colors.green : Colors.red,
            );
          },
        );
      },
      content: [
        GetBuilder(
          init: controller,
          tag: 'transferBalance',
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: GlobalOutlineTextFeild(
                            controller: _recipientPhoneController,
                            title: 'receiver_phone_number'.tr,
                            textAlignVertical: TextAlignVertical.center,
                            height: 52.h,
                            inputFormatters: [
                              FilteringTextInputFormatter.singleLineFormatter,
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                          ),
                        ),
                        SizedBox(width: 4.w),
                        OutlineContainer(
                          width: 92.w,
                          height: 52.h,
                          radius: 11.r,
                          child: CountriesButton(
                            key: _countriesButtonKey,
                            onCountryChange: (country) {},
                            hideFlag: true,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20.h),
                    GlobalOutlineTextFeild(
                      controller: _amountController,
                      title: '${'amount'.tr} (${'sar'.tr})',
                      height: 52.h,
                      textAlignVertical: TextAlignVertical.center,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ]
    );
  }
}

class CountryCode {
  final String code;
  final String name;
  final String flag;
  final String regex;

  CountryCode(this.code, this.name, this.flag, this.regex);

  static List<CountryCode> countries = [
    CountryCode("966", "Saudi Arabia", 'assets/countries/SA.png', r'/^(\+966)?5[0-9]{8}$/'),
    CountryCode("20", "Egypt", 'assets/countries/EG.png', r'/^(\+20)?1[0125][0-9]{8}$/'),
    CountryCode("971", "United Arab Emirates", 'assets/countries/UAE.png', r'/^(\+971)?5[0-9]{8}$/'),
    CountryCode("965", "Kuwait", 'assets/countries/KW.png', r'/^(\+965)?[0-9]{8}$/'),
    CountryCode("1", "United States", 'assets/countries/USA.png', r'/^(\+1)?[0-9]{10}$/'),
  ];
}

class CountriesButton extends StatefulWidget {
  const CountriesButton({
    super.key,
    this.onCountryChange,
    this.hideFlag = false
  });

  final void Function(CountryCode)? onCountryChange;
  final bool hideFlag;

  @override
  State<CountriesButton> createState() => CountriesButtonState();
}

class CountriesButtonState extends State<CountriesButton> {
  CountryCode country = CountryCode.countries.first;

  OverlayEntry? _countriesOverlayEntry;

  void _closeCounries() {
    _countriesOverlayEntry?.remove();
    _countriesOverlayEntry = null;
  }

  void _showCountries() {
    if (_countriesOverlayEntry != null) {
      _closeCounries();
    }
    _countriesOverlayEntry = _createCountriesOverlayEntry();
    Overlay.of(context).insert(_countriesOverlayEntry!);
  }

  void _onCountryChange(CountryCode country) {
    setState(() {
      this.country = country;
    });
    widget.onCountryChange?.call(country);
  }

  OverlayEntry _createCountriesOverlayEntry() {
    final renderObject = context.findRenderObject() as RenderBox;

    var size = renderObject.size;
    var offset = renderObject.localToGlobal(Offset.zero);

    return OverlayEntry(
      canSizeOverlay: true,
      builder: (context) => Positioned(
        top: offset.dy + size.height + 10,
        left: offset.dx + (Get.locale?.languageCode == 'ar' ? 0 : size.width - 250),
        width: 250,
        child: TapRegion(
          onTapOutside: (event) {
            // if click dismiss
            if (event.down) {
              _closeCounries();
            }
          },
          child: Material(
            color: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.grey[900]! : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.shade100,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(5.0),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: <Widget>[
                  for (var country in CountryCode.countries)
                    ListTile(
                      title: Text(country.name),
                      leading: Image.asset(
                        country.flag,
                        width: 40,
                      ),
                      trailing: country == this.country
                          ? Icon(CupertinoIcons.check_mark_circled_solid,
                              color: Colors.blueAccent)
                          : null,
                      onTap: () {
                        _onCountryChange(country);
                        _closeCounries();
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_countriesOverlayEntry != null) {
          _closeCounries();
        } else {
          _showCountries();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(!widget.hideFlag)
            Image.asset(
              country.flag,
              width: 30,
            ),
          if(!widget.hideFlag)
            const SizedBox(width: 5),
          Text(
            '+${country.code}',
            style: TextStyle(
              color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class CupertinoTextFeild extends StatefulWidget {
  const CupertinoTextFeild({
    super.key,
    this.controller,
    this.placeholder,
    this.prefix,
    this.inputFormatters,
    this.textColor,
    this.textSize,
    this.prefixLable,
  });

  final TextEditingController? controller;
  final String? placeholder;
  final Widget? prefix;
  final List<TextInputFormatter>? inputFormatters;
  final Color? textColor;
  final double? textSize;
  final String? prefixLable;

  @override
  State<CupertinoTextFeild> createState() => _CupertinoTextFeildState();
}

class _CupertinoTextFeildState extends State<CupertinoTextFeild> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 50,
        maxWidth: 500,
      ),
      child: CupertinoTextField(
        placeholder: widget.placeholder, // 'receiver_phone_number'.tr,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        maxLines: 1,
        controller: widget.controller,
        style: TextStyle(
          color: widget.textColor ??
              (Get.isDarkMode ? Colors.white : Colors.black),
          fontSize: widget.textSize ?? 16,
        ),
        inputFormatters: widget.inputFormatters,
        prefix: widget.prefixLable != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.prefixLable!,
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : widget.prefix,
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[900]! : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
