import 'dart:io'; //import File
import 'package:crudsqlite/database/database_helper.dart';
import 'package:crudsqlite/pages/tambah_page.dart';
import 'package:crudsqlite/pages/update_page.dart';
import 'package:flutter/material.dart';
import 'package:crudsqlite/models/barang.dart';

//tambahkan <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/> di "android/app/src/main/AndroidManifest.xml" utk mengijikan menyimpan di local storage
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Barang> barangList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBarang();
  }

  Future<void> fetchBarang() async {
    setState(() {
      isLoading = true;
    });
    barangList = await databaseHelper.getBarang();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Barang'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TambahPage())).then((_) => fetchBarang());
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchBarang,
        child: isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
          itemCount: barangList.length,
          itemBuilder: (context, index) {
            final barang = barangList[index];
            return ListTile(
              leading: Image.file(
                File(barang.gambar),
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
              title: Text('Nama Barang: ${barang.namaBarang}'),
              subtitle: Text('Harga ${barang.harga}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePage(barang: barang))).then((_) => fetchBarang());
                    }, 
                    icon: Icon(Icons.edit)),
                  IconButton(
                      onPressed: () async {
                        await databaseHelper.deleteBarang(barang.id!).then((_) {
                          fetchBarang();
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Barang berhasil di hapus'), backgroundColor: Colors.red,));
                        });
                      },
                      icon: Icon(Icons.delete))
                ],
              ),
            );
          }),
      )
    );
  }
}
