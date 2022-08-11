class JobDetailsModel {
  const JobDetailsModel({
    required this.jobLocation,
    this.applyUrl,
    required this.jobInformation,
    required this.article,
  });
  final String jobLocation;
  final String? applyUrl;
  final List<String> article;
  final List<String> jobInformation;
}
