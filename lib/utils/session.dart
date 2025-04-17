class Session {
  // Shared Fields
  String exposureTitle;
  String filmHolder;
  String filmStock;
  double? focalLength; // FIXED: was String before
  DateTime timestamp;

  // Metering
  String? meteringMethod;
  double? loEv;
  double? hiEv;
  double? loZone;
  double? hiZone;
  String? meteringNotes;

  // Factors
  String? selectedFilter;
  String? bellowsFactorMode;
  double? bellowsValue;
  String? exposureAdjustment;

  // DOF
  String? dofMode;
  double? aperture;
  double? distance;
  double? railTravel;
  double? nearDistance;
  double? farDistance;
  double? circleOfConfusion;
  bool? favorDOF;

  Session({
    this.exposureTitle = '',
    this.filmHolder = '',
    this.filmStock = 'Not Set',
    this.focalLength, // FIXED: changed from 'Not Set'
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'exposureTitle': exposureTitle,
    'filmHolder': filmHolder,
    'filmStock': filmStock,
    'focalLength': focalLength,
    'timestamp': timestamp.toIso8601String(),
    'meteringMethod': meteringMethod,
    'loEv': loEv,
    'hiEv': hiEv,
    'loZone': loZone,
    'hiZone': hiZone,
    'meteringNotes': meteringNotes,
    'selectedFilter': selectedFilter,
    'bellowsFactorMode': bellowsFactorMode,
    'bellowsValue': bellowsValue,
    'exposureAdjustment': exposureAdjustment,
    'dofMode': dofMode,
    'aperture': aperture,
    'distance': distance,
    'railTravel': railTravel,
    'nearDistance': nearDistance,
    'farDistance': farDistance,
    'circleOfConfusion': circleOfConfusion,
    'favorDOF': favorDOF,
  };

  static Session fromJson(Map<String, dynamic> json) {
    return Session(
      exposureTitle: json['exposureTitle'] ?? '',
      filmHolder: json['filmHolder'] ?? '',
      filmStock: json['filmStock'] ?? 'Not Set',
      focalLength: (json['focalLength'] as num?)?.toDouble(), // FIXED
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    )
      ..meteringMethod = json['meteringMethod']
      ..loEv = (json['loEv'] as num?)?.toDouble()
      ..hiEv = (json['hiEv'] as num?)?.toDouble()
      ..loZone = (json['loZone'] as num?)?.toDouble()
      ..hiZone = (json['hiZone'] as num?)?.toDouble()
      ..meteringNotes = json['meteringNotes']
      ..selectedFilter = json['selectedFilter']
      ..bellowsFactorMode = json['bellowsFactorMode']
      ..bellowsValue = (json['bellowsValue'] as num?)?.toDouble()
      ..exposureAdjustment = json['exposureAdjustment']
      ..dofMode = json['dofMode']
      ..aperture = (json['aperture'] as num?)?.toDouble()
      ..distance = (json['distance'] as num?)?.toDouble()
      ..railTravel = (json['railTravel'] as num?)?.toDouble()
      ..nearDistance = (json['nearDistance'] as num?)?.toDouble()
      ..farDistance = (json['farDistance'] as num?)?.toDouble()
      ..circleOfConfusion = (json['circleOfConfusion'] as num?)?.toDouble()
      ..favorDOF = json['favorDOF'] as bool?;
  }
}