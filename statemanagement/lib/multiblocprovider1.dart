import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//screen kedua
// Kelas ScreenDetil adalah halaman untuk menampilkan detail UMKM.
class ScreenDetil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detil'),
        ),
        body: BlocBuilder<DetilUmkmCubit, DetilUmkmModel>(
            builder: (context, detilUmkm) {
          return Column(children: [
            Text("Nama: ${detilUmkm.nama}"),
            Text("Detil: ${detilUmkm.jenis}"),
            Text("Member Sejak: ${detilUmkm.memberSejak}"),
            Text("Omzet per bulan: ${detilUmkm.omzet}"),
            Text("Lama usaha: ${detilUmkm.lamaUsaha}"),
            Text("Jumlah pinjaman sukses: ${detilUmkm.jumPinjamanSukses}"),
          ]);
        }));
  }
}

class DetilUmkmModel {
  // Deklarasi variabel
  String id;
  String jenis;
  String nama;
  String omzet;
  String lamaUsaha;
  String memberSejak;
  String jumPinjamanSukses;

  //lama_usaha":"1","member_sejak":"01-01-2019","jumlah_pinjaman_sukses":3}

  DetilUmkmModel(
      {required this.id,
      required this.nama,
      required this.jenis,
      required this.omzet,
      required this.jumPinjamanSukses,
      required this.lamaUsaha,
      required this.memberSejak}); //constructor
}

class Umkm {
  // Deklarasi variabel
  String id;
  String jenis;
  String nama;
  Umkm({required this.id, required this.nama, required this.jenis});//constructor
}

class UmkmModel {
  List<Umkm> dataUmkm;
  UmkmModel({required this.dataUmkm}); //constructor
}

class DetilUmkmCubit extends Cubit<DetilUmkmModel> {
  //String urlDetil = "http://127.0.0.1:8000/detil_umkm/";
  String urlDetil = "http://178.128.17.76:8000/detil_umkm/";
  DetilUmkmCubit()
      : super(DetilUmkmModel(
            id: '',
            jenis: '',
            nama: '',
            omzet: '',
            jumPinjamanSukses: '',
            lamaUsaha: '',
            memberSejak: ''));

  // Metode untuk mengatur nilai atribut dari data JSON
  void setFromJson(Map<String, dynamic> json) {
    // Memancarkan keadaan baru DetilUmkmModel dengan nilai atribut yang baru dari data JSON.
    emit(DetilUmkmModel(
        id: json["id"],
        nama: json["nama"],
        jenis: json["jenis"],
        omzet: json["omzet_bulan"],
        jumPinjamanSukses: json["jumlah_pinjaman_sukses"],
        lamaUsaha: json["lama_usaha"],
        memberSejak: json["member_sejak"]));
  }

  // Metode untuk mengambil data detail UMKM dari API berdasarkan ID.
  void fetchDataDetil(String id) async {
    // Mengonstruksi URL detail UMKM dengan menambahkan ID ke URL dasar.
    String urldet = "$urlDetil$id";
    final response = await http.get(Uri.parse(urldet));
     // Memeriksa apakah respons status code adalah 200 (berhasil).
    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

// Kelas UmkmCubit adalah sebuah Cubit yang mengelola keadaan UmkmModel.
class UmkmCubit extends Cubit<UmkmModel> {
  //String url = "http://127.0.0.1:8000/daftar_umkm";
  String url = "http://178.128.17.76:8000/daftar_umkm";

  // Konstruktor UmkmCubit yang menginisialisasi keadaan awal dengan data UMKM kosong.
  UmkmCubit() : super(UmkmModel(dataUmkm: []));

  // Metode untuk mengatur nilai atribut dari data JSON
  void setFromJson(Map<String, dynamic> json) {
    var arrData = json["data"];
    List<Umkm> arrOut = [];
    // Melakukan iterasi untuk setiap elemen data UMKM.
    for (var el in arrData) {
      String id = el['id'];
      String jenis = el['jenis'];
      String nama = el['nama'];
      arrOut.add(Umkm(id: id, nama: nama, jenis: jenis));
    }
    emit(UmkmModel(dataUmkm: arrOut));
  }

  void setFromJsonDetil(Map<String, dynamic> json) {}

  /// Metode untuk mengambil data UMKM dari API.
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

void main() {
  runApp(const MyApp());
}

// Kelas MyApp adalah kelas utama untuk aplikasi.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: MultiBlocProvider(
      // Menyediakan BlocProvider untuk UmkmCubit dan DetilUmkmCubit.
      providers: [
        BlocProvider<UmkmCubit>(
          create: (BuildContext context) => UmkmCubit(),
        ),
        BlocProvider<DetilUmkmCubit>(
          create: (BuildContext context) => DetilUmkmCubit(),
        ),
      ],
      child: const HalamanUtama(),
    ));
  }
}

// Kelas HalamanUtama adalah halaman utama dari aplikasi.
class HalamanUtama extends StatelessWidget {
  const HalamanUtama({Key? key}) : super(key: key);
  @override
  Widget build(Object context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text(' My App'),
      ),
      body: Center(
        child: BlocBuilder<UmkmCubit, UmkmModel>(
          builder: (context, listUmkm) {
            return Center(
                child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  Container(
                      padding: const EdgeInsets.all(10), child: const Text("""
nim1,nama1; nim2,nama2; Saya berjanji tidak akan berbuat curang data atau membantu orang lain berbuat curang""")),

                  Container(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<UmkmCubit>().fetchData();
                      },
                      child: const Text("Reload Daftar UMKM"),
                    ),
                  ),
                  //Text(listUmkm.dataUmkm[0].nama),
                  Expanded(child: BlocBuilder<DetilUmkmCubit, DetilUmkmModel>(
                      builder: (context, detilUmkm) {
                    return ListView.builder(
                        itemCount: listUmkm.dataUmkm.length, //jumlah baris
                        itemBuilder: (context, index) {
                          return ListTile(
                              onTap: () {
                                context.read<DetilUmkmCubit>().fetchDataDetil(
                                    listUmkm.dataUmkm[index].id);
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return ScreenDetil();
                                }));
                              },
                              leading: Image.network(
                                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                              trailing: const Icon(Icons.more_vert),
                              title: Text(listUmkm.dataUmkm[index].nama),
                              subtitle: Text(listUmkm.dataUmkm[index].jenis),
                              tileColor: Colors.white70);
                        });
                  }))
                ]));
          },
        ),
      ),
    ));
  }
}