library artha_template;

import 'package:artha_template/api_template.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

class Template {
  Color bgColor = const Color(0xfffafbfe);
  Color putih = Colors.white;
  Color hitam = Colors.black;
  Color merah = const Color(0xffc12e36);
  final double fixedWidth = 1024;
  Color biru = const Color(0xff1BA0E2);
  Color biruMuda = const Color(0xff2eb0cd);
  Color biruGelap = const Color(0xff0260c0);
  int miliseconds = 15000;

  TextStyle small(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!;
  }

  TextStyle medium(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!;
  }

  TextStyle large(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!;
  }

  late SharedPreferences logindata;

  void showLoadingDialog(BuildContext context, String? label) {
    Size size = MediaQuery.of(context).size;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            insetPadding: EdgeInsets.only(
                left: size.width * 0.35,
                right: size.width * 0.35,
                top: 10,
                bottom: 10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    width: size.width * 0.3,
                    height: size.height * 0.15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                            child: CupertinoActivityIndicator(
                          color: Colors.grey,
                        )),
                        Visibility(
                            visible: label != null,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "$label",
                                textAlign: TextAlign.center,
                              ),
                            ))
                      ],
                    )),
              ],
            ),
          );
        });
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(); // Close the dialog
  }

  Future<dynamic> apiCall<T>(
      String linkApi,
      String url,
      String? token,
      Map<String, dynamic>? body,
      T Function(Map<String, dynamic>) fromjson) async {
    var response = await fetchDataAndHandleError(
      http.Client(),
      linkApi,
      url,
      token,
      body: body,
      fromJson: (jsonData) {
        return fromjson(jsonData);
      },
    );

    return response;
  }

  Future<dynamic> apiCall2<T>(
      String linkApi,
      String url,
      String? token,
      Map<String, String>? body,
      Map<String, dynamic>? gambar,
      T Function(Map<String, dynamic>) fromjson) async {
    var response = await fetchDataAndHandleErrorGambar(
      http.Client(),
      linkApi,
      url,
      token,
      body: body,
      gambar: gambar,
      fromJson: (jsonData) {
        return fromjson(jsonData);
      },
    );

    return response;
  }

  Future<dynamic> apiCallGet<T>(String linkApi, String url, String? token,
      T Function(Map<String, dynamic>) fromjson) async {
    var response = await fetchDataAndHandleErrorGet(
      http.Client(),
      linkApi,
      url,
      token,
      fromJson: (jsonData) {
        return fromjson(jsonData);
      },
    );

    return response;
  }

  Future<String?> getString(String value) async {
    logindata = await SharedPreferences.getInstance();
    return logindata.getString(value);
  }

  Future clearAll() async {
    logindata = await SharedPreferences.getInstance();
    return logindata.clear();
  }

  Future<bool> setString(String nama, value) async {
    logindata = await SharedPreferences.getInstance();
    return logindata.setString(nama, value);
  }

  Future<bool> remove(String nama) async {
    logindata = await SharedPreferences.getInstance();
    return logindata.remove(nama);
  }

  Future<bool?> getBool(String value) async {
    logindata = await SharedPreferences.getInstance();
    return logindata.getBool(value);
  }

  Future<bool> setBool(String nama, bool value) async {
    logindata = await SharedPreferences.getInstance();
    return logindata.setBool(nama, value);
  }

  void topup(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) {
          return Dialog(
            insetPadding: const EdgeInsets.only(
                left: 100, right: 100, top: 10, bottom: 10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    width: 200,
                    height: 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "COMING SOON",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("OK"))
                      ],
                    )),
              ],
            ),
          );
        });
  }

  Widget textField(TextEditingController cont, TextInputType type, Widget? icon,
      bool obs, bool? isReadOnly, Function()? ontap) {
    return Align(
      alignment: Alignment.topLeft,
      child: TextFormField(
        style: const TextStyle(fontSize: 14),
        textAlign: TextAlign.start,
        controller: cont,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: type,
        obscureText: obs,
        readOnly: isReadOnly ?? false,
        onTap: ontap,

        //maxLines: null,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          suffixIcon: icon,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black26),
            borderRadius: BorderRadius.circular(4),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  void iosDialog(ctx, String pesan) {
    showCupertinoModalPopup<void>(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text(
          'Terjadi Kesalahan',
          style: TextStyle(color: Colors.red),
        ),
        content: Text(pesan),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void iosDialogKonfirmasi(ctx, Widget child, Function()? onsubmit) {
    showCupertinoModalPopup<void>(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Konfirmasi'),
        content: child,
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.

            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: onsubmit,
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String formatCurrency(double amount) {
    final currencyFormat = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);

    return currencyFormat.format(amount);
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi';
    }
    if (hour < 15) {
      return 'Selamat Siang';
    }
    if (hour < 18) {
      return 'Selamat Sore';
    }
    return 'Selamat Malam';
  }

  void showAlertDialog(context, String label) => showCupertinoDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(label == "location"
                ? "Permintaan Izin Lokasi"
                : "Permintaan Izin Kamera"),
            content: Text(label == "location"
                    ? "Jempolku membutuhkan akses lokasi untuk melakukan absensi"
                    : "Jempolku membutuhkan akses kamera untuk melakukan absensi"
                //"Allow access to $label"
                ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  // openAppSettings();
                },
                child: const Text("Settings"),
              )
            ],
          ));

  Future<DateTime?> pilihTanggal(BuildContext context, DateTime skrg) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: skrg,
        firstDate: DateTime(1810, 12),
        lastDate: DateTime(2101));
    if (picked != null && picked != skrg) {
      return picked;
    } else {
      return null;
    }
  }

  Future<String?> pilihJam(BuildContext context, TimeOfDay selectedTime) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );
    if (timeOfDay != null) {
      selectedTime = timeOfDay;
      var tampil = "${selectedTime.hour}:${selectedTime.minute}";
      return tampil;
    } else {
      return null;
    }
  }

  Widget tombolMasukPulang(String label, Color warna, BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: 40,
        width: size.width,
        decoration: BoxDecoration(
          color: warna,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_outlined,
              color: label == "Pulang Kerja" ? const Color(0xff2eb0cd) : putih,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              label,
              style: TextStyle(
                  color:
                      label == "Pulang Kerja" ? const Color(0xff2eb0cd) : putih,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  Widget gap() {
    return const SizedBox(
      height: 20,
    );
  }

  Widget halfGap() {
    return const SizedBox(
      height: 10,
    );
  }

  Future<void> requestPemission(List<String> giveAccess) async {
    final List<Permission> permissions = giveAccess.map((permission) {
      return Permission.values.firstWhere((permissionEnum) =>
          permissionEnum.toString().split('.')[1] == permission);
    }).toList();

    await Future.forEach(permissions, (permission) async {
      final PermissionStatus status = await permission.request();
      if (status == PermissionStatus.denied) {
        await requestPemission([permission.toString().split('.')[1]]);
      }
    });
  }
}
