import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:tawzeaf/model/new_jobs.dart';
import 'package:tawzeaf/scraping/home_bloc/web_scraping_states.dart';

import '../../model/all_jobs.dart';
import '../../model/job_details.dart';

class WbScarping extends Cubit<WebScrapingStates> {
  WbScarping() : super(WebScrapingInit());
  static WbScarping get(context) => BlocProvider.of(context);
  late NewestJobs newJobs;

  getTawzeafNewJobs() async {
    final url = Uri.parse('https://tawzeaf.com');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final titles = html
        .querySelectorAll('h2.job-title > a')
        .map((e) => e.innerHtml.trim())
        .toList();
    final urls = html
        .querySelectorAll('div.job-information > h2.job-title > a')
        .map((e) => 'https://tawzeaf.com/${e.attributes['href']}')
        .toList();
    final images = html
        .querySelectorAll('div.employer-logo.text-center > a > img')
        .map((e) => e.attributes['src'])
        .toList();
    final jobDetails = html
        .querySelectorAll('article > div.job-information > a')
        .map((e) => e.attributes['href'])
        .toList();
    final jobTypes = html
        .querySelectorAll('div.job-type > div > a')
        .map((e) => e.innerHtml.trim())
        .toList();
    final jobLocation = html
        .querySelectorAll('article > div.job-information > div.job-location')
        .map((e) => e.innerHtml.trim())
        .toList();

    newJobs = NewestJobs(
      titles: titles,
      urls: urls,
      jobLocation: jobLocation,
      imageurls: images,
      jobDetails: jobDetails,
      jobTypes: jobTypes,
    );
    getAllJobs();
  }

  late AllJobs allJobs;
  List<String> titles = [];
  List<String> jobType = [];
  List<String?> images = [];
  List<String> location = [];
  List<String?> salary = [];
  List<String?> jobDetailsUrls = [];

  getAllJobs({int page = 1}) async {
    final url = Uri.parse('https://tawzeaf.com/jobs/page/$page');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
// #post-5479 > div.vertical-job-header.flex-middle > div.job-title-wrapper > h2 > a
    titles.addAll(html
        .querySelectorAll('div.job-title-wrapper > h2 > a')
        .map((e) => e.innerHtml.trim())
        .toList());

    jobType.addAll(html
        .querySelectorAll('div.job-information > div > div > a.type-job')
        .map((e) => e.innerHtml.trim())
        .toList());

    location.addAll(html
        .querySelectorAll(
            'div.job-information > div.job-location.with-title > div')
        .map((e) => e.innerHtml.trim())
        .toList());
    images.addAll(html
        .querySelectorAll('div.employer-logo.text-center > a > img')
        .map((e) => e.attributes['src'])
        .toList());

    jobDetailsUrls.addAll(html
        .querySelectorAll(
            'div.job-btns.ali-right.flex-column.flex.align-items-end.hidden-xs > a.btn.btn-view')
        .map((e) => e.attributes['href'])
        .toList());

    salary.addAll(html
        .querySelectorAll(
            'div.job-information > div.job-salary.with-title > span')
        .map((e) => e.innerHtml
            .trim()
            .replaceAll('</span>', '')
            .replaceAll('<span class="price-text">', ''))
        .toList());
    allJobs = AllJobs(
      images: images,
      jobDetailsUrls: jobDetailsUrls,
      jobType: jobType,
      salary: salary,
      place: location,
      titles: titles,
    );

    emit(WebScrapingAllLoaded());
  }

  late JobDetailsModel jobDetailsModel;
  detailsScrapping(detailsUrl) async {
    final url = Uri.parse(detailsUrl);
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    Element? jobLocationElement = html
        .querySelector('div.employer-logo-wrapper-v2 > div.inner-info > div');
    String jobLocation = jobLocationElement != null
        ? jobLocationElement.innerHtml
            .replaceAll('<i class="ti-location-pin"></i>', '')
            .replaceAll('<div class="inner-info">', '')
            .replaceAll('<h3 class="job-detail-title">', '')
            .replaceFirst('</h3>', '')
            .replaceFirst('</div>', '')
            .replaceAll('&nbsp;', '')
        : 'غير معروف';

    List<String> jobInformation = html
        .querySelectorAll(
            'div.col-md-4.col-xs-12.sidebar.sidebar-job > aside.widget.widget_apus_job_info > div')
        .map((e) => e.innerHtml.trim())
        .toList();

    List<String> article = html
        .querySelectorAll('div.col-xs-12.col-md-8 > div.job-detail-description')
        .map((e) => e.innerHtml.trim())
        .toList();
    Element? applyUrl = html.querySelector(
        'aside.widget.widget_apus_job_buttons > div > a.btn.btn-apply.btn-apply-job-external');
    String? applyUrlString =
        applyUrl != null ? applyUrl.attributes['href'] : '';
    jobDetailsModel = JobDetailsModel(
      jobLocation: jobLocation,
      article: article,
      jobInformation: jobInformation,
      applyUrl: applyUrlString,
    );

    emit(DetailsScrapingLoaded());
  }
}
