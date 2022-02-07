class TrackSettings {
  final bool dynamicTrack;
  final int startValue;
  final int randomness;
  final int trasferredGrip;
  final int lapsToImprove;

  const TrackSettings({
    required this.dynamicTrack,
    required this.lapsToImprove,
    required this.randomness,
    required this.startValue,
    required this.trasferredGrip,
  });

  TrackSettings copyWith({
    bool? dynamicTrack,
    int? startValue,
    int? randomness,
    int? trasferredGrip,
    int? lapsToImprove,
  }) {
    return TrackSettings(
      dynamicTrack: dynamicTrack ?? this.dynamicTrack,
      startValue: startValue ?? this.startValue,
      randomness: randomness ?? this.randomness,
      trasferredGrip: trasferredGrip ?? this.trasferredGrip,
      lapsToImprove: lapsToImprove ?? this.lapsToImprove,
    );
  }
}
