abstract class SessionBase {
  final bool enabled;
  final int time;

  const SessionBase({
    this.enabled = true,
    this.time = 10,
  });
}
