class Blog {
  Blog({
    required this.title,
    this.description,
    required this.image,
    required this.date,
    required this.category,
    required this.datailsUrl,
  });

  final List<String> title;
  final List<String>? description;
  final List<String?> image;
  final List<String> date;
  final List<String> category;
  final List<String?> datailsUrl;
}
