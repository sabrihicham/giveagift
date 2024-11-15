// {
//     "status": "success",
//     "data": {
//         "discountCode": {
//             "isUsed": false
//         },
//         "price": {
//             "value": 10,
//             "fontFamily": "Cairo",
//             "fontSize": 18,
//             "fontColor": "#333333",
//             "fontWeight": 600
//         },
//         "text": {
//             "message": "card desc....",
//             "fontFamily": "Cairo",
//             "fontSize": 18,
//             "fontColor": "#333333",
//             "fontWeight": 600,
//             "xPosition": 122.44,
//             "yPosition": 32.9
//         },
//         "_id": "66f42064dcd6bd834dd5edf7",
//         "isSpecial": false,
//         "proColor": {
//             "_id": "66ec9ec90424308c93ba225a",
//             "image": "color-8281ad04-a2c6-460d-9ffa-fdcf77b4b437-1726783177288.png",
//             "price": 5,
//             "createdAt": "2024-09-19T21:59:37.644Z",
//             "updatedAt": "2024-09-19T21:59:37.644Z",
//             "__v": 0
//         },
//         "isPaid": false,
//         "shop": {
//             "_id": "66dae18415995349e8ab5d77",
//             "name": "VEO",
//             "logo": "shop6.jpg",
//             "description": "Short description for the shop",
//             "__v": 0,
//             "createdAt": "2024-09-06T11:03:32.876Z",
//             "updatedAt": "2024-09-21T14:17:22.148Z",
//             "link": "https://shop-url.com",
//             "isOnline": false
//         },
//         "shapes": [
//             {
//                 "shape": "66dc64cf17cf59c263c9e88a",
//                 "position": {
//                     "x": 24.7,
//                     "y": 9.1
//                 },
//                 "scale": 0.66,
//                 "rotation": 270,
//                 "_id": "66f42064dcd6bd834dd5edf8"
//             },
//             {
//                 "shape": "66dc64cf17cf59c263c9e87f",
//                 "position": {
//                     "x": 24.7,
//                     "y": 9.1
//                 },
//                 "scale": 0.66,
//                 "rotation": 100,
//                 "_id": "66f42064dcd6bd834dd5edf9"
//             }
//         ],
//         "user": "66e93fc32e6d1880c7ceee28",
//         "createdAt": "2024-09-25T14:38:28.220Z",
//         "updatedAt": "2024-09-25T15:33:46.306Z",
//         "__v": 0,
//         "priceAfterDiscount": 2.59
//     }
// }


import 'package:giveagift/view/cart/data/model/card.dart';

class ApplyCouponResponse {
  ApplyCouponResponse({
    required this.status,
    required this.data,
  });

  final String status;
  final Card data;

  factory ApplyCouponResponse.fromJson(Map<String, dynamic> json) => ApplyCouponResponse(
    status: json["status"],
    data: Card.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

