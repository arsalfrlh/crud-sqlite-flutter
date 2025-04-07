import 'dart:io';

import 'package:crudsqlite/database/database_helper.dart';
import 'package:crudsqlite/models/barang.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TambahPage extends StatefulWidget {
  @override
  _TambahPageState createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  final nmBarangController = TextEditingController();
  final hargaController = TextEditingController();
  String? gambar;

  Future<void> pilih() async {
    final _pilih = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_pilih != null) {
      setState(() {
        gambar = _pilih.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Barang'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (gambar != null)
              Image.file(
                File(gambar!),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ElevatedButton(
              onPressed: pilih,
              child: Text('Pilih Gambar'),
            ),
            TextField(
                controller: nmBarangController,
                decoration: InputDecoration(labelText: 'Nama Barang')),
            TextField(
                controller: hargaController,
                decoration: InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,),
            ElevatedButton(
                onPressed: () {
                  if (nmBarangController.text.isNotEmpty && int.parse(hargaController.text) > 0 && gambar != null) {
                    final newBarang = Barang(
                      gambar: gambar!,
                      namaBarang: nmBarangController.text,
                      harga: int.parse(hargaController.text),
                    );
                    databaseHelper.addBarang(newBarang).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil menambahkan barang'), backgroundColor: Colors.green,));
                    });
                    Navigator.pop(context);
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mohon isi semua fieldnya'), backgroundColor: Colors.red,));
                  }
                },
                child: Text('Simpan'))
          ],
        ),
      ),
    );
  }
}
