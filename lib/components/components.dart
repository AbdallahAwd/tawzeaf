import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ads/apply_ad.dart';
import '../ads/banner.dart';
import '../views/category_jobs.dart';
import '../views/job_details.dart';

Row shimmerEffect(Size size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        width: size.width - 220,
        height: 190,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              blurStyle: BlurStyle.outer,
              color: Colors.grey,
              offset: Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 120,
              height: 120,
              color: Colors.grey[300],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 120,
              height: 10,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20)),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: 120,
              height: 10,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20)),
            ),
          ],
        ),
      )
    ],
  );
}

Widget drawer(context,
        {required List<String> list, required List<IconData> icons}) =>
    Directionality(
      textDirection: TextDirection.rtl,
      child: Drawer(
        child: DrawerHeader(
          decoration: const BoxDecoration(
            color: Color(0xffceffe9),
          ),
          child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    list[index],
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
                  ),
                  leading: Icon(icons[index]),
                  onTap: () async {
                    Navigator.pop(context);
                    if (index == 9) {
                      if (!await launchUrl(
                          Uri.parse('https://tawzeaf.com/contact'))) {
                        throw 'Could not launch ';
                      }
                    } else {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: CategoryJobs(
                                jobCategory: list[index],
                                index: index,
                              ),
                              type: PageTransitionType.leftToRight));
                    }
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: list.length),
        ),
      ),
    );
Widget newJobBuilder(
  context, {
  required Size size,
  String? imageurl,
  required String title,
  String? jobType,
  required String detailsUrl,
}) {
  return InkWell(
    onTap: () {
      ApplyAd.loadDoneAd();
      Navigator.push(
          context,
          PageTransition(
              child: JobDetails(
                title: title,
                imageUrl: imageurl!,
                detailsUrl: detailsUrl,
                jobType: jobType!,
              ),
              type: PageTransitionType.bottomToTop));
    },
    child: Stack(
      children: [
        Container(
          width: size.width - 220,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                blurStyle: BlurStyle.outer,
                color: Colors.grey,
                offset: Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Image.network(
                  imageurl!,
                  height: 100,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 50,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
              color: Color(0xffCEFFE9),
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                  topRight: Radius.circular(8)),
            ),
            child: Text(jobType!),
          ),
        ),
      ],
    ),
  );
}

class AllJobsBuilder extends StatelessWidget {
  const AllJobsBuilder({
    Key? key,
    required this.size,
    required this.jobTitle,
    required this.jobType,
    required this.index,
    this.isSearch = false,
    required this.jobImage,
    required this.jobDetailsUrl,
    required this.location,
    required this.salary,
  }) : super(key: key);

  final Size size;
  final String jobTitle;
  final String jobType;
  final String jobImage;
  final String location;
  final String salary;
  final bool isSearch;
  final int index;
  final String jobDetailsUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ApplyAd.loadDoneAd();
        Navigator.push(
            context,
            PageTransition(
                child: JobDetails(
                  title: jobTitle,
                  imageUrl: jobImage,
                  detailsUrl: jobDetailsUrl,
                  jobType: jobType,
                ),
                type: PageTransitionType.leftToRight));
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    blurStyle: BlurStyle.outer,
                    color: Colors.grey,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.network(
                        jobImage,
                        width: 100,
                        height: 50,
                        errorBuilder: ((context, error, stackTrace) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(
                              Icons.error,
                              size: 50,
                            ),
                          );
                        }),
                      ),
                      SizedBox(
                        width: size.width - 150,
                        child: Text(
                          jobTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      children: <Widget>[
                        const Text(
                          "الموقع :",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        Text(
                          location,
                          style: const TextStyle(fontFamily: 'Cairo'),
                        )
                      ],
                    ),
                  ),
                  isSearch
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Row(
                            children: <Widget>[
                              const Text(
                                "الراتب :",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                width: 35,
                              ),
                              Text(
                                salary,
                                style: const TextStyle(fontFamily: 'Cairo'),
                              )
                            ],
                          ),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xff1BBF73),
                            minimumSize: const Size(100, 30),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              bottomRight: Radius.zero,
                              topRight: Radius.zero,
                              bottomLeft: Radius.circular(12),
                              topLeft: Radius.circular(12),
                            ))),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return JobDetails(
                              title: jobTitle,
                              imageUrl: jobImage,
                              detailsUrl: jobDetailsUrl,
                              jobType: jobType,
                            );
                          }));
                        },
                        child: const Text('التفاصيل'),
                      ),
                      Container(
                        width: 70,
                        height: 20,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(12),
                              topRight: Radius.circular(12)),
                          color: Color(0xffCEFFE9),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            jobType,
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          index % 5 == 0
              ? const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: RectBannerAd(),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class TawzeafScaffold extends StatelessWidget {
  final AppBar? appBar;
  final Widget body;
  final Widget? drawer;
  final Widget? navigate;

  final Color? backColor;

  const TawzeafScaffold({
    Key? key,
    this.appBar,
    required this.body,
    this.drawer,
    this.backColor,
    this.navigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backColor,
        bottomNavigationBar: navigate,
        appBar: appBar,
        body: body,
        drawer: drawer,
      ),
    );
  }
}
