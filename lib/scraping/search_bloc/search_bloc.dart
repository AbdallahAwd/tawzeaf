import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawzeaf/scraping/search_bloc/search_bloc_states.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

import '../../model/all_jobs.dart';

class SearchBloc extends Cubit<SearchBlocStates> {
  SearchBloc() : super(SearchBlocInitial());
  static SearchBloc get(context) => BlocProvider.of(context);

  late AllJobs allJobs;
  List<String> searchHistory = [];
  getSearchedJob(String searchedText) async {
    emit(Searching());
    final url =
        Uri.parse('https://tawzeaf.com/jobs?filter-title=$searchedText');
    final response = await http.get(url);
    final html = dom.Document.html(response.body);
    final titles = html
        .querySelectorAll('div.job-title-wrapper > h2 > a')
        .map((e) => e.innerHtml.trim())
        .toList();

    final jobType = html
        .querySelectorAll('div.job-information > div > div > a.type-job')
        .map((e) => e.innerHtml.trim())
        .toList();

    final location = html
        .querySelectorAll(
            'div.job-information > div.job-location.with-title > div')
        .map((e) => e.innerHtml.trim())
        .toList();
    final images = html
        .querySelectorAll('div.employer-logo.text-center > a > img')
        .map((e) => e.attributes['src'])
        .toList();

    final jobDetailsUrls = html
        .querySelectorAll(
            'div.job-btns.ali-right.flex-column.flex.align-items-end.hidden-xs > a.btn.btn-view')
        .map((e) => e.attributes['href'])
        .toList();

    final salary = html
        .querySelectorAll(
            'div.job-information > div.job-salary.with-title > span')
        .map((e) => e.innerHtml
            .trim()
            .replaceAll('</span>', '')
            .replaceAll('<span class="price-text">', ''))
        .toList();

    allJobs = AllJobs(
      images: images,
      jobDetailsUrls: jobDetailsUrls,
      jobType: jobType,
      salary: salary,
      place: location,
      titles: titles,
    );

    emit(SearchLoaded());
  }
}
