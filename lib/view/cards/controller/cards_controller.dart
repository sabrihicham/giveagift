import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveagift/core/classes/custom_controller.dart';
import 'package:giveagift/core/classes/custom_exception.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/view/cards/data/models/ads.dart';
import 'package:giveagift/view/cards/data/models/category.dart';
import 'package:giveagift/view/cards/data/models/color.dart';
import 'package:giveagift/view/cards/data/models/ready_card.dart';
import 'package:giveagift/view/cards/data/models/shape.dart';
import 'package:giveagift/view/cards/data/repository/ads_repository.dart';
import 'package:giveagift/view/cards/data/repository/colors_repository.dart';
import 'package:giveagift/view/cards/data/repository/ready_card_repository.dart';
import 'package:giveagift/view/cards/data/repository/shapes_repository.dart';
import 'package:giveagift/view/cards/data/sources/ads_source.dart';
import 'package:giveagift/view/cards/data/sources/colors_source.dart';
import 'package:giveagift/view/cards/data/sources/ready_cards_source.dart';
import 'package:giveagift/view/cards/data/sources/shapes_source.dart';
import 'package:giveagift/view/cards/pages/custom_card_page.dart';
import 'package:loading_more_list/loading_more_list.dart';

enum CardType {
  readyToUse,
  custom,
}

class Range {
  double? start;
  double? end;

  Range(this.start, this.end);
}

class CardsController extends CustomController {
  ReadyCardRepository readyCardRepository =
      ReadyCardRepository(ReadyCardsSource());
  AdsRepository adsRepository = AdsRepository(AdsSource());
  ColorsRepository colorsRepository = ColorsRepository(ColorsSourceImp());
  ShapesRepository shapesRepository = ShapesRepository(ShapesSourceImpl());

  // Categories
  CategoriesResponse? categoriesResponse;

  // ReadyCardsResponse? readyCardsResponse;
  ColorsResponse? colorsResponse;
  ShapesResponse? shapesResponse;

  // Ads
  AdsResponse? adsResponse;

  late ReadyCardsSourceRepository readyCardsSourceRepository;

  // int? get minPrice {
  //   if (priceRange.start == 100) return null;

  //   return priceRange.start.toInt();
  // }

  // int? get maxPrice {
  //   if (priceRange.end == 500) return null;
  //   return priceRange.end.toInt();
  // }

  List<String> selectedBrands = [];

  Range priceRange = Range(0, 1000);

  Set<String> brands = {};

  @override
  void onInit() {
    super.onInit();

    readyCardsSourceRepository = ReadyCardsSourceRepository(readyCardRepository, priceRange: priceRange, brands: selectedBrands, onload: () {
      update([CardType.readyToUse.name]);
      readyCardsSourceRepository.response?.data.cards.forEach((element) {
        if (element.shop != null) brands.add(element.shop!.name);
      });
    }, onRefesh: () {
      update([CardType.readyToUse.name]);
    });

    fetchColors();
    fetchShapes();
    fetchCategories();
    fetchAds();
  }

  void filterReadyCardsLocaly() {
    readyCardsSourceRepository.refresh();
  }

  Future<void> fetchColors() async {
    setColorsSubmissionState(Submitting());
    try {
      colorsResponse = await colorsRepository.getColors();

      setColorsSubmissionState(SubmissionSuccess());
    } on Exception catch (e) {
      if (e is CustomException) {
        return setColorsSubmissionState(SubmissionError(e));
      }

      setColorsSubmissionState(
          SubmissionError(CustomException('حدث مشكل بالاتصال')));
    }
  }

  Future<void> fetchShapes() async {
    setShapesSubmissionState(Submitting());
    try {
      shapesResponse = await shapesRepository.getShapes();
      setShapesSubmissionState(SubmissionSuccess());
    } on Exception catch (e) {
      if (e is CustomException) {
        return setShapesSubmissionState(SubmissionError(e));
      }

      setShapesSubmissionState(
          SubmissionError(CustomException('حدث مشكل بالاتصال')));
    }
  }

  Future<void> fetchCategories() async {
    setCategoriesSubmissionState(Submitting());
    try {
      categoriesResponse = await readyCardRepository.getCategories();

      if (categoriesResponse?.status != 'success') {
        throw CustomException(
            categoriesResponse?.message ?? 'حدث مشكل بالاتصال');
      }

      setCategoriesSubmissionState(const SubmissionSuccess());
    } on Exception catch (e) {
      if (e is CustomException) {
        return setCategoriesSubmissionState(SubmissionError(e));
      }

      setCategoriesSubmissionState(
          SubmissionError(CustomException('حدث مشكل بالاتصال')));
    }
  }

  int fetchRetry = 0;

  Future<void> fetchAds() async {
    setAdsSubmissionState(Submitting());
    try {
      adsResponse = await adsRepository.getAds();

      if (categoriesResponse?.status != 'success') {
        throw CustomException(adsResponse?.message ?? 'something_went_wrong'.tr);
      }

      fetchRetry = 0;

      setAdsSubmissionState(const SubmissionSuccess());
    } on Exception catch (e) {
      if (++fetchRetry <= 3) {
        return fetchAds();
      }

      if (e is CustomException) {
        return setAdsSubmissionState(SubmissionError(e));
      }

      setAdsSubmissionState(
          SubmissionError(CustomException('something_went_wrong'.tr)));
    }
  }

  void setColorsSubmissionState(SubmissionState state) {
    setState(state, ids: [CustomCardStep.color.name]);
  }

  SubmissionState? get colorsState =>
      submissionStates[CustomCardStep.color.name];

  void setShapesSubmissionState(SubmissionState state) {
    setState(state, ids: [CustomCardStep.shape.name]);
  }

  SubmissionState? get shapesState =>
      submissionStates[CustomCardStep.shape.name];

  void setCategoriesSubmissionState(SubmissionState state) {
    setState(state, ids: ['categories']);
  }

  SubmissionState? get categoriesState => submissionStates['categories'];

  void setAdsSubmissionState(SubmissionState state) {
    setState(state, ids: ['ads']);
  }

  SubmissionState? get adsState => submissionStates['ads'];
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
  Range? priceRange;
  List<String>? brands;
  String searchText = '';

  ReadyCardsSourceRepository(this.readyCardRepository,
      {this.onload, this.onRefesh, this.priceRange, this.brands}) {
        loadData();
      }

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = true;
    pageindex = 1;
    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
    forceRefresh = !clearBeforeRequest;
    var result = await super.refresh(clearBeforeRequest);
    forceRefresh = false;
    if (onRefesh != null) onRefesh!();
    return result;
  }

  void emptyFilter() {
    searchText = '';
    priceRange = null;
    brands = null;
    setState();
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = true]) async {
    bool isSuccess = false;

    try {
      response = await readyCardRepository.getReadyCards(
        page: pageindex,
        limit: 6,
        minPrice: priceRange?.start?.toInt(),
        maxPrice: priceRange?.end?.toInt(),
        brands: brands,
      );

      if (pageindex == 1) {
        clear();
      }

      // response?.data.cards.sort((a, b) => (a.priority ?? 99999).compareTo(b.priority ?? 99999));

      for (var item in response!.data.cards) {
        if (!contains(item) && hasMore) {
          add(item
            ..frontShape = response!.data.frontShape
            ..backShape = response!.data.backShape);
        }

        if (searchText.isNotEmpty) {
          if (!(item.shop?.name.toLowerCase().contains(searchText.toLowerCase()) ?? false)) {
            remove(item);
          }
        }

        if (priceRange != null) {
          if (item.price < (priceRange!.start ?? double.negativeInfinity) ||
              (item.price > (priceRange!.end ?? double.infinity))) {
            remove(item);
          }
        }

        if (brands?.isNotEmpty == true && item.shop != null) {
          if (!brands!.contains(item.shop!.name)) {
            remove(item);
          }
        }
      }

      if (onload != null) onload!();

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
