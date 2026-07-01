class UploadResult {
  const UploadResult({
    required this.fileName,
    required this.url,
    required this.relativeUrl,
  });

  final String fileName;
  final String url;
  final String relativeUrl;

  factory UploadResult.fromJson(Map<String, dynamic> json) {
    return UploadResult(
      fileName: json['fileName'] as String? ?? '',
      url: json['url'] as String? ?? '',
      relativeUrl: json['relativeUrl'] as String? ?? '',
    );
  }
}
