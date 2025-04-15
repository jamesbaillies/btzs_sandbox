// lib/utils/session.dart

class Session {
  // Camera Page
  String exposureTitle;
  String filmHolder;
  String filmStock;
  String focalLength;
  double flareFactor;
  double paperES;
  String? meteringMode;
  int? ev;

  // Metering Page
  String? meteringMethod;
  double? loEv;
  double? hiEv;
  double? loZone;
  double? hiZone;
  String? meteringNotes;


  // Factors Page
  String? selectedFilter;
  String? bellowsFactorMode;
  double? bellowsValue;
  String? exposureAdjustment;


  // DOF Page
  String filmSize;
  bool favorDOF;
  bool useOptimalAperture;

  // Metadata
  DateTime timestamp;

  Session({
    this.exposureTitle = '',
    this.filmHolder = '',
    this.filmStock = '',
    this.focalLength = '',
    this.flareFactor = 0.02,
    this.paperES = 1.05,
    this.meteringMethod = 'Incident',
    this.loZone = 3,
    this.hiZone = 7,
    this.selectedFilter = 'None',
    this.exposureAdjustment = 'none',
    this.filmSize = '4x5',
    this.favorDOF = true,
    this.useOptimalAperture = true,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'exposureTitle': exposureTitle,
    'filmHolder': filmHolder,
    'filmStock': filmStock,
    'focalLength': focalLength,
    'flareFactor': flareFactor,
    'paperES': paperES,
    'meteringMethod': meteringMethod,
    'loZone': loZone,
    'hiZone': hiZone,
    'selectedFilter': selectedFilter,
    'exposureAdjustment': exposureAdjustment,
    'filmSize': filmSize,
    'favorDOF': favorDOF,
    'useOptimalAperture': useOptimalAperture,
    'timestamp': timestamp.toIso8601String(),
  };

  static Session fromJson(Map<String, dynamic> json) => Session(
    exposureTitle: json['exposureTitle'] ?? '',
    filmHolder: json['filmHolder'] ?? '',
    filmStock: json['filmStock'] ?? '',
    focalLength: json['focalLength'] ?? '',
    flareFactor: (json['flareFactor'] ?? 0.02).toDouble(),
    paperES: (json['paperES'] ?? 1.05).toDouble(),
    meteringMethod: json['meteringMethod'] ?? 'Incident',
    loZone: json['loZone'] ?? 3,
    hiZone: json['hiZone'] ?? 7,
    selectedFilter: json['selectedFilter'] ?? 'None',
    exposureAdjustment: json['exposureAdjustment'] ?? 'none',
    filmSize: json['filmSize'] ?? '4x5',
    favorDOF: json['favorDOF'] ?? true,
    useOptimalAperture: json['useOptimalAperture'] ?? true,
    timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
  );
}
