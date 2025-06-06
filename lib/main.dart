import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_sync/core/state/getx_controller.dart';
import 'package:gym_sync/frontend/pages/base_app_layout.dart';
import 'package:gym_sync/frontend/pages/enroll_edit_customer_page.dart';
import 'package:gym_sync/frontend/pages/start/personal_details_page.dart';
// import 'package:gym_sync/frontend/pages/start/login_page.dart';
import 'package:gym_sync/frontend/pages/start/splash_screen.dart';
// import 'package:gym_sync/frontend/pages/splash_screen.dart';

void main() async {
  await Get.putAsync(() async => CustomerController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My Gym',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff2C3639),
        primaryColor: Color(0xff3F4E4F),
        highlightColor: Color(0xffDCD7C9),

        fontFamily: "Nunito",
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/base', page: () => const BaseAppLayout()),
        GetPage(
          name: '/personalDetails',
          page: () => const PersonalDetailsPage(),
        ),
        GetPage(
          name: '/enrollEdit',
          page: () => const EnrollEditCustomerPage(),
        ),
      ],
      home: const SplashScreen(),
    );
  }
}
