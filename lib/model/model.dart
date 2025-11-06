class Images {
  final int imageID;
  final String imageAlt;
  final String imagePortraitPath;

  Images(
      {required this.imageID,
      required this.imageAlt,
      required this.imagePortraitPath});

  //factory constructor will return object of this images class
  factory Images.fromJson(Map<String, dynamic> json) => Images(
      imageID: json['id'] as int,
      imageAlt: json['alt'] as String,
      imagePortraitPath: json['src']['portrait'] as String);

  Images.emptyConstructor({
    this.imageID = 0,
    this.imageAlt = '',
    this.imagePortraitPath = '',
  });
}
