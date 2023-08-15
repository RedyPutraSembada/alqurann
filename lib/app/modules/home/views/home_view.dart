import 'package:alqurann/app/constans/color.dart';
import 'package:alqurann/app/data/models/surah.dart';
import 'package:alqurann/app/data/models/surah_detail.dart' as detail;
import 'package:alqurann/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (Get.isDarkMode) {
      controller.isDark.value = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Al Quran Apps'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.SEARCH),
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: EdgeInsets.only(top: 25, left: 25, right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "َلسَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللهِ وَبَرَكَا تُهُ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              Text(
                "Halo teman-teman..",
                style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
              ),
              GetBuilder<HomeController>(
                builder: (c) => FutureBuilder<Map<String, dynamic>?>(
                  future: c.getLastRead(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: 150,
                        margin: EdgeInsets.symmetric(vertical: 25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                              colors: [appPurpleLight2, appPurpleLight1]),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: 45,
                              bottom: -34,
                              child: Opacity(
                                opacity: 0.6,
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  child: Lottie.asset(
                                    "assets/lotties/animasi-quran-home.json",
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.menu_book_outlined,
                                        color: appWhite,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Terakhir Dibaca",
                                        style: TextStyle(color: appWhite),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Loading....",
                                    style: TextStyle(
                                        color: appWhite, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    Map<String, dynamic>? lastRead = snapshot.data;
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 25),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                            colors: [appPurpleLight2, appPurpleLight1]),
                        color: Colors.amber,
                      ),
                      child: Material(
                        // borderRadius: BorderRadius.circular(15),
                        color: Colors.transparent,
                        child: InkWell(
                          onLongPress: () {
                            if (lastRead != null) {
                              Get.defaultDialog(
                                  title: "Hapus Data Terakhir Dibaca",
                                  middleText:
                                      "Apakah anda yakin menghapus data terakhir dibaca!",
                                  actions: [
                                    OutlinedButton(
                                        onPressed: () => Get.back(),
                                        child: Text("Batal")),
                                    ElevatedButton(
                                        onPressed: () {
                                          c.deleteBookmark(lastRead['id']);
                                        },
                                        child: Text("Delete"))
                                  ]);
                            }
                          },
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            if (lastRead != null) {
                              print(lastRead);
                            }
                          },
                          child: Container(
                            height: 150,
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 45,
                                  bottom: -34,
                                  child: Opacity(
                                    opacity: 0.6,
                                    child: Container(
                                      width: 200,
                                      height: 200,
                                      child: Lottie.asset(
                                        "assets/lotties/animasi-quran-home.json",
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.menu_book_outlined,
                                            color: appWhite,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Terakhir Dibaca",
                                            style: TextStyle(color: appWhite),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      if (lastRead != null)
                                        Text(
                                          lastRead == null
                                              ? ""
                                              : "${lastRead['surah'].toString().replaceAll("+", "'")}",
                                          style: TextStyle(
                                              color: appWhite, fontSize: 20),
                                        ),
                                      Text(
                                        lastRead == null
                                            ? "Belum ada data"
                                            : " Juz ${lastRead['juz']} | Ayat ${lastRead['ayat']}",
                                        style: TextStyle(
                                            color: appWhite, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              TabBar(
                tabs: [
                  Tab(
                    text: "Surah",
                  ),
                  Tab(
                    text: "Juz",
                  ),
                  Tab(
                    text: "Bookmark",
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    //* Surah
                    FutureBuilder<List<Surah>>(
                      future: controller.getAllSurah(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text("Data Tidak Ditemukan"),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Surah surah = snapshot.data![index];
                            return ListTile(
                              onTap: () =>
                                  Get.toNamed(Routes.DETAIL_SURAH, arguments: {
                                "name": surah.name.transliteration.id,
                                "number": surah.number,
                              }),
                              leading: Obx(
                                () => Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(controller.isDark.isTrue
                                          ? "assets/images/oktagonal-white-transparant.png"
                                          : "assets/images/oktagonal.png"),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text("${surah.number}"),
                                  ),
                                ),
                              ),
                              title: Text("${surah.name.transliteration.id}"),
                              subtitle: Text(
                                "${surah.numberOfVerses} Ayat | ${surah.revelation.id}",
                                style: TextStyle(color: Colors.grey),
                              ),
                              trailing: Text("${surah.name.short}"),
                            );
                          },
                        );
                      },
                    ),
                    //* Juz
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: controller.getAllJuz(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text("Data Tidak Ditemukan"),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> dataMapPerJuz =
                                snapshot.data![index];
                            return ListTile(
                              onTap: () => Get.toNamed(Routes.DETAIL_JUZ,
                                  arguments: dataMapPerJuz),
                              leading: Obx(
                                () => Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(controller.isDark.isTrue
                                          ? "assets/images/oktagonal-white-transparant.png"
                                          : "assets/images/oktagonal.png"),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${index + 1}",
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                "Juz ${index + 1}",
                              ),
                              isThreeLine: true,
                              subtitle: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Mulai dari ${(dataMapPerJuz['start']['surah'] as detail.SurahDetail).name.transliteration.id} ayat ${(dataMapPerJuz['start']['ayat'] as detail.Verse).number.inSurah}",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    "Sampai ${(dataMapPerJuz['end']['surah'] as detail.SurahDetail).name.transliteration.id} ayat ${(dataMapPerJuz['end']['ayat'] as detail.Verse).number.inSurah}",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    //* Bookmark
                    GetBuilder<HomeController>(
                      builder: (c) {
                        return FutureBuilder<List<Map<String, dynamic>>>(
                          future: c.getBookmark(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.data?.length == 0) {
                              return Center(
                                child: Text("Bookmark Tidak Tersedia"),
                              );
                            }

                            return ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> data =
                                    snapshot.data![index];
                                return ListTile(
                                  onTap: () => Get.toNamed(Routes.DETAIL_SURAH,
                                      arguments: {
                                        "name": data["surah"]
                                            .toString()
                                            .replaceAll("+", "'"),
                                        "number": data["number_surah"],
                                        "bookmark": data
                                      }),
                                  leading: Obx(
                                    () => Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(controller
                                                  .isDark.isTrue
                                              ? "assets/images/oktagonal-white-transparant.png"
                                              : "assets/images/oktagonal.png"),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text("${index + 1}"),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                      "${data['surah'].toString().replaceAll("+", "'")}"),
                                  subtitle: Text(
                                    "Ayat ${data['ayat']} - Via ${data['via']}",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      c.deleteBookmark(data['id']);
                                    },
                                    icon: Icon(
                                      Icons.delete_outlined,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => controller.changeThemeMode(),
          child: Obx(
            () => Icon(
              Icons.color_lens_outlined,
              color: controller.isDark.isTrue ? appPurpleDark : appWhite,
            ),
          )),
    );
  }
}
