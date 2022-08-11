class JobCategory {
  JobCategory(
      {required this.titles,
      required this.jobType,
      required this.salary,
      required this.jobDetailsUrl,
      required this.images,
      required this.location});
  final List<String> titles;
  final List<String> jobType;
  final List<String> salary;
  final List<String?> images;
  final List<String?> jobDetailsUrl;
  final List<String> location;
}
