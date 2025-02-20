import 'dart:async';
import 'dart:convert';

import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/classes/custom_client.dart' as client;
import 'package:giveagift/core/classes/custom_controller.dart';
import 'package:giveagift/core/classes/custom_exception.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/view/recivedCards/model/recived_card.dart';

class RecivedCardsController extends CustomController {
  List<RecivedCard>? recivedCards;

  Future<bool> getRecivedCards() async {
    getRecivedCardsSetState(Submitting());

    try {
      final response = await client.get(
        Uri.parse('${API.BASE_URL}/api/v1/cards/received'),
      );

      if (response.statusCode < 500) {
        final data = jsonDecode(response.body);

        if (data['status'] != 'success') {
          throw CustomException(data['message']);
        }

        recivedCards = RecivedCardsResponse.fromJson(data).data;

        getRecivedCardsSetState(const SubmissionSuccess());

        return true;
      }

      throw CustomException('An error occurred while getting RecivedCards.');
    } catch (e) {
      if (e is CustomException) {
        getRecivedCardsSetState(SubmissionError(e));
        return false;
      }

      getRecivedCardsSetState(
        SubmissionError(
          CustomException('An error occurred while getting RecivedCards.'),
        ),
      );
      return false;
    }
  }


  @override
  void onInit() {
    super.onInit();
  }


  void getRecivedCardsSetState(SubmissionState state) {
    setState(
      state,
      ids: ['getRecivedCards'],
    );
  }

  SubmissionState? get getRecivedCardsState => submissionStates["getRecivedCards"];
}


// https://api.giveagift.com.sa/api/v1/cards/received

