import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class ActivityModel {
  // Deklarasi variabel
  String aktivitas;
  String jenis;
  ActivityModel({required this.aktivitas, required this.jenis}); //constructor
}

// Kelas ActivityCubit adalah sebuah Cubit yang mengelola keadaan ActivityModel.
class ActivityCubit extends Cubit<ActivityModel> {
  String url = "https://www.boredapi.com/api/activity";
  ActivityCubit() : super(ActivityModel(aktivitas: "", jenis: ""));//constructor

  // Metode untuk mengatur nilai atribut dari data JSON
  void setFromJson(Map<String, dynamic> json) {
    String aktivitas = json['activity'];
    String jenis = json['type'];
    // Memancarkan keadaan baru ActivityModel dengan nilai atribut yang baru.
    emit(ActivityModel(aktivitas: aktivitas, jenis: jenis));
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

void main() => runApp(const MyApp());
// Kelas MyApp adalah kelas utama untuk aplikasi.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);//constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => ActivityCubit(),
        // Menjalankan HalamanUtama
        child: const HalamanUtama(),
      ),
    );
  }
}

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({Key? key}) : super(key: key);//constructor
  @override
  Widget build(Object context) {
    // Mengembalikan MaterialApp sebagai root widget halaman utama.
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Menggunakan BlocBuilder untuk membangun tampilan berdasarkan keadaan ActivityModel.
          BlocBuilder<ActivityCubit, ActivityModel>(
            // Menggunakan buildWhen untuk memeriksa apakah perlu merender ulang widget.
            buildWhen: (previousState, state) {
              developer.log("${previousState.aktivitas} -> ${state.aktivitas}",
                  name: 'logyudi');
              return true;
            },
            builder: (context, aktivitas) {
              return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<ActivityCubit>().fetchData();
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