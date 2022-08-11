class NewestJobs {
  List<String>? titles;
  List<String>? urls;
  List<String?> imageurls;
  List<String?> jobTypes;
  List<String?> jobLocation;
  List<String?> jobDetails;

  NewestJobs(
      {this.titles,
      this.urls,
      required this.jobLocation,
      required this.jobDetails,
      required this.imageurls,
      required this.jobTypes});
}
