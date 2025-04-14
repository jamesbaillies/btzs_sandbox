class Session {
  String title;
  String holder;
  String defaultFilm;
  String defaultFocalLength;
  double defaultFlareFactor;
  double defaultPaperES;
  String defaultMeteringMethod;
  double defaultLoZone;
  double defaultHiZone;
  String defaultFilter;
  String defaultExposureAdjustment;
  double defaultCoC;
  bool favorDOF;
  bool useOptimalAperture;
  String defaultExposureMode;

  Session({
    this.title = '',
    this.holder = '',
    this.defaultFilm = 'Not Set',
    this.defaultFocalLength = 'Not Set',
    this.defaultFlareFactor = 0.02,
    this.defaultPaperES = 1.05,
    this.defaultMeteringMethod = 'Incident',
    this.defaultLoZone = 3.0,
    this.defaultHiZone = 7.0,
    this.defaultFilter = 'None',
    this.defaultExposureAdjustment = 'none',
    this.defaultCoC = 0.1,
    this.favorDOF = false,
    this.useOptimalAperture = false,
    this.defaultExposureMode = 'Aperture',
  });
}
