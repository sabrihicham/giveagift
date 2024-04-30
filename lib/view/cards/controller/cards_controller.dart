import 'package:flutter/material.dart';
import 'package:giveagift/core/classes/custom_controller.dart';
import 'package:giveagift/core/classes/custom_exception.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/view/cards/data/models/custom_cards.dart';
import 'package:giveagift/view/cards/data/models/ready_card.dart';
import 'package:giveagift/view/cards/data/repository/custom_cards_repository.dart';
import 'package:giveagift/view/cards/data/repository/ready_card_repository.dart';
import 'package:giveagift/view/cards/data/sources/ready_cards_source.dart';
import 'package:loading_more_list/loading_more_list.dart';

enum CardType {
  readyToUse,
  custom,
}

class CardsController extends CustomController {
  ReadyCardRepository readyCardRepository = ReadyCardRepository(ReadyCardsSource());
  CustomCardsRepository customCardsRepository = CustomCardsRepository(ReadyCardsSource());

  ReadyCardsResponse? readyCardsResponse;
  CustomCardsResponse? customCardsResponse;

  SubmissionState customSubmissionState = const InitialState();
  
  late ReadyCardsSourceRepository readyCardsSourceRepository;
  
  int? get minPrice {
    if(priceRange.start == 100) return null;

    return priceRange.start.toInt();
  }
  int? get maxPrice {
    if(priceRange.end == 500) return null;
    return priceRange.end.toInt();
  }

  List<String> selectedBrands = [];

  RangeValues priceRange = const RangeValues(100, 500);

  Set<String> brands = {};

  @override
  void onInit() {
    super.onInit();

    readyCardsSourceRepository = ReadyCardsSourceRepository(
      readyCardRepository,
      minPrice: minPrice,
      maxPrice: maxPrice,
      brands: selectedBrands,
      onload: () {
        update([CardType.readyToUse.name]);
        readyCardsSourceRepository.response?.data.forEach((element) {
          if(element.brand != null) brands.add(element.brand!);
        });
      },
      onRefesh: () {
        update([CardType.readyToUse.name]);
      }
    );

    fetchCustomCards();
  }

  Future<void> fetchCustomCards() async {
    setCustomSubmissionState(Submitting(), ids: [CardType.custom.name]);
    try {
      customCardsResponse = await customCardsRepository.getCustomyCards();

      setCustomSubmissionState(SubmissionSuccess(), ids: [CardType.custom.name]);
    } on Exception catch (e) {
      if(e is CustomException) {
        return setCustomSubmissionState(SubmissionError(e), ids: [CardType.custom.name]);
      }

      setCustomSubmissionState(SubmissionError(CustomException('حدث مشكل بالاتصال')), ids: [CardType.custom.name]);
    }
  }

  setCustomSubmissionState(SubmissionState state, {List<String>? ids}) {
    customSubmissionState = state;
    update(ids);
  }
}

class ReadyCardsSourceRepository extends LoadingMoreBase<CardData> {
  int pageindex = 1, totalPages = 1;
  bool _hasMore = true;
  bool forceRefresh = false;

  @override
  bool get hasMore => _hasMore || forceRefresh;

  ReadyCardRepository readyCardRepository;

  ReadyCardsResponse? response;

  void Function()? onload, onRefesh;
  int? minPrice, maxPrice;
  List<String>? brands;

  ReadyCardsSourceRepository(this.readyCardRepository, {this.onload, this.onRefesh, this.minPrice, this.maxPrice, this.brands});

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = true;
    pageindex = 1;
    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
    forceRefresh = !clearBeforeRequest;
    var result = await super.refresh(clearBeforeRequest);
    forceRefresh = false;
    if(onRefesh != null) onRefesh!();
    return result;
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = true]) async {

    bool isSuccess = false;
    
    try {
      response = await readyCardRepository.getReadyCards(
        page: pageindex,
        limit: 6,
        minPrice: minPrice,
        maxPrice: maxPrice,
        brands: brands,
      );

      if (pageindex == 1) {
        clear();
      }

      for (var item in response!.data) {
        if (!contains(item) && hasMore) add(item);
      }
      
      if(onload != null) onload!();

      _hasMore = pageindex < response!.totalPages;
      pageindex++;
      isSuccess = true;
    } catch (exception, stack) {
      isSuccess = false;
      debugPrint(exception.toString());
      debugPrint(stack.toString());
    }

    return isSuccess;
  }
}