// class StoreModelResponse {
//   List<StoreModel> data;
//   int totalPages;

//   StoreModelResponse({required this.data, required this.totalPages});

//   factory StoreModelResponse.fromJson(Map<String, dynamic> json) {
//     List<StoreModel> data = [];
//     if (json['data'] != null) {
//       json['data'].forEach((v) {
//         data.add(StoreModel.fromJson(v));
//       });
//     }
//     return StoreModelResponse(
//       data: data,
//       totalPages: json['totalPages'],
//     );
//   }
// }

// class StoreModel {
//   String id;
//   String logoName;
//   String? logoImage;
//   String brandDescription;
//   String? logoWithoutBackground;
//   String? brandUrl;
//   int v;

//   StoreModel({
//     required this.id,
//     required this.logoName,
//     required this.logoImage,
//     required this.brandDescription,
//     required this.logoWithoutBackground,
//     required this.brandUrl,
//     required this.v,
//   });

//   factory StoreModel.fromJson(Map<String, dynamic> json) {
//     return StoreModel(
//       id: json['_id'],
//       logoName: json['logoName'],
//       logoImage: json['logoImage'],
//       brandDescription: json['brandDescription'],
//       logoWithoutBackground: json['logoWithoutBackground'],
//       brandUrl: json['brandUrl'],
//       v: json['__v'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'logoName': logoName,
//       'logoImage': logoImage,
//       'brandDescription': brandDescription,
//       'logoWithoutBackground': logoWithoutBackground,
//       'brandUrl': brandUrl,
//       '__v': v,
//     };
//   }
// }
