import 'package:giveagift/constants/api.dart';

extension WebImages on String {
  String get shapeImage {
    return '${API.BASE_URL}/shapes/$this';
  }

  String get specialImage {
    return '${API.BASE_URL}/specialCards/$this';
  }

  String get shopImage {
    return '${API.BASE_URL}/shops/$this';
  }

  String get colorImage {
    return '${API.BASE_URL}/colors/$this';
  }

  String get categoryImage {
    return '${API.BASE_URL}/categories/$this';
  }

  String get slidesImage {
    return '${API.BASE_URL}/slides/$this';
  }

  String get adsImage {
    return '${API.BASE_URL}/ads/$this';
  }
}
