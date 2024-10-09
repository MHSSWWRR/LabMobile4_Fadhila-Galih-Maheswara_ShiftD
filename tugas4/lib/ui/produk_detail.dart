import 'package:flutter/material.dart';
import 'package:tugas4/bloc/produk_bloc.dart';
import 'package:tugas4/model/produk.dart';
import 'package:tugas4/ui/produk_form.dart';
import 'package:tugas4/ui/produk_page.dart';
import 'package:tugas4/widget/warning_dialog.dart';

class ProdukDetail extends StatefulWidget {
  Produk? produk;
  ProdukDetail({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Kode : ${widget.produk!.kodeProduk}",
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              "Nama : ${widget.produk!.namaProduk}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Harga : Rp. ${widget.produk!.hargaProduk.toString()}",
              style: const TextStyle(fontSize: 18.0),
            ),
            _tombolHapusEdit()
          ],
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        //Tombol Edit
        OutlinedButton(
          child: const Text("EDIT"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProdukForm(
                  produk: widget.produk!,
                ),
              ),
            );
          },
        ),
        //Tombol Hapus
        OutlinedButton(
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    // Konversi ID ke integer dengan penanganan error
    int? produkId;
    try {
      if (widget.produk?.id != null) {
        if (widget.produk!.id is int) {
          produkId = widget.produk!.id as int;
        } else if (widget.produk!.id is String) {
          produkId = int.tryParse(widget.produk!.id.toString());
        }
      }
    } catch (e) {
      print("Error parsing ID: $e");
    }

    if (produkId == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "ID produk tidak valid",
        ),
      );
      return;
    }

    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        //tombol hapus
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            ProdukBloc.deleteProduk(id: produkId).then((deleted) {
              if (deleted) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ProdukPage()));
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => const WarningDialog(
                          description: "Hapus gagal, silahkan coba lagi",
                        ));
              }
            }).catchError((error) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => const WarningDialog(
                        description: "Terjadi kesalahan, silahkan coba lagi",
                      ));
            });
          },
        ),
        //tombol batal
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }
}
