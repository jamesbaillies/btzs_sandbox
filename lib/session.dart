// lib/models/session.dart
class Session {
  String exposureTitle;
  String filmHolder;
  String filmStock;
  double focalLength;

  Session({
    this.exposureTitle = '',
    this.filmHolder = '',
    this.filmStock = 'HP5+',
    this.focalLength = 210.0,
  });

  Map<String, dynamic> toJson() => {
    'exposureTitle': exposureTitle,
    'filmHolder': filmHolder,
    'filmStock': filmStock,
    'focalLength': focalLength,
  };

  static Session fromJson(Map<String, dynamic> json) {
    return Session(
      exposureTitle: json['exposureTitle'] ?? '',
      filmHolder: json['filmHolder'] ?? '',
      filmStock: json['filmStock'] ?? 'HP5+',
      focalLength: (json['focalLength'] ?? 210.0).toDouble(),
    );
  }
}
