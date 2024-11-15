

import 'package:giveagift/view/cards/data/models/ads.dart';
import 'package:giveagift/view/cards/data/sources/ads_source.dart';

class AdsRepository {
  final AdsSource adsSource;

  AdsRepository(this.adsSource);

  Future<AdsResponse> getAds() async {
    return await adsSource.getAds();
  }
}