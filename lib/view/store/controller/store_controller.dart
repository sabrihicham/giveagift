import 'package:giveagift/core/classes/custom_controller.dart';
import 'package:giveagift/core/classes/custom_exception.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/view/store/data/model/store.dart';
import 'package:giveagift/view/store/data/repository/store_repository.dart';
import 'package:giveagift/view/store/data/source/store_source.dart';

class StoreController extends CustomController {
  StoreRepository storeRepository = StoreRepository(StoreSource());

  Map<int, Set<StoreModel>> stores = {};

  StoreModelResponse? response;

  int page = 1;

  void fetchStore() async {
    if(stores[page] != null && stores[page]!.isNotEmpty) {
      return setState(SubmissionSuccess());
    }

    setState(Submitting());

    try {
      response = await storeRepository.getStores(page: page);

      for (var element in response!.data) {
        if(stores[page] == null) {
          stores[page] = {};
        }

        stores[page]!.add(element);
      }

      setState(SubmissionSuccess());
    } catch (e) {
      if(e is CustomException) {
        return setState(SubmissionError(e));
      }

      setState(SubmissionError(CustomException('حدث مشكل بالاتصال')));
    }
  }

  @override
  void onInit() {
    fetchStore();
    super.onInit();
  }
  
}