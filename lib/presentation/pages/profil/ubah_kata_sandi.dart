import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_guru/presentation/service/api_function.dart';
import 'package:smart_guru/presentation/service/snackbar.dart';
import 'package:smart_guru/presentation/widget/appbar.dart';
import '../../../config/theme/colors.dart';
import '../../widget/button.dart';
import '../../widget/textfield.dart';

class UbahKataSandiPage extends StatefulWidget {
  final Function()? onTap;
  const UbahKataSandiPage({super.key, required this.onTap});

  @override
  State<UbahKataSandiPage> createState() => _UbahKataSandiPageState();
}

class _UbahKataSandiPageState extends State<UbahKataSandiPage> {
  final passwordController = TextEditingController();
  final newpasswordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  void updatePassword(String pass, String newPass, String confirmPass) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (passwordController.text == '' ||
        newpasswordController.text == '' ||
        confirmpasswordController.text == '') {
      showCustomSnackBar(context, 'Harap lengkapi semua data', false);
      return;
    }

    if (newpasswordController.text != confirmpasswordController.text) {
      showCustomSnackBar(
          context, 'Kata sandi dan konfirmasi kata sandi tidak sesuai', false);
      return;
    }

    if (passwordController.text == newpasswordController.text) {
      showCustomSnackBar(context,
          'Kata sandi baru tidak boleh sama dengan kata sandi lama', false);
      return;
    }

    Map<String, dynamic> changePasswordPut = await put(
        context,
        'http://${dotenv.env['API_URL']}/user/change_password/${prefs.getString('id')}',
        10,
        <String, dynamic>{
          'password': pass,
          'new_password': newPass,
          'verify_password': confirmPass,
        },
        'Gagal memperbarui kata sandi.',
        'Berhasil memperbarui kata sandi!');

    if (changePasswordPut.isNotEmpty &&
        changePasswordPut['statusCode'] == 200) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        appBar: const CustomAppBar(title: 'Ubah Kata Sandi', showLeading: true),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: 20),
                  // password saat ini textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Kata Sandi Saat Ini',
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  // password baru textfield
                  MyTextField(
                    controller: newpasswordController,
                    hintText: 'Kata Sandi Baru',
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  // konfirmasi password baru textfield
                  MyTextField(
                    controller: confirmpasswordController,
                    hintText: 'Konfirmasi Kata Sandi Baru',
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  // button simpan
                  MyButton(
                    text: 'Simpan',
                    onTap: () {
                      updatePassword(
                          passwordController.text,
                          newpasswordController.text,
                          confirmpasswordController.text);
                    },
                    buttonColor: primaryColor,
                    textColor: secondaryColor,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
