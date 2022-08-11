import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tawzeaf/views/search.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/components.dart';
import '../scraping/home_bloc/web_scraping.dart';
import '../scraping/home_bloc/web_scraping_states.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int currentIndex = 0;
  int page = 1;

  AnimationController? _controller;
  List<String> drawerNames = [
    'وظائف مدنية',
    'وظائف الشركات',
    'وظائف عسكرية',
    'وظائف للنساء',
    'وظائف عن بعد',
    'وظائف صحية',
    'وظائف حكومية',
    'وظائف تعليمية',
    'المقالات',
    'اتصل بنا',
  ];
  List<IconData> iconData = [
    Icons.business_center_sharp,
    Icons.business_sharp,
    Icons.account_balance_sharp,
    Icons.woman_outlined,
    Icons.social_distance,
    Icons.health_and_safety_outlined,
    Icons.temple_buddhist_sharp,
    Icons.computer,
    Icons.menu_book_rounded,
    Icons.call
  ];
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        log('execute');
        getMoreJobs();
      }
    });
  }

  getMoreJobs() async {
    page++;
    WbScarping.get(context).getAllJobs(page: page);
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? salary = WbScarping.get(context).allJobs.salary[0];

    final size = MediaQuery.of(context).size;
    return BlocConsumer<WbScarping, WebScrapingStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
              appBar: AppBar(
                title: InkWell(
                    onTap: () async {
                      if (!await launchUrl(Uri.parse('https://tawzeaf.com/'))) {
                        throw 'Could not launch https://tawzeaf.com/';
                      }
                    },
                    child: Image.asset('assets/images/logos.png')),
                centerTitle: true,
                leading: Builder(builder: (context) {
                  return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.green,
                      size: 35,
                    ),
                  );
                }),
                backgroundColor: const Color(0xffCEFFE9),
                elevation: 0,
              ),
              body: Builder(builder: (context) {
                return GestureDetector(
                  onPanStart: (details) {
                    if (details.localPosition.dx > size.width * 0.5) {
                      Scaffold.of(context).openDrawer();
                    }
                  },
                  child: ListView(
                    controller: _scrollController,
                    children: [
                      Container(
                        width: double.infinity,
                        height: size.height - 450,
                        decoration: const BoxDecoration(
                            color: Color(0xffCEFFE9),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.elliptical(250, 150))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: size.width - 50,
                              child: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    text: '',
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'موقع',
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: ' توظيف ',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff1BBF73),
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            'السعودية من اكبر منصات التوظيف في الوطن العربي',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Cairo',
                                        color: Colors.black),
                                  )),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: const Search(),
                                        alignment: Alignment.center,
                                        duration:
                                            const Duration(milliseconds: 100),
                                        reverseDuration:
                                            const Duration(milliseconds: 100),
                                        type: PageTransitionType.fade));
                              },
                              child: Container(
                                width: size.width - 50,
                                height: 60,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.search,
                                      color: Colors.grey[300],
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'ابحث عن وظيفه',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[400]),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text('احدث الوظائف',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[400])),
                      ),
                      SizedBox(
                        height: size.height - 650,
                        child: ListView.separated(
                          // shrinkWrap: true,
                          padding: const EdgeInsets.all(8),
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return newJobBuilder(
                              context,
                              size: size,
                              detailsUrl: WbScarping.get(context)
                                  .newJobs
                                  .jobDetails[index]!,
                              imageurl: WbScarping.get(context)
                                  .newJobs
                                  .imageurls[index],
                              title: WbScarping.get(context)
                                  .newJobs
                                  .titles![index],
                              jobType: WbScarping.get(context)
                                  .newJobs
                                  .jobTypes[index],
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemCount:
                              WbScarping.get(context).newJobs.titles!.length,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text('كل الوظائف',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[400])),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          currentIndex = index;
                          if (index <
                              WbScarping.get(context).allJobs.titles!.length) {
                            return AllJobsBuilder(
                              size: size,
                              location: index >= 90
                                  ? 'الرياض'
                                  : WbScarping.get(context)
                                      .allJobs
                                      .place[index],
                              jobDetailsUrl: WbScarping.get(context)
                                  .allJobs
                                  .jobDetailsUrls[index]!,
                              jobImage: WbScarping.get(context)
                                  .allJobs
                                  .images[index]!,
                              salary: index >= 10
                                  ? salary!
                                  : WbScarping.get(context)
                                      .allJobs
                                      .salary[index]!,
                              jobTitle: WbScarping.get(context)
                                  .allJobs
                                  .titles![index],
                              jobType: index >= 168
                                  ? 'دوام كامل'
                                  : WbScarping.get(context)
                                      .allJobs
                                      .jobType![index],
                            );
                          } else {
                            return Center(
                              child: SpinKitThreeBounce(
                                color: Colors.green,
                                controller: _controller,
                                size: 30.0,
                              ),
                            );
                          }
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 15),
                        itemCount:
                            WbScarping.get(context).allJobs.images.length + 1,
                      ),
                    ],
                  ),
                );
              }),
              drawer: drawer(context, list: drawerNames, icons: iconData)),
        );
      },
    );
  }
}
