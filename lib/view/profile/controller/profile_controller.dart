import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/classes/custom_client.dart' as client;
import 'package:giveagift/core/classes/custom_controller.dart';
import 'package:giveagift/core/classes/custom_exception.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/view/cards/pages/ready_card_page.dart';
import 'package:giveagift/view/profile/model/balance.dart';
import 'package:giveagift/view/profile/model/order.dart';
import 'package:giveagift/view/profile/model/paymrnt_method.dart';
import 'package:giveagift/view/profile/model/user.dart';
import 'package:giveagift/view/profile/update_profile.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';

import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;

class ProfileController extends CustomController {
  User? get user => SharedPrefs.instance.user;
  Wallet? get wallet => SharedPrefs.instance.wallet;
  ValueNotifier<bool> get isLoggedIn => SharedPrefs.instance.isLogedIn;
  
  Timer? phoneReminder;

  List<PaymentMethod>? paymentMethods;

  List<Order>? orders;

  Future<void> getVerificationCode() async {
    getVerificationCodeSetState(Submitting());
    try {
      final response = await client.get(
        Uri.parse('${API.BASE_URL}/api/v1/users/phone-wa-code'),
      );

      if (response.statusCode != 200) {
        throw CustomException.fromStatus(response.statusCode) ?? CustomException('An error occurred while sendin cerification code.');
      }

      getVerificationCodeSetState(SubmissionSuccess(message: jsonDecode(response.body)["message"]));
    } catch (e) {
      if (e is CustomException) {
        return getVerificationCodeSetState(SubmissionError(e));
      }

      getVerificationCodeSetState(SubmissionError(
          CustomException('An error occurred while sendin cerification code.')));
    }
  }

  Future<void> verifyPhone(String code) async {
    verifyPhoneSetState(Submitting());
    try {
      final response = await client.post(
        Uri.parse('${API.BASE_URL}/api/v1/users/verify-phone'),
        body: {
          "verificationCode": code
        }
      );

      if (response.statusCode != 200) {
        throw CustomException(jsonDecode(response.body)['message'] ?? 'An error occurred while verifing phone.');
      }

      getProfile();

      verifyPhoneSetState(const SubmissionSuccess());
    } catch (e) {
      if (e is CustomException) {
        return verifyPhoneSetState(SubmissionError(e));
      }

      verifyPhoneSetState(SubmissionError(CustomException('An error occurred while verifing phone.')));
    }
  }

  Future<void> getProfile() async {
    setState(Submitting());
    try {
      final response = await client.get(
        Uri.parse('${API.BASE_URL}/api/v1/users/me'),
      );

      if (response.statusCode != 200) {
        throw CustomException.fromStatus(response.statusCode) ?? CustomException('An error occurred while fetching profile.');
      }

      final data = jsonDecode(response.body)['data'];

      SharedPrefs.instance.setUser(User.fromJson(data));

      setState(const SubmissionSuccess());

      if (user?.phoneVerified == false) {

        Future.delayed(const Duration(seconds: 4), () {
          SnackBarHelper.reminderSnackBar(
            'phone_number'.tr,
            'phone_verify_reminder'.tr,
            onTextClicked: () {
              Get.to(
                () => const UpdateProfile(),
                duration: Get.isDarkMode ? 0.seconds : null
              );
              Get.closeCurrentSnackbar();
            },
            buttonLable: 'verify'.tr
          );
        });

        phoneReminder = Timer.periodic(
          const Duration(minutes: 5),
          (timer) {
            if (SharedPrefs.instance.user?.phoneVerified == false) {
              SnackBarHelper.reminderSnackBar(
                'phone_number'.tr,
                'phone_verify_reminder'.tr,
                onTextClicked: () {
                  Get.to(
                    () => const UpdateProfile(),
                    duration: Get.isDarkMode ? 0.seconds : null
                  );
                  Get.closeCurrentSnackbar();
                },
                buttonLable: 'verify'.tr
              );
            } else {
              timer.cancel();
            }
          },
        );
        
      } else {
        phoneReminder?.cancel();
      }
    } catch (e) {
      if (e is CustomException) {
        return setState(SubmissionError(e));
      }

      setState(SubmissionError(
          CustomException('An error occurred while fetching profile.')));
    }
  }

  Future<void> deleteAccount() async {
    deleteAccountSetState(Submitting());
    try {
      final response = await client.delete(
        Uri.parse('${API.BASE_URL}/api/v1/users/me'),
      );

      if (response.statusCode != 204) {
        throw CustomException(jsonDecode(response.body)["message"] ?? 'An error occurred while deleting account.');
      }

      deleteAccountSetState(const SubmissionSuccess());

    } catch (e) {
      if (e is CustomException) {
        return deleteAccountSetState(SubmissionError(e));
      }

      deleteAccountSetState(SubmissionError(
          CustomException('An error occurred while deleting account.')));
    }
  }

  MediaType _getMimeType(String path) {
    final mimeTypeData = lookupMimeType(path);

    if (mimeTypeData == null) {
      return MediaType('application', 'octet-stream');
    }

    final list = mimeTypeData.split('/');

    return MediaType(list[0], list[1]);
  }

  Future<void> updateProfile({String? name, String? email, String? phone, String? imagePath}) async {
    updateProfileSetState(Submitting());
    try {
      var headers = {
        'Authorization': 'Bearer ${SharedPrefs.instance.token}',
      };

      var request = http.MultipartRequest('PATCH', Uri.parse('${API.BASE_URL}/api/v1/users/updateMe'));

      request.fields.addAll({
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
      });

      if (imagePath != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'photo', 
          imagePath,
          filename: basename(imagePath),
          contentType: _getMimeType(imagePath),
        ),
        );
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final body = await response.stream.bytesToString();

      if (response.statusCode != 200) {
        throw CustomException(json.decode(body)['message'] ?? 'An error occurred while updating profile.');
      }

      updateProfileSetState(const SubmissionSuccess());

      getProfile();
    } catch (e) {
      if (e is CustomException) {
        return updateProfileSetState(SubmissionError(e));
      }

      updateProfileSetState(SubmissionError(
          CustomException('An error occurred while updating profile.')));
    }
  }

  Future<void> updatePassword(String password, String newPass) async {
    updatePasswordSetState(Submitting());
    try {
      final response = await client.patch(
          Uri.parse('${API.BASE_URL}/api/v1/users/updateMyPassword'),
          body: {
            "currentPassword": password,
            "newPassword": newPass,
            "passwordConfirm": newPass
          });

      if (response.statusCode != 200) {
        throw  CustomException(jsonDecode(response.body)['message'] ?? 'An error occurred while updating password.');
      }

      final data = jsonDecode(response.body)['data'];

      SharedPrefs.instance.setWallet(
        Wallet.fromJson(data),
      );

      updatePasswordSetState(const SubmissionSuccess());
    } catch (e) {
      if (e is CustomException) {
        return updatePasswordSetState(SubmissionError(e));
      }

      updatePasswordSetState(SubmissionError(
          CustomException('An error occurred while updating password.')));
    }
  }

  Future<void> getWallet() async {
    walletSetState(Submitting());
    try {
      final response = await client.get(
        Uri.parse('${API.BASE_URL}/api/v1/wallets/me'),
      );

      if (response.statusCode != 200) {
        throw CustomException(jsonDecode(response.body)['message'] ?? 'An error occurred while fetching .');
      }

      final data = jsonDecode(response.body)['data'];

      SharedPrefs.instance.setWallet(
        Wallet.fromJson(data),
      );

      walletSetState(const SubmissionSuccess());
    } catch (e) {
      if (e is CustomException) {
        return walletSetState(SubmissionError(e));
      }

      walletSetState(SubmissionError(
          CustomException('An error occurred while fetching wallet.')));
    }
  }

  Future<bool> buyCard(String cardId) async {
    buyCardSetState(Submitting());
    try {
      final response = await client.post(
        Uri.parse('${API.BASE_URL}/api/v1/wallets/buy-card'),
        body: {
          "cardId": cardId,
        },
      );

      if (response.statusCode != 200) {
        throw CustomException(jsonDecode(response.body)["message"] ?? 'An error occurred while fetching .');
      }

      final data = jsonDecode(response.body)['data'];

      buyCardSetState(const SubmissionSuccess());

      getWallet();

      return true;
    } catch (e) {
      if (e is CustomException) {
        buyCardSetState(SubmissionError(e));
        return false;
      }

      buyCardSetState(SubmissionError(CustomException('An error occurred while fetching wallet.')));

      return false;
    }
  }

  Future<void> getPaymentMethods() async {
    paymentMethodsSetState(Submitting());
    try {
      final response = await client.get(
        Uri.parse('${API.BASE_URL}/api/v1/payments/payment-methods'),
        headers: {
          'Authorization': 'Bearer ${SharedPrefs.instance.token}',
        },
      );

      if (response.statusCode != 200) {
        throw CustomException(jsonDecode(response.body)['message'] ?? 'something_went_wrong'.tr);
      }

      final data = jsonDecode(response.body)['data'];

      paymentMethods = PaymentMethod.fromJsonList(data);

      paymentMethodsSetState(const SubmissionSuccess());
    } catch (e) {
      if (e is CustomException) {
        return paymentMethodsSetState(SubmissionError(e));
      }

      paymentMethodsSetState(SubmissionError(
        CustomException('An error occurred while fetching payment methods.')
      ));
    }
  }

  Future<bool> transferBalance(String phone, num amount) async {
    transferBalanceSetState(Submitting());
    try {
      final response = await client.post(
        Uri.parse('${API.BASE_URL}/api/v1/wallets/transfer'),
        headers: {
          'Authorization': 'Bearer ${SharedPrefs.instance.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'receiverPhone': phone,
          'amount': amount,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 400 || response.statusCode == 404) {
        final data = jsonDecode(response.body);

        if (data['status'] != 'success') {
          throw CustomException(data['message']);
        }

        transferBalanceSetState(const SubmissionSuccess());

        getWallet();

        return true;
      }

      throw CustomException('An error occurred while transferring balance.');
    } catch (e) {
      if (e is CustomException) {
        transferBalanceSetState(SubmissionError(e));
        return false;
      }

      transferBalanceSetState(SubmissionError(
          CustomException('An error occurred while transferring balance.')));
      return false;
    }
  }

  Future<bool> getOrders() async {
    getOrdersSetState(Submitting());

    try {
      final response = await client.get(
        Uri.parse('${API.BASE_URL}/api/v1/orders'),
      );

      if (response.statusCode < 500) {
        final data = jsonDecode(response.body);

        if (data['status'] != 'success') {
          throw CustomException(data['message']);
        }

        orders = OrdersResponse.fromJson(data).data;

        getOrdersSetState(const SubmissionSuccess());

        return true;
      }

      throw CustomException('An error occurred while getting orders.');
    } catch (e) {
      if (e is CustomException) {
        getOrdersSetState(SubmissionError(e));
        return false;
      }

      getOrdersSetState(SubmissionError(
          CustomException('An error occurred while getting orders.')));
      return false;
    }
  }

  Future<void> onRefresh() async {
    await Future.wait([
      getProfile(),
      getWallet(),
      getPaymentMethods(),
    ]);
  }

  @override
  void onInit() {
    super.onInit();
    if (isLoggedIn.value) {
      getProfile();
      getWallet();
      getPaymentMethods();
    }
  }

  void deleteAccountSetState(SubmissionState state) {
    setState(
      state,
      ids: ['deleteAccount'],
    );
  }

  SubmissionState? get deleteAccountState => submissionStates["deleteAccount"];

  void getVerificationCodeSetState(SubmissionState state) {
    setState(
      state,
      ids: ['getVerificationCode'],
    );
  }

  SubmissionState? get getVerificationCodeState => submissionStates["getVerificationCode"];

  void verifyPhoneSetState(SubmissionState state) {
    setState(
      state,
      ids: ['verifyPhone'],
    );
  }

  SubmissionState? get verifyPhoneState => submissionStates["verifyPhone"];

  void updateProfileSetState(SubmissionState state) {
    setState(
      state,
      ids: ['updateProfile'],
    );
  }

  SubmissionState? get updateProfileState => submissionStates["updateProfile"];

  void updatePasswordSetState(SubmissionState state) {
    setState(
      state,
      ids: ['updatePassword'],
    );
  }

  SubmissionState? get updatePasswordState => submissionStates["updatePassword"];

  void walletSetState(SubmissionState state) {
    setState(
      state,
      ids: ['wallet'],
    );
  }

  SubmissionState? get walletState => submissionStates["wallet"];

  void buyCardSetState(SubmissionState state) {
    setState(
      state,
      ids: ['buyCard'],
    );
  }

  SubmissionState? get buyCardState => submissionStates["buyCard"];

  void paymentMethodsSetState(SubmissionState state) {
    setState(
      state,
      ids: ['paymentMethods'],
    );
  }

  SubmissionState? get paymentMethodsState =>
      submissionStates["paymentMethods"];

  void transferBalanceSetState(SubmissionState state) {
    setState(
      state,
      ids: ['transferBalance'],
    );
  }

  SubmissionState? get transferBalanceState =>
      submissionStates["transferBalance"];

  void getOrdersSetState(SubmissionState state) {
    setState(
      state,
      ids: ['getOrders'],
    );
  }

  SubmissionState? get getOrdersState => submissionStates["getOrders"];
}
