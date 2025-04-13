import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:templatesqlite/database/database_helper.dart';
import 'package:templatesqlite/models/barang.dart';

class TambahPage extends StatefulWidget {
  @override
  _TambahPageState createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  final nmBarangController = TextEditingController();
  final stokController = TextEditingController();
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
      appBar: AppBar(title: Text('Tambah Barang'), backgroundColor: Colors.blue,),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: constraints.maxHeight * 0.08),
              if(gambar != null)
              Image.file(File(gambar!),
              height: 100,
              width: 100,),
              ElevatedButton(onPressed: pilih, child: Text('Pili Gambar')),
              SizedBox(height: constraints.maxHeight * 0.05),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: nmBarangController,
                      decoration: const InputDecoration(
                        hintText: 'Nama Barang',
                        filled: true,
                        fillColor: Color(0xFFF5FCF9),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: stokController,
                      decoration: const InputDecoration(
                        hintText: 'Stok',
                        filled: true,
                        fillColor: Color(0xFFF5FCF9),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (nmBarangController.text.isNotEmpty && stokController.text.toString().isNotEmpty && gambar != null){
                            final newBarang = Barang(
                              gambar: gambar!,
                              namaBarang: nmBarangController.text,
                              stok: int.parse(stokController.text),
                            );

                            databaseHelper.addBarang(newBarang).then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil menambahkan barang'), backgroundColor: Colors.green,));
                            });
                            Navigator.pop(context);
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mohon isi semua fieldnya'), backgroundColor: Colors.red,));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xFF00BF6D),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text("Tambah"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
