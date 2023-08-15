import 'package:alqurann/app/constans/color.dart';
import 'package:alqurann/app/data/db/bookmark.dart';
import 'package:alqurann/app/data/models/surah_detail.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sqflite/sqflite.dart';

class DetailJuzController extends GetxController {
  int index = 0;
  final player = AudioPlayer();

  Verse? lastVerse;

  DatabaseManager database = DatabaseManager.instance;

  Future<void> addBookmark(
      bool lastRead, SurahDetail surah, Verse ayat, int index) async {
    Database db = await database.db;

    bool flagExist = false;

    if (lastRead == true) {
      await db.delete("bookmark", where: "last_read = 1");
    } else {
      List checkData = await db.query("bookmark",
          columns: [
            "surah",
            "number_surah",
            "ayat",
            "juz",
            "via",
            "index_ayat",
            "last_read"
          ],
          where:
              "surah = '${surah.name.transliteration.id.replaceAll("'", "+")}' and number_surah = ${surah.number} and ayat = ${ayat.number.inSurah} and juz = ${ayat.meta.juz} and via = 'juz' and index_ayat = $index and last_read = 0");
      if (checkData.length != 0) {
        flagExist = true;
      }
    }

    if (flagExist == false) {
      await db.insert("bookmark", {
        "surah": "${surah.name.transliteration.id.replaceAll("'", "+")}",
        "number_surah": surah.number,
        "ayat": ayat.number.inSurah,
        "juz": ayat.meta.juz,
        "via": "juz",
        "index_ayat": index,
        "last_read": lastRead == true ? 1 : 0
      });

      Get.back(); //* Menutup dialog
      Get.snackbar("Berhasil", "Berhasil menambahkan Bookmark",
          colorText: appWhite);
    } else {
      Get.back(); //* Menutup dialog
      Get.snackbar("Terjadi Kesalahan", "Bookmark telah tersedia",
          colorText: appWhite);
    }

    var data = await db.query("bookmark");
    print(data);
  }

  void playAudio(Verse ayat) async {
    if (ayat.audio.primary != null) {
      try {
        if (lastVerse == null) {
          lastVerse = ayat;
        }
        lastVerse!.kondisiAudio = "stop";
        lastVerse = ayat;
        lastVerse!.kondisiAudio = "stop";
        update();
        await player.stop();
        await player.setUrl(ayat.audio.primary);
        ayat.kondisiAudio = "playing";
        update();
        await player.play();
        ayat.kondisiAudio = "stop";
        update();
        await player.stop();
      } on PlayerException catch (e) {
        Get.defaultDialog(
            title: "Terjadi Kesalahan", middleText: e.message.toString());
      } on PlayerInterruptedException catch (e) {
        Get.defaultDialog(
            title: "Terjadi Kesalahan",
            middleText: "Connection aborted: ${e.message}");
      } catch (e) {
        Get.defaultDialog(
            title: "Terjadi Kesalahan", middleText: "An error occured: $e");
      }
    } else {
      Get.defaultDialog(
          title: "Terjadi Kesalahan", middleText: "Url Audio tidak valid.");
    }
  }

  void pauseAudio(Verse ayat) async {
    try {
      await player.pause();
      ayat.kondisiAudio = "pause";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan", middleText: e.message.toString());
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Connection aborted: ${e.message}");
    } catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan", middleText: "An error occured: $e");
    }
  }

  void resumeAudio(Verse ayat) async {
    try {
      ayat.kondisiAudio = "playing";
      update();
      await player.play();
      ayat.kondisiAudio = "stop";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan", middleText: e.message.toString());
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Connection aborted: ${e.message}");
    } catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan", middleText: "An error occured: $e");
    }
  }

  void stopAudio(Verse ayat) async {
    try {
      await player.stop();
      ayat.kondisiAudio = "stop";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan", middleText: e.message.toString());
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Connection aborted: ${e.message}");
    } catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan", middleText: "An error occured: $e");
    }
  }

  @override
  void onClose() {
    player.stop();
    player.dispose();
    super.onClose();
  }
}
