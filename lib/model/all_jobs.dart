class AllJobs {
  List<String>? titles;
  List<String?> images;
  List<String>? jobType;
  List<String> place;
  List<String?> jobDetailsUrls;
  List<String?> salary;

  AllJobs(
      {required this.images,
      required this.jobDetailsUrls,
      this.jobType,
      required this.salary,
      required this.place,
      this.titles});
}
