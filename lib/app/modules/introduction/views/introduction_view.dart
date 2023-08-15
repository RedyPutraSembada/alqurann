import 'package:alqurann/app/constans/color.dart';
import 'package:alqurann/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Al-Quran Apps",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Text(
                "Sesibuk itukah kamu sampai belum membaca al-quran ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: 70,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 300,
                width: 300,
                child: Lottie.asset("assets/lotties/animasi-quran.json"),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => Get.offAllNamed(Routes.HOME),
              child: Text(
                "GET STARTED",
                style:
                    TextStyle(color: Get.isDarkMode ? appPurpleDark : appWhite),
              ),
              style: ElevatedButton.styleFrom(
                primary: Get.isDarkMode ? appWhite : appPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
