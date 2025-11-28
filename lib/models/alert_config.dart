class AlertConfig {
  final String title;
  final String body;
  final String? sound;

  AlertConfig({required this.title, required this.body, this.sound});

  Map<String, String> toMap() => {
    'title': title,
    'body': body,
    if (sound != null) 'sound': sound!,
  };
}
