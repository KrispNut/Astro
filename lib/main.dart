import 'package:astro/core/theme/theme_service.dart';
import 'package:astro/features/splash/view.dart';
import 'package:astro/features/detail/view.dart';
import 'package:astro/features/home/view.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService.instance.init();
  ThemeService.instance.initializeStatusBar();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();

  void restartApp() {
    if (mounted) {
      setState(() {
        key = UniqueKey();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ThemeService.instance.addListener(restartApp);
  }

  @override
  void dispose() {
    ThemeService.instance.removeListener(restartApp);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: ChangeNotifierProvider.value(
        value: ThemeService.instance,
        child: Consumer<ThemeService>(
          builder: (context, themeService, child) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData.light().copyWith(
                primaryColor: const Color(0xFFFF9D6F),
                scaffoldBackgroundColor: const Color(0xFFF5F5F5),
                cardColor: Colors.white,
                textTheme: ThemeData.light().textTheme.apply(
                  fontFamily: 'NothingDotted',
                ),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFFF5F5F5),
                  foregroundColor: Color(0xFF333333),
                  elevation: 0,
                ),
              ),
              darkTheme: ThemeData.dark().copyWith(
                primaryColor: const Color(0xFFFF7D45),
                scaffoldBackgroundColor: const Color(0xFF121212),
                cardColor: const Color(0xFF1E1E1E),
                textTheme: ThemeData.dark().textTheme.apply(
                  fontFamily: 'NothingDotted',
                ),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFF121212),
                  elevation: 0,
                ),
              ),
              themeMode: themeService.themeMode,
              initialRoute: '/splash',
              getPages: [
                GetPage(name: '/splash', page: () => SplashView()),
                GetPage(name: '/home', page: () => HomeView()),
                GetPage(
                  name: '/detail/:title',
                  page: () => DetailView(title: Get.parameters['title']!),
                ),
                GetPage(
                  name: '/planets',
                  page: () => DetailView(title: 'Planets'),
                ),
                GetPage(name: '/stars', page: () => DetailView(title: 'Stars')),
                GetPage(
                  name: '/galaxies',
                  page: () => DetailView(title: 'Galaxies'),
                ),
                GetPage(
                  name: '/events',
                  page: () => DetailView(title: 'Events'),
                ),
                GetPage(
                  name: '/constellation/:name',
                  page: () => DetailView(title: Get.parameters['name']!),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
