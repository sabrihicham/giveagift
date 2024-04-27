import 'package:giveagift/view/cards/data/models/custom_cards.dart';
import 'package:giveagift/view/cards/data/sources/custom_cards_source.dart';
import 'package:giveagift/view/cards/data/sources/ready_cards_source.dart';

class CustomCardsRepository {
  final ReadyCardsSource readyCardsSource;

  CustomCardsRepository(this.readyCardsSource);

  Future<CustomCardsResponse> getCustomyCards() async {
    return await CustomCardsSource.getCustomCards();
  }
}