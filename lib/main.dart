import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/routes/app_pages.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      theme: ThemeData(fontFamily: GoogleFonts.poppins().fontFamily),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
