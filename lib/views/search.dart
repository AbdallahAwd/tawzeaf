import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tawzeaf/components/components.dart';
import 'package:tawzeaf/scraping/search_bloc/search_bloc.dart';
import 'package:tawzeaf/scraping/search_bloc/search_bloc_states.dart';
import 'package:tawzeaf/shared/pref.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State createState() => _SearchState();
}

class _SearchState extends State<Search> with TickerProviderStateMixin {
  bool isNotLoading = false;
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResult = [];
  AnimationController? _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    getResult();
    super.initState();
  }

  void getResult() async {
    _searchResult = await CacheHelper.getStrings('searched') ?? [];
    setState(() {});
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchBlocStates>(
      listener: (context, state) {
        if (state is SearchLoaded) {
          setState(() {
            isNotLoading = true;
            isSearching = false;
          });
        }
        if (state is Searching) {
          setState(() {
            isSearching = true;
          });
        }
      },
      builder: (context, state) => TawzeafScaffold(
          appBar: AppBar(
            backgroundColor: Colors.white12,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: CupertinoSearchTextField(
              placeholder: 'البحث عن وظيفة',
              controller: _searchController,
              style: const TextStyle(fontFamily: 'Cairo', color: Colors.black),
              onSuffixTap: () {
                _searchController.clear();
                setState(() {
                  isNotLoading = false;
                });
              },
              placeholderStyle: TextStyle(
                  fontFamily: 'Cairo', color: Colors.black.withOpacity(0.4)),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  if (!_searchResult.contains(value)) {
                    SearchBloc.get(context).searchHistory.add(value.trim());
                    CacheHelper.setStrings(
                        'searched', SearchBloc.get(context).searchHistory);
                  }
                  SearchBloc.get(context).getSearchedJob(value.trim());
                }
              },
            ),
          ),
          body: isNotLoading
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 12.0),
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return AllJobsBuilder(
                          jobDetailsUrl: SearchBloc.get(context)
                              .allJobs
                              .jobDetailsUrls[index]!,
                          jobImage:
                              SearchBloc.get(context).allJobs.images[index]!,
                          jobTitle:
                              SearchBloc.get(context).allJobs.titles![index],
                          jobType: index > 5
                              ? 'دوام كامل '
                              : SearchBloc.get(context).allJobs.jobType![index],
                          location: 'الرياض',
                          salary:
                              SearchBloc.get(context).allJobs.salary[index]!,
                          size: MediaQuery.of(context).size,
                          isSearch: true,
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                      itemCount:
                          SearchBloc.get(context).allJobs.titles!.length),
                )
              : isSearching
                  ? Center(
                      child: SpinKitThreeBounce(
                        color: Colors.green,
                        controller: _controller,
                        size: 30.0,
                      ),
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        if (index < _searchResult.length) {
                          return InkWell(
                            onTap: () {
                              _searchController.text = _searchResult[index];
                              SearchBloc.get(context)
                                  .getSearchedJob(_searchResult[index]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 80.0, vertical: 10),
                              child: Text(
                                _searchResult[index],
                                style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                            ),
                          );
                        } else {
                          if (_searchResult.isEmpty) {
                            return const SizedBox();
                          } else {
                            return TextButton(
                              onPressed: () {
                                setState(() {
                                  SearchBloc.get(context).searchHistory = [];
                                  _searchResult = [];
                                  CacheHelper.setStrings(
                                      'searched', _searchResult);
                                });
                              },
                              child: const Text(
                                'مسح تاريخ البحث',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            );
                          }
                        }
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: _searchResult.length + 1)),
    );
  }
}
