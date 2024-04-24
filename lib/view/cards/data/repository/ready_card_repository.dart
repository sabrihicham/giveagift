import 'package:giveagift/view/cards/data/models/ready_card.dart';
import 'package:giveagift/view/cards/data/sources/ready_cards_source.dart';

class ReadyCardRepository {
  final ReadyCardsSource readyCardsSource;

  ReadyCardRepository(this.readyCardsSource);

  Future<ReadyCardsResponse> getReadyCards({int? minPrice, int? maxPrice, int? page, int? limit}) async {
    return await ReadyCardsSource.getReadyCards(minPrice: minPrice, maxPrice: maxPrice, page: page, limit: limit);
  }
}