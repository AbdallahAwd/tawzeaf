import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tawzeaf/components/components.dart';
import 'package:tawzeaf/scraping/cat_bloc/category_bloc.dart';
import 'package:tawzeaf/scraping/cat_bloc/category_states.dart';
import 'package:tawzeaf/views/job_details.dart';

class CategoryJobs extends StatefulWidget {
  const CategoryJobs({Key? key, required this.jobCategory, required this.index})
      : super(key: key);
  final String jobCategory;
  final int index;

  @override
  State createState() => _CategoryJobsState();
}

class _CategoryJobsState extends State<CategoryJobs>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  final ScrollController _scrollController = ScrollController();
  int page = 1;
  bool isLoading = true;
  int currentIndex = 0;

  @override
  void initState() {
    widget.index != 8
        ? CategoryBloc.get(context).getCatJob(
            widget.jobCategory.replaceAll(' ', '-'),
          )
        : CategoryBloc.get(context).getBlogs();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        page++;
        log('Executing$page');
        currentIndex >= 40
            ? null
            : CategoryBloc.get(context).getBlogs(page: page);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc, CategoryStates>(
      listener: (context, state) {
        if (state is LoadedBlog) {
          setState(() {
            isLoading = false;
          });
        }
      },
      builder: (context, state) => TawzeafScaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white12,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 25,
            ),
          ),
          title: Text(
            widget.jobCategory,
            style: const TextStyle(color: Colors.black, fontFamily: 'Cairo'),
          ),
        ),
        body: state is IsLoadingCat
            ? Center(
                child: SpinKitThreeBounce(
                color: Colors.green,
                controller: _controller,
                size: 30.0,
              ))
            : widget.index != 8
                ? ListView.separated(
                    padding: const EdgeInsets.all(18),
                    itemBuilder: (context, index) {
                      return AllJobsBuilder(
                        jobDetailsUrl: CategoryBloc.get(context)
                            .jobCategory
                            .jobDetailsUrl[index]!,
                        jobImage: CategoryBloc.get(context)
                            .jobCategory
                            .images[index]!,
                        jobTitle:
                            CategoryBloc.get(context).jobCategory.titles[index],
                        location: widget.index == 0 ||
                                widget.index == 2 ||
                                widget.index == 3 ||
                                widget.index == 4 ||
                                widget.index == 5
                            ? ''
                            : CategoryBloc.get(context)
                                .jobCategory
                                .location[index],
                        jobType: CategoryBloc.get(context)
                            .jobCategory
                            .jobType[index],
                        salary: widget.index == 0 ||
                                widget.index == 2 ||
                                widget.index == 4 ||
                                widget.index == 5
                            ? '5000 ريال - 9000 ريال لكل شهر'
                            : CategoryBloc.get(context)
                                .jobCategory
                                .salary[index],
                        size: MediaQuery.of(context).size,
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
                    ),
                    itemCount:
                        CategoryBloc.get(context).jobCategory.titles.length,
                  )
                : isLoading
                    ? Center(
                        child: SpinKitThreeBounce(
                        color: Colors.green,
                        controller: _controller,
                        size: 30.0,
                      ))
                    : ListView.builder(
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          currentIndex = index;
                          if (index <
                              CategoryBloc.get(context).blog.title.length) {
                            return BlogsWidget(
                              category: CategoryBloc.get(context)
                                  .blog
                                  .category[index],
                              date: CategoryBloc.get(context).blog.date[index],
                              description: CategoryBloc.get(context)
                                  .blog
                                  .description![index],
                              detailsUrl: CategoryBloc.get(context)
                                  .blog
                                  .datailsUrl[index]!,
                              image:
                                  CategoryBloc.get(context).blog.image[index]!,
                              title:
                                  CategoryBloc.get(context).blog.title[index],
                            );
                          } else {
                            if (index < 40) {
                              return Center(
                                  child: SpinKitThreeBounce(
                                color: Colors.green,
                                controller: _controller,
                                size: 30.0,
                              ));
                            } else {
                              return const Center(
                                child: Text('لا يوجد مقالات اخري'),
                              );
                            }
                          }
                        },
                        itemCount:
                            CategoryBloc.get(context).blog.title.length + 1,
                      ),
      ),
    );
  }
}

class BlogsWidget extends StatelessWidget {
  const BlogsWidget({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    required this.detailsUrl,
  }) : super(key: key);
  final String image;
  final String title;
  final String description;
  final String date;
  final String category;
  final String detailsUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetails(
              title: title,
              imageUrl: image,
              isJob: false,
              detailsUrl: detailsUrl,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.network(
                image,
                width: 100,
                height: 100,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 120,
                          child: Text(
                            category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
