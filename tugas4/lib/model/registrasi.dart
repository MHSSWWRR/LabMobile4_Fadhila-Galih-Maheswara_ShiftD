class Registrasi {
  int? code;
  bool? status;
  String? data;

  Registrasi({this.code, this.status, this.data});

  factory Registrasi.fromJson(Map obj) {
    return Registrasi(
        code: obj['code'],
        status: obj['status'],
        data: obj['data']
    );
  }
}