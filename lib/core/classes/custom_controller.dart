import 'package:get/get.dart';
import 'package:giveagift/core/classes/submission_state.dart';

class CustomController extends GetxController {
  SubmissionState submissionState = const InitialState();


  void setState(SubmissionState status, {List<String>? ids}) {
    submissionState = status;
    update(ids);
  }
}