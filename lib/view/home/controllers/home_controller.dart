import 'dart:async';
import 'dart:convert';

import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/classes/custom_client.dart' as client;
import 'package:giveagift/core/classes/custom_controller.dart';
import 'package:giveagift/core/classes/custom_exception.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/view/home/model/slides.dart';


class HomeController extends CustomController {

  List<Slide>? slides;

  Future<void> getSlides() async {
    setState(Submitting());
    
    try {
      final response = await client.get(
        Uri.parse('${API.BASE_URL}/api/v1/slides'),
      );

      if (response.statusCode != 200) {
        throw CustomException(jsonDecode(response.body)['message'] ?? 'An error occurred while fetching slides.');
      }

      slides = SlidesResponde.fromJson(jsonDecode(response.body)).data;

      setState(const SubmissionSuccess());
    } catch (e) {
      if (e is CustomException) {
        return setState(SubmissionError(e));
      }

      setState(SubmissionError(CustomException('An error occurred while fetching slides.')));
    }
  }

  @override
  void onInit() {
    getSlides();
    super.onInit();
  }

}
