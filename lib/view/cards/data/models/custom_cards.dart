class CustomCardsResponse {
  CustomCardsResponse({
    required this.colors,
    required this.shapes,
    required this.logoWithoutBackgroundUrls,
  });

  final List<String?> colors;
  final List<String?> shapes;
  final List<String?> logoWithoutBackgroundUrls;

  factory CustomCardsResponse.fromJson(Map<String, dynamic> json) {
    return CustomCardsResponse(
      colors: List<String?>.from(json['colors'].map((x) => x)),
      shapes: List<String>.from(json['shapes'].map((x) => x)),
      logoWithoutBackgroundUrls: List<String?>.from(json['logoWithoutBackgroundUrls'].map((x) => x)),
    );
  }
}