enum LiveActivityState {
  /// The Live Activity is active, visible to the user, and can receive content updates
  active,

  /// The Live Activity is visible, but the user, app, or system ended it, and it won't update its content
  /// anymore.
  ended,

  /// The Live Activity ended and is no longer visible because the user or the system removed it.
  dismissed,

  /// The Live Activity content is out of date and needs an update.
  stale,
  unknown,
}
