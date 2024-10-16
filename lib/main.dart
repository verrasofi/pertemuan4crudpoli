import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Poli {
  String id;
  String namaPoli;
  String deskripsiPoli;

  Poli({required this.id, required this.namaPoli, required this.deskripsiPoli});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Data Poli',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PoliPage(),
    );
  }
}

class PoliPage extends StatefulWidget {
  @override
  _PoliPageState createState() => _PoliPageState();
}

class _PoliPageState extends State<PoliPage> {
  final List<Poli> _poliList = [];
  final _namaPoliController = TextEditingController();
  final _deskripsiPoliController = TextEditingController();
  Poli? _editingPoli;

  @override
  void dispose() {
    _namaPoliController.dispose();
    _deskripsiPoliController.dispose();
    super.dispose();
  }

  // Function untuk menambah data Poli
  void _addPoli() {
    final String id = DateTime.now().millisecondsSinceEpoch.toString();
    final String namaPoli = _namaPoliController.text;
    final String deskripsiPoli = _deskripsiPoliController.text;

    if (namaPoli.isNotEmpty && deskripsiPoli.isNotEmpty) {
      setState(() {
        _poliList.add(
            Poli(id: id, namaPoli: namaPoli, deskripsiPoli: deskripsiPoli));
      });
      _clearInputFields();
    }
  }

  // Function untuk mengedit data Poli
  void _editPoli(Poli poli) {
    _namaPoliController.text = poli.namaPoli;
    _deskripsiPoliController.text = poli.deskripsiPoli;
    setState(() {
      _editingPoli = poli;
    });
  }

  // Function untuk menyimpan perubahan setelah edit
  void _updatePoli() {
    if (_editingPoli != null) {
      setState(() {
        _editingPoli!.namaPoli = _namaPoliController.text;
        _editingPoli!.deskripsiPoli = _deskripsiPoliController.text;
        _editingPoli = null;
      });
      _clearInputFields();
    }
  }

  // Function untuk menghapus data Poli dengan konfirmasi
  void _deletePoli(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus data ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _poliList.removeWhere((poli) => poli.id == id);
                });
                Navigator.of(context).pop(); // Tutup dialog setelah hapus
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // Membersihkan input setelah menambah/mengedit data
  void _clearInputFields() {
    _namaPoliController.clear();
    _deskripsiPoliController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD Data Poli'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaPoliController,
              decoration: InputDecoration(labelText: 'Nama Poli'),
            ),
            TextField(
              controller: _deskripsiPoliController,
              decoration: InputDecoration(labelText: 'Deskripsi Poli'),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _editingPoli == null ? _addPoli : _updatePoli,
                  child: Text(
                      _editingPoli == null ? 'Tambah Poli' : 'Update Poli'),
                ),
                SizedBox(width: 10),
                if (_editingPoli != null)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _editingPoli = null;
                        _clearInputFields();
                      });
                    },
                    child: Text('Batal'),
                  ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _poliList.length,
                itemBuilder: (context, index) {
                  final poli = _poliList[index];
                  return ListTile(
                    title: Text(poli.namaPoli),
                    subtitle: Text(poli.deskripsiPoli),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editPoli(poli),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deletePoli(poli.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
