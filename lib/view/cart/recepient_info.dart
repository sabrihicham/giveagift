import 'package:flutter/material.dart' hide Card;
import 'package:get/get.dart';
import 'package:giveagift/core/classes/celebrate.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/core/utiles/loading_overlay.dart';
import 'package:giveagift/view/cards/widgets/recepient_info.dart';
import 'package:giveagift/view/cart/controller/cart_controller.dart';
import 'package:giveagift/view/cart/data/model/card.dart';

import 'package:giveagift/view/widgets/my_flip_card.dart';

class RecepientInfoPage extends StatefulWidget {
  final Card card;
  final bool later;

  const RecepientInfoPage({
    super.key,
    required this.card,
    this.later = false,
  });

  @override
  State<RecepientInfoPage> createState() => _RecepientInfoPageState();
}

class _RecepientInfoPageState extends State<RecepientInfoPage> {
  final reciverName = TextEditingController(), reciverPhone = TextEditingController();
  String? celebrateIcon, celebrateLink;
  DateTime? selectedTime;
  String phoneBegingin = '966';

  @override
  initState() {
    reciverName.text = widget.card.recipient?.name ?? '';
    reciverPhone.text = widget.card.recipient?.whatsappNumber ?? '';
    selectedTime = widget.card.receiveAt;
    celebrateIcon = widget.card.celebrateIcon;
    // celebrateLink = widget.card.celebrateQR;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('reciver_info'.tr),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                // App bar height
                height: MediaQuery.of(context).padding.top + 56,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20, 
                  horizontal: 20
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: MyFlipCard(card: widget.card)
                ),
              ),
              SafeArea(
                top: false,
                child: RecepientInfo(
                  recepientNameConntroller: reciverName, 
                  recepientPhoneController: reciverPhone, 
                  onPhoneBegingin: (phoneBegingin) => this.phoneBegingin = phoneBegingin,
                  onTimeChange: (time) => selectedTime = time, 
                  onCelebrateIconChange: (celebrateIcon) {
                    this.celebrateIcon = celebrateIcon;

                    Celebrate.instance.celebrate(
                      context,
                      celebrateTypeFromString(celebrateIcon!),
                      MediaQuery.of(context).size.width > 600,
                      all: false,
                    );
                  },
                  onCelebrateLinkChange: (celebrateLink) => this.celebrateLink = celebrateLink,
                  submitTitle: 'save'.tr,
                  later: widget.later,
                  onSubmit: () => Get.find<CartController>().addToCart(widget.card.id, celebrateIcon, celebrateLink, selectedTime, reciverName.text,  phoneBegingin + reciverPhone.text),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
