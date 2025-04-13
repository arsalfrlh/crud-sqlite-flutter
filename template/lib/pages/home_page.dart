import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:templatesqlite/database/database_helper.dart';
import 'package:templatesqlite/models/barang.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:templatesqlite/pages/tambah_page.dart';
import 'package:templatesqlite/pages/update_page.dart';

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

  void _deleteBarang(int id)async{
    await databaseHelper.deleteBarang(id).then((_) {
      fetchBarang();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data barang dihapus'), backgroundColor: Colors.red,));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Daftar Barang"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => TambahPage())).then((_) => fetchBarang());
          }, icon: Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchBarang,
        child: isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: barangList.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.7,
              mainAxisSpacing: 20,
              crossAxisSpacing: 16,
            ),
            itemBuilder: (context, index) => ProductCard(
              barang: barangList[index],
              onPress: () {},
              onUpdate: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePage(barang: barangList[index]))).then((_) => fetchBarang());
              },
              onDelete: () => _deleteBarang(barangList[index].id!),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.barang,
    required this.onPress,
    required this.onUpdate,
    required this.onDelete,
  });

  final double width, aspectRetio;
  final Barang barang;
  final VoidCallback onPress;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.02,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF979797).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.file(File(barang.gambar)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              barang.namaBarang,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Stok: ${barang.stok}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF7643),
                  ),
                ),
                Row(
                  children: [
                    IconButton(onPressed: onUpdate, icon: Icon(Icons.edit)),
                    IconButton(onPressed: onDelete, icon: Icon(Icons.delete))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}