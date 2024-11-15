import 'package:giveagift/view/cards/data/models/color.dart';
import 'package:giveagift/view/cards/data/sources/colors_source.dart';

class ColorsRepository {
  final ColorsSource colorsSource;

  ColorsRepository(this.colorsSource);

  Future<ColorsResponse> getColors() async {
    return await colorsSource.getColors();
  }
}