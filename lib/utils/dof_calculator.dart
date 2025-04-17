// lib/utils/dof_calculator.dart

class DOFResult {
  final double near;
  final double far;
  final double total;
  final double hyperfocal;
  final double railTravel;
  final double focusDistance;

  DOFResult({
    required this.near,
    required this.far,
    required this.total,
    required this.hyperfocal,
    this.railTravel = 0.0,
    this.focusDistance = 0.0,
  });
}

class DOFCalculator {
  static DOFResult calculateFromDistance({
    required double focalLengthMm,
    required double cocMm,
    required double subjectDistanceM,
    required double aperture,
  }) {
    final f = focalLengthMm / 1000.0;
    final s = subjectDistanceM;
    final N = aperture;
    final c = cocMm / 1000.0;

    final H = (f * f) / (N * c);
    final near = (H * s) / (H + (s - f));
    final far = (H * s) / (H - (s - f));
    final total = far.isInfinite ? double.infinity : (far - near);

    return DOFResult(
      near: near,
      far: far,
      total: total,
      hyperfocal: H,
      focusDistance: s,
    );
  }

  static DOFResult calculateFromNearFar({
    required double focalLengthMm,
    required double cocMm,
    required double nearDistanceM,
    required double farDistanceM,
    required double aperture,
  }) {
    final f = focalLengthMm / 1000.0;
    final N = aperture;
    final c = cocMm / 1000.0;

    final H = (f * f) / (N * c);
    final total = farDistanceM - nearDistanceM;
    final focusDistance = 2 * (nearDistanceM * farDistanceM) / (nearDistanceM + farDistanceM);

    return DOFResult(
      near: nearDistanceM,
      far: farDistanceM,
      total: total,
      hyperfocal: H,
      focusDistance: focusDistance,
    );
  }
}
