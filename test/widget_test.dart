import 'dart:convert';

import 'package:alqurann/app/data/models/surah_detail.dart';
import 'package:http/http.dart' as http;

void main() async {
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
          penampungAyat
              .add({"surah": data.name.transliteration.id, "ayat": ayat});
        } else {
          allJuz.add({
            "juz": juz,
            "start": penampungAyat[0],
            "end": penampungAyat[penampungAyat.length - 1],
            "verses": penampungAyat
          });
          juz++;
          penampungAyat = [];
          penampungAyat
              .add({"surah": data.name.transliteration.id, "ayat": ayat});
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
}
