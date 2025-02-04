import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

void main() { // Menjalankan aplikasi Flutter.
  runApp(
    ChangeNotifierProvider<ActivityModel>(
      create: (context) => ActivityModel(aktivitas: "-", jenis: "-"),
      child: const MyApp(),
    ),
  );
}

// menampung data hasil pemanggilan API

class ActivityModel extends ChangeNotifier {
  // URL endpoint API yang akan dipanggil untuk mendapatkan aktivitas.
  String url = "https://www.boredapi.com/api/activity";

  // Deklarasi variabel
  String aktivitas;
  String jenis;

  ActivityModel({required this.aktivitas, required this.jenis}); //constructor

  // Metode untuk mengatur nilai atribut dari data JSON.
  void setFromJson(Map<String, dynamic> json) {
    aktivitas = json['activity'];
    jenis = json['type'];
    notifyListeners(); //infokan bahwa data berubah
  }

  // Metode untuk mengambil data dari API dan mengatur nilai atribut aktivitas dan jenis.
  void fetchData() async {
    final response = await http.get(Uri.parse(url));
    // Memeriksa apakah respons status code adalah 200 (berhasil).
    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

// Kelas MyApp adalah kelas utama untuk aplikasi, yang merupakan turunan dari StatelessWidget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // Metode build untuk membangun tampilan aplikasi.
  Widget build(Object context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Consumer<ActivityModel>(
            builder: (context, aktivitas, child) {
              return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          //futureActivity = fetchData();
                          aktivitas.fetchData();
                        },
                        child: const Text("Saya bosan ..."),
                      ),
                    ),
                    Text(aktivitas.aktivitas),
                    Text("Jenis: ${aktivitas.jenis}")
                  ]));
            },
          ),
        ]),
      ),
    ));
  }
}