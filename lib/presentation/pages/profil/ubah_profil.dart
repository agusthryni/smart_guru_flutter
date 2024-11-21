import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_guru/presentation/service/api_function.dart';
import 'package:smart_guru/presentation/service/snackbar.dart';
import 'package:smart_guru/presentation/widget/appbar.dart';
import '../../../config/theme/colors.dart';
import '../../widget/button.dart';
import '../../widget/textfield.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UbahProfilPage extends StatefulWidget {
  final Function()? onTap;
  const UbahProfilPage({super.key, required this.onTap});

  @override
  State<UbahProfilPage> createState() => _UbahProfilState();
}

class _UbahProfilState extends State<UbahProfilPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final telpController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setInitValue();
  }

  void setInitValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nameController.text = prefs.getString('name') ?? '';
    emailController.text = prefs.getString('email') ?? '';
    telpController.text = prefs.getString('telp') ?? '';
    addressController.text = prefs.getString('address') ?? '';
    setState(() {});
  }

  void edit(String nama, String email, String telp, String alamat) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (nameController.text == '' ||
        emailController.text == '' ||
        telpController.text == '' ||
        addressController.text == '') {
      showCustomSnackBar(context, 'Harap lengkapi semua data', false);
      return;
    }

    Map<String, dynamic> updateUserPut = await put(
        context,
        'http://${dotenv.env['API_URL']}/user/edit/${prefs.getString('id')}',
        10,
        <String, dynamic>{
          'name': nama,
          'email': email,
          'telp': telp,
          'address': alamat
        },
        'Gagal memperbarui akun.',
        'Berhasil memperbarui data akun!');

    if (updateUserPut.isNotEmpty && updateUserPut['statusCode'] == 200) {
      await prefs.setString('name', nama);
      await prefs.setString('email', email);
      await prefs.setString('telp', telp);
      await prefs.setString('address', alamat);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        appBar: const CustomAppBar(title: 'Ubah Profil', showLeading: true),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: 20),
                  // nama lengkap textfield
                  MyTextField(
                    controller: nameController,
                    hintText: 'Nama Lengkap',
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  // email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  // nomor telepon textfield
                  MyTextField(
                    controller: telpController,
                    hintText: 'No Telepon',
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  // alamat textfield
                  MyTextField(
                    controller: addressController,
                    hintText: 'Alamat',
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  // button simpan
                  MyButton(
                    text: 'Simpan',
                    onTap: () {
                      edit(
                        nameController.text,
                        emailController.text,
                        telpController.text,
                        addressController.text,
                      );
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
