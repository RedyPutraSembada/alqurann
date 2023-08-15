import 'package:alqurann/app/constans/color.dart';
import 'package:alqurann/app/data/models/surah_detail.dart' as detail;
import 'package:alqurann/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../controllers/detail_surah_controller.dart';

class DetailSurahView extends GetView<DetailSurahController> {
  final homeC = Get.find<HomeController>();
  Map<String, dynamic>? bookmark;
  DetailSurahView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SURAH ${Get.arguments["name"].toString().toUpperCase()}'),
        centerTitle: true,
      ),
      body: FutureBuilder<detail.SurahDetail>(
        future: controller.getDetailSurah(Get.arguments["number"].toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text("Data Tidak Ditemukan"),
            );
          }

          if (Get.arguments["bookmark"] != null) {
            bookmark = Get.arguments["bookmark"];
            if (bookmark!["index_ayat"] > 0) {
              print("Index ayat: ${bookmark!["index_ayat"]}");
              print("Go to Index ayat: ${bookmark!["index_ayat"] + 2}");
              controller.scrollC.scrollToIndex(
                bookmark!["index_ayat"] + 2,
                preferPosition: AutoScrollPosition.begin,
              );
            }
          }
          print(bookmark);

          detail.SurahDetail surah = snapshot.data!;

          List<Widget> allAyat =
              List.generate(snapshot.data!.verses.length, (index) {
            detail.Verse ayat = snapshot.data!.verses[index];
            return AutoScrollTag(
              key: ValueKey(index + 2),
              controller: controller.scrollC,
              index: index + 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: appPurpleLight2.withOpacity(0.3)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(Get.isDarkMode
                                        ? "assets/images/oktagonal-white-transparant.png"
                                        : "assets/images/oktagonal.png"),
                                    fit: BoxFit.contain)),
                            child: Center(
                              child: Text("${index + 1}"),
                            ),
                          ),
                          GetBuilder<DetailSurahController>(
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
                                              await c.addBookmark(true,
                                                  snapshot.data!, ayat, index);
                                              homeC.update();
                                            },
                                            child: Text("LAST READ"),
                                            style: ElevatedButton.styleFrom(
                                              primary: appPurple,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              c.addBookmark(false,
                                                  snapshot.data!, ayat, index);
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
                                (ayat.kondisiAudio == "stop")
                                    ? IconButton(
                                        onPressed: () {
                                          c.playAudio(ayat);
                                        },
                                        icon: Icon(Icons.play_arrow),
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          (ayat.kondisiAudio == "playing")
                                              ? IconButton(
                                                  onPressed: () {
                                                    c.pauseAudio(ayat);
                                                  },
                                                  icon: Icon(Icons
                                                      .pause_circle_outline),
                                                )
                                              : IconButton(
                                                  onPressed: () {
                                                    c.resumeAudio(ayat);
                                                  },
                                                  icon: Icon(Icons
                                                      .play_arrow_outlined,
                                                ),
                                          IconButton(
                                            onPressed: () {
                                              c.stopAudio(ayat);
                                            },
                                            icon: Icon(
                                                Icons.stop_circle_outlined),
                                          ),
                                        ]
                                      ),
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
                    "${ayat.text.arab}",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${ayat.text.transliteration.en}",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${ayat.translation.id}",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            );
          });

          return ListView(
            controller: controller.scrollC,
            padding: EdgeInsets.all(20),
            children: [
              AutoScrollTag(
                key: ValueKey(0),
                controller: controller.scrollC,
                index: 0,
                child: GestureDetector(
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
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Tafsir Surah ${surah.tafsir.id}",
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  child: Container(
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
              ),
              AutoScrollTag(
                key: ValueKey(1),
                controller: controller.scrollC,
                index: 1,
                child: SizedBox(
                  height: 20,
                ),
              ),
              ...allAyat,

              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemCount: snapshot.data!.verses.length,
              //   itemBuilder: (context, index) {
              //     detail.Verse ayat = snapshot.data!.verses[index];
              //     return AutoScrollTag(
              //       key: ValueKey(index + 2),
              //       controller: controller.scrollC,
              //       index: index + 2,
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.stretch,
              //         children: [
              //           Container(
              //             decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(20),
              //                 color: appPurpleLight2.withOpacity(0.3)),
              //             child: Padding(
              //               padding: EdgeInsets.symmetric(
              //                   vertical: 5, horizontal: 10),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Container(
              //                     height: 40,
              //                     width: 40,
              //                     decoration: BoxDecoration(
              //                         image: DecorationImage(
              //                             image: AssetImage(Get.isDarkMode
              //                                 ? "assets/images/oktagonal-white-transparant.png"
              //                                 : "assets/images/oktagonal.png"),
              //                             fit: BoxFit.contain)),
              //                     child: Center(
              //                       child: Text("${index + 1}"),
              //                     ),
              //                   ),
              //                   GetBuilder<DetailSurahController>(
              //                     builder: (c) => Row(
              //                       children: [
              //                         IconButton(
              //                           onPressed: () {
              //                             Get.defaultDialog(
              //                                 title: "Bookmark",
              //                                 middleText:
              //                                     "Pilih jenis Bookmark",
              //                                 actions: [
              //                                   ElevatedButton(
              //                                     onPressed: () async {
              //                                       await c.addBookmark(
              //                                           true,
              //                                           snapshot.data!,
              //                                           ayat,
              //                                           index);
              //                                       homeC.update();
              //                                     },
              //                                     child: Text("LAST READ"),
              //                                     style:
              //                                         ElevatedButton.styleFrom(
              //                                       primary: appPurple,
              //                                     ),
              //                                   ),
              //                                   ElevatedButton(
              //                                     onPressed: () {
              //                                       c.addBookmark(
              //                                           false,
              //                                           snapshot.data!,
              //                                           ayat,
              //                                           index);
              //                                     },
              //                                     child: Text("BOOKMARK"),
              //                                     style:
              //                                         ElevatedButton.styleFrom(
              //                                       primary: appPurple,
              //                                     ),
              //                                   ),
              //                                 ]);
              //                           },
              //                           icon: Icon(Icons.bookmark_add_outlined),
              //                         ),
              //                         (ayat.kondisiAudio == "stop")
              //                             ? IconButton(
              //                                 onPressed: () {
              //                                   c.playAudio(ayat);
              //                                 },
              //                                 icon: Icon(Icons.play_arrow),
              //                               )
              //                             : Row(
              //                                 mainAxisSize: MainAxisSize.min,
              //                                 children: [
              //                                   (ayat.kondisiAudio == "playing")
              //                                       ? IconButton(
              //                                           onPressed: () {
              //                                             c.pauseAudio(ayat);
              //                                           },
              //                                           icon: Icon(Icons
              //                                               .pause_circle_outline),
              //                                         )
              //                                       : IconButton(
              //                                           onPressed: () {
              //                                             c.resumeAudio(ayat);
              //                                           },
              //                                           icon: Icon(Icons
              //                                               .play_arrow_outlined),
              //                                         ),
              //                                   IconButton(
              //                                     onPressed: () {
              //                                       c.stopAudio(ayat);
              //                                     },
              //                                     icon: Icon(Icons
              //                                         .stop_circle_outlined),
              //                                   ),
              //                                 ],
              //                               ),
              //                       ],
              //                     ),
              //                   )
              //                 ],
              //               ),
              //             ),
              //           ),
              //           SizedBox(
              //             height: 20,
              //           ),
              //           Text(
              //             "${ayat.text.arab}",
              //             textAlign: TextAlign.end,
              //             style: TextStyle(fontSize: 25),
              //           ),
              //           SizedBox(
              //             height: 10,
              //           ),
              //           Text(
              //             "${ayat.text.transliteration.en}",
              //             textAlign: TextAlign.end,
              //             style: TextStyle(
              //                 fontSize: 18, fontStyle: FontStyle.italic),
              //           ),
              //           SizedBox(
              //             height: 20,
              //           ),
              //           Text(
              //             "${ayat.translation.id}",
              //             textAlign: TextAlign.justify,
              //             style: TextStyle(fontSize: 18),
              //           ),
              //           SizedBox(
              //             height: 30,
              //           ),
              //         ],
              //       ),
              //     );
              //   },
              // ),
            ],
          );
        },
      ),
    );
  }
}
