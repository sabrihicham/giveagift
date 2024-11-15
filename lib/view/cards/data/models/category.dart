// {
//     "status": "success",
//     "results": 6,
//     "data": [
//         {
//             "_id": "6711e72e574b9aa8b230cd01",
//             "name": "ملابس",
//             "icon": "laundry.png",
//             "createdAt": "2024-10-18T04:42:22.876Z",
//             "updatedAt": "2024-10-18T04:42:22.876Z"
//         },
//         {
//             "_id": "6711e72e574b9aa8b230cd02",
//             "name": "مطاعم ومقاهي",
//             "icon": "dinner.png",
//             "createdAt": "2024-10-18T04:42:22.876Z",
//             "updatedAt": "2024-10-18T04:42:22.876Z"
//         },
//         {
//             "_id": "6711e72e574b9aa8b230cd03",
//             "name": "ورد",
//             "icon": "flowers.png",
//             "createdAt": "2024-10-18T04:42:22.876Z",
//             "updatedAt": "2024-10-18T04:42:22.876Z"
//         },
//         {
//             "_id": "6711e72e574b9aa8b230cd04",
//             "name": "مجوهرات",
//             "icon": "wedding-ring.png",
//             "createdAt": "2024-10-18T04:42:22.876Z",
//             "updatedAt": "2024-10-18T04:42:22.876Z"
//         },
//         {
//             "_id": "6711e72e574b9aa8b230cd05",
//             "name": "عطور",
//             "icon": "perfume.png",
//             "createdAt": "2024-10-18T04:42:22.876Z",
//             "updatedAt": "2024-10-18T04:42:22.876Z"
//         },
//         {
//             "_id": "6711e72e574b9aa8b230cd00",
//             "name": "ساعات",
//             "icon": "smart-watch.png",
//             "createdAt": "2024-10-18T04:42:22.875Z",
//             "updatedAt": "2024-10-18T04:42:22.875Z"
//         }
//     ]
// }

class CategoriesResponse {
  CategoriesResponse({
    required this.status,
    this.message,
    required this.data,
  });

  final String status;
  final String? message;
  final List<Category> data;

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) => CategoriesResponse(
    status: json["status"],
    message: json["message"],
    data: List<Category>.from(json["data"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.enName,
  });

  final String id;
  final String name;
  final String icon;
  final String? enName;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["_id"],
    name: json["name"],
    icon: json["icon"],
    enName: json["enName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "icon": icon,
    "enName": enName,
  };
}