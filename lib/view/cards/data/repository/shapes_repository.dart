import 'package:giveagift/view/cards/data/models/shape.dart';
import 'package:giveagift/view/cards/data/sources/shapes_source.dart';

class ShapesRepository {
  final ShapesSource shapesSource;

  ShapesRepository(this.shapesSource);

  Future<ShapesResponse> getShapes() async {
    return await shapesSource.getShapes();
  }
}