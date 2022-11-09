class UrlSchemeData {
  final String scheme;
  final String? url;
  final String? host;
  final String? path;
  final List<Map<String, String>> queryParameters;

  UrlSchemeData({
    required this.scheme,
    this.url,
    this.host,
    this.path,
    this.queryParameters = const [],
  });

  factory UrlSchemeData.fromMap(Map<String, dynamic> map) {
    return UrlSchemeData(
      scheme: map['scheme'] ?? '',
      url: map['url'],
      host: map['host'],
      path: map['path'],
      queryParameters: map['queryItems'] != null
          ? (map['queryItems'] as List)
              .map((e) => Map<String, String>.from(e))
              .toList()
          : [],
    );
  }
}
