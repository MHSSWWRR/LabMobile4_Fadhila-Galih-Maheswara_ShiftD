# LabMobile4_Fadhila-Galih-Maheswara_Shift-D

**Nama      :** Fadhila Galih Maheswara
**NIM       :** H1D022007
**Shift Lama:** D  
**Shift Baru:** D

## Penjelasan Kode

### 1. Proses Login

Pengguna dapat masuk dengan memasukkan username dan password. Jika belum memiliki akun, mereka dapat mengklik "Registrasi" untuk membuat akun baru. Setelah berhasil login, pengguna akan diarahkan ke halaman daftar produk.

```dart
// login_page.dart
void login() async {
  // ... (logika login)
}
```

### 2. Menambahkan Produk

Pada halaman daftar produk, pengguna dapat menambahkan produk baru dengan mengklik ikon "+" di pojok kanan atas. Ini akan membuka formulir di mana pengguna dapat memasukkan kode produk, nama, dan harga.

```dart
// produk_form.dart
simpan() {
  setState(() {
    _isLoading = true;
  });
  Produk createProduk = Produk(id: null);
  createProduk.kodeProduk = _kodeProdukTextboxController.text;
  createProduk.namaProduk = _namaProdukTextboxController.text;
  createProduk.hargaProduk = int.parse(_hargaProdukTextboxController.text);
  ProdukBloc.addProduk(produk: createProduk).then((value) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => const ProdukPage()));
  }, onError: (error) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const WarningDialog(
        description: "Simpan gagal, silahkan coba lagi",
      ));
  });
}
```

### 3. Menampilkan Data Produk

Daftar produk ditampilkan menggunakan widget FutureBuilder, yang mengambil data dari ProdukBloc.

```dart
// produk_page.dart
FutureBuilder<List>(
  future: ProdukBloc.getProduks(),
  builder: (context, snapshot) {
    if (snapshot.hasError) print(snapshot.error);
    return snapshot.hasData
      ? ListProduk(list: snapshot.data)
      : const Center(child: CircularProgressIndicator());
  },
)
```

### 4. Mengedit Produk

Pengguna dapat mengedit produk dengan mengklik produk tersebut dalam daftar, yang akan membuka halaman detail produk. Dari sana, mereka dapat mengklik "EDIT" untuk memodifikasi informasi produk.

```dart
// produk_form.dart
ubah() {
  setState(() {
    _isLoading = true;
  });
  Produk updateProduk = Produk(id: null);
  updateProduk.id = widget.produk!.id;
  updateProduk.kodeProduk = _kodeProdukTextboxController.text;
  updateProduk.namaProduk = _namaProdukTextboxController.text;
  updateProduk.hargaProduk = int.parse(_hargaProdukTextboxController.text);
  ProdukBloc.updateProduk(produk: updateProduk).then((value) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => const ProdukPage()));
  }, onError: (error) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const WarningDialog(
        description: "Permintaan ubah data gagal, silahkan coba lagi",
      ));
  });
}
```

### 5. Menghapus Produk

Untuk menghapus produk, pengguna dapat mengklik produk dalam daftar untuk membuka halaman detail, kemudian klik tombol "DELETE". Dialog konfirmasi akan muncul sebelum produk dihapus.

```dart
// produk_detail.dart
void confirmHapus() {
  // ... (logika konfirmasi hapus)
  AlertDialog alertDialog = AlertDialog(
    content: const Text("Yakin ingin menghapus data ini?"),
    actions: [
      OutlinedButton(
        child: const Text("Ya"),
        onPressed: () {
          ProdukBloc.deleteProduk(id: produkId)
            .then((deleted) {
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
            });
        },
      ),
      OutlinedButton(
        child: const Text("Batal"),
        onPressed: () => Navigator.pop(context),
      )
    ],
  );

  showDialog(builder: (context) => alertDialog, context: context);
}
```

### 6. Keluar (Logout)

Pengguna dapat keluar dengan membuka menu samping (geser dari kiri atau klik ikon menu) dan memilih opsi "Logout".

```dart
// produk_page.dart
Drawer(
  child: ListView(
    children: [
      ListTile(
        title: const Text('Logout'),
        trailing: const Icon(Icons.logout),
        onTap: () async {
          await LogoutBloc.logout().then((value) => {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage()))
          });
        },
      )
    ],
  ),
)
```
