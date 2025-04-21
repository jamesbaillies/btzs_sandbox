class Session {
  String? title;
  String? holder;
  String? film;
  double? focalLength;
  double? flareFactor;
  double? paperES;

  // Metering
  double? loEv;
  double? hiEv;
  double? loZone;
  double? hiZone;
  String? meteringNotes;

  // Factors
  String? filter;
  double? bellowsValue;
  double? totalExposureFactor;

  // DOF
  double? hyperfocalDistance;

  // Exposure
  double? aperture;
  double? shutterSpeed;

  // For saving + loading
  DateTime? timestamp;

  Session({
    this.title,
    this.holder,
    this.film,
    this.focalLength,
    this.flareFactor,
    this.paperES,
    this.loEv,
    this.hiEv,
    this.loZone,
    this.hiZone,
    this.meteringNotes,
    this.filter,
    this.bellowsValue,
    this.totalExposureFactor,
    this.hyperfocalDistance,
    this.aperture,
    this.shutterSpeed,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      title: json['title'],
      holder: json['holder'],
      film: json['film'],
      focalLength: json['focalLength']?.toDouble(),
      flareFactor: json['flareFactor']?.toDouble(),
      paperES: json['paperES']?.toDouble(),
      loEv: json['loEv']?.toDouble(),
      hiEv: json['hiEv']?.toDouble(),
      loZone: json['loZone']?.toDouble(),
      hiZone: json['hiZone']?.toDouble(),
      meteringNotes: json['meteringNotes'],
      filter: json['filter'],
      bellowsValue: json['bellowsValue']?.toDouble(),
      totalExposureFactor: json['totalExposureFactor']?.toDouble(),
      hyperfocalDistance: json['hyperfocalDistance']?.toDouble(),
      aperture: json['aperture']?.toDouble(),
      shutterSpeed: json['shutterSpeed']?.toDouble(),
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'holder': holder,
      'film': film,
      'focalLength': focalLength,
      'flareFactor': flareFactor,
      'paperES': paperES,
      'loEv': loEv,
      'hiEv': hiEv,
      'loZone': loZone,
      'hiZone': hiZone,
      'meteringNotes': meteringNotes,
      'filter': filter,
      'bellowsValue': bellowsValue,
      'totalExposureFactor': totalExposureFactor,
      'hyperfocalDistance': hyperfocalDistance,
      'aperture': aperture,
      'shutterSpeed': shutterSpeed,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}
