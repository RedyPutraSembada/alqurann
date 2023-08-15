import 'package:alqurann/app/constans/color.dart';
import 'package:alqurann/app/data/models/surah_detail.dart' as detail;
import 'package:alqurann/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_juz_controller.dart';

class DetailJuzView extends GetView<DetailJuzController> {
  final homeC = Get.find<HomeController>();
  final Map<String, dynamic> dataMapPerJuz = Get.arguments;
  DetailJuzView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Juz ${dataMapPerJuz['juz']}"),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(20),
              itemCount: (dataMapPerJuz['verses'] as List).length,
              itemBuilder: (context, index) {
                if ((dataMapPerJuz['verses'] as List).length == 0) {
                  return Center(
                    child: Text("Tidak Ada Data."),
                  );
                }

                Map<String, dynamic> ayat = dataMapPerJuz['verses'][index];

                detail.Verse verse = ayat["ayat"];
                detail.SurahDetail surah = ayat["surah"];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (verse.number.inSurah == 1)
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => Get.dialog(
                              Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Get.isDarkMode
                                        ? appPurpleLight2.withOpacity(0.5)
                                        : appWhite,
                                  ),
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Tafsir Surah ${surah.name.transliteration.id}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Tafsir Surah ${surah.tafsir.id}",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            child: Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                    colors: [appPurpleLight2, appPurpleLight1]),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Text(
                                      "${surah.name.transliteration.id.toUpperCase()}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: appWhite),
                                    ),
                                    Text(
                                      "( ${surah.name.translation.id.toUpperCase()} )",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: appWhite),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${surah.numberOfVerses} Ayat | ${surah.revelation.id}",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                          color: appWhite),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: appPurpleLight2.withOpacity(0.3),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(Get.isDarkMode
                                              ? "assets/images/oktagonal-white-transparant.png"
                                              : "assets/images/oktagonal.png"),
                                          fit: BoxFit.contain)),
                                  child: Center(
                                    child: Text("${verse.number.inSurah}"),
                                  ),
                                ),
                                Text(
                                  "${surah.name.transliteration.id}",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 17),
                                ),
                              ],
                            ),
                            GetBuilder<DetailJuzController>(
                              builder: (c) => Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Get.defaultDialog(
                                          title: "Bookmark",
                                          middleText: "Pilih jenis Bookmark",
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                await c.addBookmark(
                                                    true, surah, verse, index);
                                                homeC.update();
                                              },
                                              child: Text("LAST READ"),
                                              style: ElevatedButton.styleFrom(
                                                primary: appPurple,
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                c.addBookmark(
                                                    false, surah, verse, index);
                                              },
                                              child: Text("BOOKMARK"),
                                              style: ElevatedButton.styleFrom(
                                                primary: appPurple,
                                              ),
                                            ),
                                          ]);
                                    },
                                    icon: Icon(Icons.bookmark_add_outlined),
                                  ),
                                  (verse.kondisiAudio == "stop")
                                      ? IconButton(
                                          onPressed: () {
                                            c.playAudio(verse);
                                          },
                                          icon: Icon(Icons.play_arrow),
                                        )
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            (verse.kondisiAudio == "playing")
                                                ? IconButton(
                                                    onPressed: () {
                                                      c.pauseAudio(verse);
                                                    },
                                                    icon: Icon(Icons
                                                        .pause_circle_outline),
                                                  )
                                                : IconButton(
                                                    onPressed: () {
                                                      c.resumeAudio(verse);
                                                    },
                                                    icon: Icon(Icons
                                                        .play_arrow_outlined),
                                                  ),
                                            IconButton(
                                              onPressed: () {
                                                c.stopAudio(verse);
                                              },
                                              icon: Icon(
                                                  Icons.stop_circle_outlined),
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
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${verse.text.arab}",
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${verse.text.transliteration.en}",
                      textAlign: TextAlign.end,
                      style:
                          TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${verse.translation.id}",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                );
              },
            ),
          ],
        ));
  }
}
