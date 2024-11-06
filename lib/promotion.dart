// promotion.dart

class Promotion {
  final String imageUrl;
  final String title;
  final String description;
  final bool isPDF;
  final String pdfPath;

  Promotion({
    required this.imageUrl,
    required this.title,
    required this.description,
    this.isPDF = false,
    this.pdfPath = '',
  });
}
