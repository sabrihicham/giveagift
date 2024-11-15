import 'package:giveagift/core/classes/custom_exception.dart';

abstract class SubmissionState {
  const SubmissionState();
}

class InitialState extends SubmissionState {
  const InitialState();
}

class Submitting extends SubmissionState {}

class SubmissionSuccess extends SubmissionState {
  final String? message;
  const SubmissionSuccess({this.message});
}

class SubmissionUnauthorized extends SubmissionState {}

class SubmissionError extends SubmissionState {
  final CustomException exception;

  SubmissionError(this.exception);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubmissionError &&
        other.exception == exception &&
        exception.message == other.exception.message;
  }

  @override
  int get hashCode => exception.hashCode;
}
