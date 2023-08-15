import 'package:alqurann/app/constans/color.dart';
import 'package:alqurann/app/data/db/bookmark.dart';
import 'package:alqurann/app/data/models/surah.dart';
import 'package:alqurann/app/data/models/surah_detail.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sqflite/sqflite.dart';

class HomeController extends GetxController {
  late List<Surah> allSurah = [];
  RxBool isDark = false.obs;
  DatabaseManager database = DatabaseManager.instance;

  Future<Map<String, dynamic>?> getLastRead() async {
    Database db = await database.db;
    List<Map<String, dynamic>> lastRead =
        await db.query("bookmark", where: "last_read = 1");
    if (lastRead.length == 0) {
      return null;
    } else {
      return lastRead.first;
    }
  }

  void deleteBookmark(int id) async {
    Database db = await database.db;
    await db.delete("bookmark", where: "id = $id");
    update();
    Get.back();
    Get.snackbar("Berhasil Hapus Data", "Data berhasil dihapus",
        colorText: appWhite);
  }

  Future<List<Map<String, dynamic>>> getBookmark() async {
    Database db = await database.db;
    List<Map<String, dynamic>> allBookmark =
        await db.query("bookmark", where: "last_read = 0");
    return allBookmark;
  }

  void changeThemeMode() async {
    Get.isDarkMode ? Get.changeTheme(themeLight) : Get.changeTheme(themeDark);
    isDark.toggle();

    final box = GetStorage();

    if (Get.isDarkMode) {
      box.remove("themeDark");
    } else {
      box.write("themeDark", true);
    }
  }

  Future<List<Surah>> getAllSurah() async {
    Uri url = Uri.parse("https://my-repo-alquran.vercel.app/surah");
    var res = await http.get(url);

    List data = (json.decode(res.body) as Map<String, dynamic>)["data"];

    if (data == null || data.isEmpty) {
      return [];
    } else {
      allSurah = data.map((e) => Surah.fromJson(e)).toList();
      return allSurah;
    }
  }

  Future<List<Map<String, dynamic>>> getAllJuz() async {
    int juz = 1;

    List<Map<String, dynamic>> penampungAyat = [];
    List<Map<String, dynamic>> allJuz = [];

    for (var i = 1; i <= 114; i++) {
      var res = await http
          .get(Uri.parse("https://my-repo-alquran.vercel.app/surah/$i"));
      Map<String, dynamic> rawData = json.decode(res.body)["data"];
      SurahDetail data = SurahDetail.fromJson(rawData);
      if (data.verses != null) {
        data.verses.forEach((ayat) {
          if (ayat.meta.juz == juz) {
            penampungAyat.add({"surah": data, "ayat": ayat});
          } else {
            allJuz.add({
              "juz": juz,
              "start": penampungAyat[0],
              "end": penampungAyat[penampungAyat.length - 1],
              "verses": penampungAyat
            });
            juz++;
            penampungAyat = [];
            penampungAyat.add({"surah": data, "ayat": ayat});
          }
        });
      }
    }
    allJuz.add({
      "juz": juz,
      "start": penampungAyat[0],
      "end": penampungAyat[penampungAyat.length - 1],
      "verses": penampungAyat
    });

    return allJuz;
  }
}
