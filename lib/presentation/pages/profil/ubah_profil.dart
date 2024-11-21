import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../../widget/button.dart';
import '../../widget/textfield.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        appBar: AppBar(
            backgroundColor: secondaryColor,
            elevation: 0,
            leading: GestureDetector(
                child: const Icon(Icons.arrow_back),
                onTap: () {
                  Navigator.pop(context);
                }),
            title: const Text(
              'Ubah Profil',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
            centerTitle: true),
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
                    onTap: () {},
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
