import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawzeaf/scraping/home_bloc/web_scraping.dart';
import 'package:tawzeaf/scraping/home_bloc/web_scraping_states.dart';
import 'package:tawzeaf/scraping/search_bloc/search_bloc.dart';
import 'package:tawzeaf/shared/pref.dart';

import 'package:tawzeaf/splash/splash.dart';
import 'bloc_observer.dart';
import 'scraping/cat_bloc/category_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Color(0xffceffe9)));

  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WbScarping(),
        ),
        BlocProvider(
          create: (context) => CategoryBloc(),
        ),
        BlocProvider(
          create: (context) => SearchBloc(),
        )
      ],
      child: BlocConsumer<WbScarping, WebScrapingStates>(
        listener: (context, state) {},
        builder: (context, state) => MaterialApp(
          title: 'توظـيف',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: const Directionality(
              textDirection: TextDirection.rtl, child: Splash()),
        ),
      ),
    );
  }
}
