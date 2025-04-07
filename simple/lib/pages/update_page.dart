import 'dart:io';

import 'package:crudsqlite/database/database_helper.dart';
import 'package:crudsqlite/models/barang.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdatePage extends StatefulWidget {
  Barang barang;
  UpdatePage({required this.barang});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  late TextEditingController nmBaraController;
  late TextEditingController hargaController;
  String? _gambar;

  @override
  void initState() {
    super.initState();
    nmBaraController = TextEditingController(text: widget.barang.namaBarang);
    hargaController = TextEditingController(text: widget.barang.harga.toString());
    _gambar = widget.barang.gambar;
  }

  Future<void> pilih() async {
    final _pilih = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_pilih != null) {
      setState(() {
        _gambar = _pilih.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Barang'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_gambar != null)
              Image.file(
                File(_gambar!),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ElevatedButton(onPressed: pilih, child: Text('Pilih Gambar')),
            TextField(
                controller: nmBaraController,
                decoration: InputDecoration(labelText: 'Nama Barang')),
            TextField(
                controller: hargaController,
                decoration: InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,),
            ElevatedButton(
                onPressed: () {
                  if (nmBaraController.text.isNotEmpty && int.parse(hargaController.text) > 0 && _gambar != null) {
                    final updateBarang = Barang(
                      id: widget.barang.id,
                      gambar: _gambar!,
                      namaBarang: nmBaraController.text,
                      harga: int.parse(hargaController.text),
                    );
                    databaseHelper.updateBarang(updateBarang, widget.barang.id!).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil mengupdate barang'), backgroundColor: Colors.green,));
                    });
                    Navigator.pop(context);
                  }else{
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mohon isi semua fieldnya'), backgroundColor: Colors.red,));
                  }
                },
                child: Text('Update'))
          ],
        ),
      ),
    );
  }
}
