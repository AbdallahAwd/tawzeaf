import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:tawzeaf/components/components.dart';
import 'package:tawzeaf/scraping/cat_bloc/category_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../scraping/home_bloc/web_scraping.dart';
import '../scraping/home_bloc/web_scraping_states.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.detailsUrl,
    this.jobType,
    this.isJob = true,
  }) : super(key: key);
  final String title;
  final String imageUrl;
  final String detailsUrl;
  final String? jobType;
  final bool isJob;
  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  bool isLoading = true;
  bool isLoadingDetails = true;
  List<EdgeInsets> padding = [
    const EdgeInsets.symmetric(horizontal: 8),
    const EdgeInsets.symmetric(horizontal: 18),
    const EdgeInsets.symmetric(horizontal: 28),
    const EdgeInsets.symmetric(horizontal: 20),
    const EdgeInsets.symmetric(horizontal: 35),
  ];
  @override
  void initState() {
    widget.isJob
        ? WbScarping.get(context).detailsScrapping(widget.detailsUrl)
        : CategoryBloc.get(context).blogDetails(widget.detailsUrl);
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoadingDetails = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WbScarping, WebScrapingStates>(
      listener: (context, state) {
        if (state is DetailsScrapingLoaded) {
          setState(() {
            isLoading = false;
          });
        }
      },
      builder: (context, state) => TawzeafScaffold(
        backColor: Colors.white,
        body: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Image.network(widget.imageUrl),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(widget.title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo'),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(thickness: 2),
            const SizedBox(
              height: 20,
            ),
            widget.isJob
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 15,
                            )
                          : Column(
                              children: <Widget>[
                                const Text('تفاصيل الوظيفة',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Cairo'),
                                    textAlign: TextAlign.center),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    detailsBuilder(
                                        icon: Icons.work,
                                        text: widget.jobType!),
                                    detailsBuilder(
                                        icon: Icons.location_on,
                                        text: WbScarping.get(context)
                                            .jobDetailsModel
                                            .jobLocation),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                const Divider(thickness: 1.5),
                                Html(
                                    data: WbScarping.get(context)
                                        .jobDetailsModel
                                        .jobInformation
                                        .join(' '),
                                    style: {
                                      '*': Style(
                                          fontFamily: 'Cairo',
                                          lineHeight: LineHeight.em(1.3),
                                          letterSpacing: 1.2,
                                          listStyleType: ListStyleType.NONE)
                                    }),
                              ],
                            ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 20,
            ),
            widget.isJob
                ? isLoading
                    ? ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: padding[index],
                            child: Container(
                              width: double.infinity,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        itemCount: padding.length,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Html(
                          data: WbScarping.get(context)
                              .jobDetailsModel
                              .article
                              .join(' ')
                              .replaceAll('تم وضع علامة باسم:', "")
                              .trim(),
                          style: {
                            'p': Style(
                              fontSize: const FontSize(16),
                              letterSpacing: 1.2,
                              fontFamily: 'Cairo',
                              lineHeight: LineHeight.number(1.2),
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            '*': Style(
                                fontFamily: 'Cairo',
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                border: Border.all(style: BorderStyle.none)),
                            'a': Style(
                              textDecoration: TextDecoration.none,
                            )
                          },
                          onLinkTap:
                              ((url, context, attributes, element) async {
                            if (await launchUrl(Uri.parse(url!))) {
                              throw 'Could not launch $url';
                            }
                          }),
                        ),
                      )
                : isLoadingDetails
                    ? const Center(child: CircularProgressIndicator())
                    : Html(
                        data: CategoryBloc.get(context).article.join(' '),
                        style: {
                          'p': Style(
                            fontSize: const FontSize(16),
                            letterSpacing: 1.2,
                            fontFamily: 'Cairo',
                            lineHeight: LineHeight.number(1.2),
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          '*': Style(
                              fontFamily: 'Cairo',
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              border: Border.all(style: BorderStyle.none)),
                          'a': Style(
                            textDecoration: TextDecoration.none,
                          )
                        },
                        onLinkTap: ((url, context, attributes, element) async {
                          if (await launchUrl(Uri.parse(url!))) {
                            throw 'Could not launch $url';
                          }
                        }),
                      ),
            widget.isJob
                ? isLoading
                    ? const SizedBox()
                    : WbScarping.get(context).jobDetailsModel.applyUrl == ''
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                                right: 20, left: 20, bottom: 20),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (await launchUrl(Uri.parse(
                                    WbScarping.get(context)
                                        .jobDetailsModel
                                        .applyUrl!))) {
                                  throw 'Could not launch ${WbScarping.get(context).jobDetailsModel.applyUrl}';
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: const Color(0xff1BBF73),
                                  minimumSize: const Size(double.infinity, 45),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25))),
                              child: const Text(
                                'التقديم',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Row detailsBuilder(
      {IconData? icon,
      required String text,
      String? alignText,
      bool isIcon = true}) {
    return Row(
      children: <Widget>[
        isIcon ? Icon(icon!) : Text(alignText!),
        const SizedBox(
          width: 8,
        ),
        SizedBox(
          width: 100,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 15),
          ),
        )
      ],
    );
  }
}
