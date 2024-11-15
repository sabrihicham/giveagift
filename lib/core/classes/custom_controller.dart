import 'package:get/get.dart';
import 'package:giveagift/core/classes/submission_state.dart';

class CustomController extends GetxController {

  Map<String, SubmissionState> submissionStates = {
    'default': const InitialState()
  };

  SubmissionState get defaultState => submissionStates['default'] ?? const InitialState();

  SubmissionState getState(String id) {
    if (submissionStates.containsKey(id)) {
      return submissionStates[id] ?? const InitialState();
    } else {
      return defaultState;
    }
  }

  void setState(SubmissionState status, {List<String>? ids}) {
    if (ids == null) {
      submissionStates['default'] = status;
    } else {
      for (var id in ids) {
        submissionStates[id] = status;
      }
      
    }
    update(ids);
  }
}