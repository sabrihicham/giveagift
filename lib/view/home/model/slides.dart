// {
//     "status": "success",
//     "results": 3,
//     "data": [
//         {
//             "_id": "6715cbbdf685e3475c1a498c",
//             "image": "demo-slide.png",
//             "order": 3,
//             "createdAt": "2024-10-21T03:34:21.545Z",
//             "updatedAt": "2024-10-21T03:34:21.545Z"
//         },
//         {
//             "_id": "6715cbb8f685e3475c1a4989",
//             "image": "demo-slide.png",
//             "order": 2,
//             "createdAt": "2024-10-21T03:34:16.876Z",
//             "updatedAt": "2024-10-21T03:34:16.876Z"
//         },
//         {
//             "_id": "6715cbb1f685e3475c1a4986",
//             "image": "demo-slide.png",
//             "order": 1,
//             "createdAt": "2024-10-21T03:34:09.426Z",
//             "updatedAt": "2024-10-21T03:34:09.426Z"
//         }
//     ]
// }

import 'package:giveagift/core/extensions/web_images.dart';

class SlidesResponde {
  SlidesResponde({
    required this.status,
    required this.results,
    required this.data,
  });

  final String status;
  final int results;
  final List<Slide> data;

  factory SlidesResponde.fromJson(Map<String, dynamic> json) => SlidesResponde(
    status: json["status"],
    results: json["results"],
    data: List<Slide>.from(json["data"].map((x) => Slide.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "results": results,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Slide {
  Slide({
    required this.id,
    required this.image,
    this.order
  });

  final String id;
  final String image;
  final int? order;

  factory Slide.fromJson(Map<String, dynamic> json) => Slide(
    id: json["_id"],
    image: json["image"],
    order: json["order"]
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "image": image,
    "order": order
  };

  @override
  String toString() {
    return 'Slide{id: $id, image: ${image.slidesImage}, order: $order}';
  }
}