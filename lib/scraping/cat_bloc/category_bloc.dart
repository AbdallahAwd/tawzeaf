import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/blogs.dart';
import '../../model/job_cat.dart';
import 'category_states.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class CategoryBloc extends Cubit<CategoryStates> {
  CategoryBloc() : super(CateInitState());
  static CategoryBloc get(context) => BlocProvider.of(context);
  late JobCategory jobCategory;
  late Blog blog;
  bool isLoading = true;
  getCatJob(
    String category,
  ) async {
    emit(IsLoadingCat());

    final url = Uri.parse('https://tawzeaf.com/job-category/$category/page/1');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    final titles = html
        .querySelectorAll('div.job-title-wrapper > h2 > a')
        .map((e) => e.innerHtml.trim())
        .toList();
    final jobType = html
        .querySelectorAll('div.job-information > div.job-type > div > a')
        .map((e) => e.innerHtml.trim())
        .toList();
    final salary = html
        .querySelectorAll(
            'div.job-information > div.job-salary.with-title > span')
        .map((e) => e.innerHtml
            .trim()
            .replaceAll('</span>', '')
            .replaceAll('<span class="price-text">', ''))
        .toList();
    final location = html
        .querySelectorAll(
            'div.job-information > div.job-location.with-title > div')
        .map((e) => e.innerHtml.trim())
        .toList();
    final jobDetailsUrl = html
        .querySelectorAll(
            'div.job-btns.ali-right.flex-column.flex.align-items-end.hidden-xs > a.btn.btn-view')
        .map((e) => e.attributes['href'])
        .toList();
    final images = html
        .querySelectorAll('div.employer-logo.text-center > a > img')
        .map((e) => e.attributes['src'])
        .toList();

    jobCategory = JobCategory(
        titles: titles,
        jobType: jobType,
        salary: salary,
        images: images,
        jobDetailsUrl: jobDetailsUrl,
        location: location);

    emit(LoadedCat());
  }

  List<String> titles = [];
  List<String> date = [];
  List<String> category = [];
  List<String> description = [];
  List<String?> images = [];
  List<String?> detailsUrls = [];
  getBlogs({int page = 1}) async {
    emit(IsLoadingBlog());
    final url = Uri.parse('https://tawzeaf.com/blog/page/$page');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    titles.addAll(html
        .querySelectorAll('div.inner-bottom > h4 > a')
        .map((e) => e.innerHtml.trim())
        .toList());
    images.addAll(html
        .querySelectorAll('div.top-image > figure > a > div > img')
        .map((e) => e.attributes['data-src'])
        .toList());
    date.addAll(html
        .querySelectorAll(
            'div.top-info-post-gird.flex-middle.justify-content-center > div.date')
        .map((e) => e.text.trim())
        .toList());
    category.addAll(html
        .querySelectorAll(
            'div.top-info-post-gird.flex-middle.justify-content-center > div.category > div')
        .map((e) => e.text.trim())
        .toList());
    detailsUrls.addAll(html
        .querySelectorAll('article > div.inner-bottom > a')
        .map((e) => e.attributes['href'])
        .toList());
    description.addAll(html
        .querySelectorAll('div.inner-bottom > h4 > a')
        .map((e) => e.text.trim())
        .toList());

    blog = Blog(
      title: titles,
      image: images,
      date: date,
      category: category,
      datailsUrl: detailsUrls,
      description: description,
    );

    emit(LoadedBlog());
  }

  List<String> article = [];
  blogDetails(String blogUrl) async {
    isLoading = true;
    emit(LoadingDetails());
    final url = Uri.parse(blogUrl);
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    article = html
        .querySelectorAll('div.single-info.info-bottom > div')
        .map((e) => e.innerHtml.trim())
        .toList();

    isLoading = false;
    emit(LoadedDetails());
  }
}
