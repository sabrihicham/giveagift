import 'package:giveagift/view/cards/data/models/category.dart';
import 'package:giveagift/view/cards/data/models/ready_card.dart';
import 'package:giveagift/view/cards/data/sources/ready_cards_source.dart';

class ReadyCardRepository {
  final ReadyCardsSource readyCardsSource;

  ReadyCardRepository(this.readyCardsSource);

  Future<ReadyCardsResponse> getReadyCards({int? minPrice, int? maxPrice, int? page, int? limit, List<String>? brands}) async {
    return await readyCardsSource.getReadyCards(minPrice: minPrice, maxPrice: maxPrice, page: page, limit: limit, brands: brands);
  }

  Future<CategoriesResponse> getCategories() {
    return readyCardsSource.getCategories();
  }
}