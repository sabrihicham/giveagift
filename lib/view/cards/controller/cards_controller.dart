import 'package:giveagift/core/classes/custom_controller.dart';
import 'package:giveagift/core/classes/custom_exception.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/view/cards/data/models/ready_card.dart';
import 'package:giveagift/view/cards/data/repository/ready_card_repository.dart';
import 'package:giveagift/view/cards/data/sources/ready_cards_source.dart';

enum CardType {
  readyToUse,
  custom,
}

class CardsController extends CustomController {
  ReadyCardRepository readyCardRepository = ReadyCardRepository(ReadyCardsSource());

  ReadyCardsResponse? response;

  @override
  void onInit() {
    super.onInit();
    fetchReadyCards();
  }

  void fetchReadyCards() async {
    setState(Submitting(), ids: [CardType.readyToUse.name]);
    try {
      response = await readyCardRepository.getReadyCards();
      setState(SubmissionSuccess(), ids: [CardType.readyToUse.name]);
    } on Exception catch (e) {
      if(e is CustomException) {
        return setState(SubmissionError(e), ids: [CardType.readyToUse.name]);
      }

      setState(SubmissionError(CustomException('حدث مشكل بالاتصال')), ids: [CardType.readyToUse.name]);
    }
  }

}