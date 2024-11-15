// {
//     "status": "success",
//     "results": 5,
//     "data": [
//         {
//             "_id": "6714e8e0b2869b32c444a03f",
//             "image": "ad-152d3a1f-ba37-4641-a7a7-61770fddfbae-1729423584261.png",
//             "link": "https://fontawesome.com",
//             "order": 2,
//             "size": "small"
//         },
//         {
//             "_id": "6714e909b2869b32c444a043",
//             "image": "ad-47ad9157-0af4-45a4-a53a-7b4039cd567f-1729425432428.png",
//             "link": "https://fontawesome.com",
//             "order": 1,
//             "size": "large"
//         },
//         {
//             "_id": "6714f02eb2869b32c444a086",
//             "image": "ad-5e4c26ab-398b-4db6-9b7e-b3f366e387d2-1729425453655.png",
//             "link": "https://getbootstrap.com/docs/5.3/forms/checks-radios/",
//             "order": 6,
//             "size": "large"
//         },
//         {
//             "_id": "6714f039b2869b32c444a08a",
//             "image": "ad-76233fc7-893d-41c1-825b-fbc243eb0a14-1729425464017.png",
//             "link": "https://getbootstrap.com/docs/5.3/forms/checks-radios/",
//             "order": 8,
//             "size": "large"
//         },
//         {
//             "_id": "6714f053b2869b32c444a092",
//             "image": "ad-2ac85451-4c3f-4332-b1f5-955fb721edf6-1729425489913.png",
//             "link": "https://getbootstrap.com/docs/5.3/forms/checks-radios/",
//             "order": 2,
//             "size": "large"
//         }
//     ]
// }

class AdsResponse {
  final String status;
  final String? message;
  final List<Ads> data;

  AdsResponse({
    required this.status,
    this.message,
    required this.data,
  });

  factory AdsResponse.fromJson(Map<String, dynamic> json) {
    return AdsResponse(
      status: json['status'],
      message: json['message'],
      data: List<Ads>.from(json['data'].map((x) => Ads.fromJson(x))),
    );
  }
}

class Ads {
  final String id;
  final String image;
  final String link;
  final int order;

  Ads({
    required this.id,
    required this.image,
    required this.link,
    required this.order,
  });

  factory Ads.fromJson(Map<String, dynamic> json) {
    return Ads(
      id: json['_id'],
      image: json['image'],
      link: json['link'],
      order: json['order'],
    );
  }
}
