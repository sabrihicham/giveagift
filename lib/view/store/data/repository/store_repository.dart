import 'package:giveagift/view/store/data/model/store.dart';
import 'package:giveagift/view/store/data/source/store_source.dart';

class StoreRepository {
  final StoreSource storeSource;

  StoreRepository(this.storeSource);

  Future<StoreModelResponse> getStores({int page = 1}) async {
    return await StoreSource.getStores(page: page);
  }
}