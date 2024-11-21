import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_guru/presentation/service/api_function.dart';
import 'package:smart_guru/presentation/service/snackbar.dart';
import 'package:smart_guru/presentation/widget/appbar.dart';
import '../../../config/theme/colors.dart';
import '../../widget/button.dart';
import '../../widget/textfield.dart';

class HubungiKamiPage extends StatefulWidget {
  final Function()? onTap;
  const HubungiKamiPage({super.key, required this.onTap});

  @override
  State<HubungiKamiPage> createState() => _HubungiKamiPageState();
}

class _HubungiKamiPageState extends State<HubungiKamiPage> {
  final emailController = TextEditingController();
  final problemController = TextEditingController();
  final messageController = TextEditingController();

  void contactus(String email, String problem, String message) async {
    if (emailController.text == '' ||
        problemController.text == '' ||
        messageController.text == '') {
      showCustomSnackBar(context, 'Harap lengkapi semua data', false);
      return;
    }

    Map<String, dynamic> sendPost = await post(
        context,
        'http://${dotenv.env['API_URL']}/user/contact_us',
        10,
        <String, dynamic>{
          'email': email,
          'problem': problem,
          'message': message
        },
        "Gagal mengirim pesan.",
        "Berhasil mengirim pesan!");

    if (sendPost.isNotEmpty && sendPost['statusCode'] == 200) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        appBar: const CustomAppBar(title: 'Hubungi Kami', showLeading: true),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // image
                  Image.asset(
                    'assets/images/contact_us.png',
                    width: 200,
                    height: 200,
                  ),
                  // subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      'Silakan isi formulir dibawah ini untuk menghubungi kami. Kami akan menghubungi Anda sesegera mungkin',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  // masalah textfield
                  MyTextField(
                    controller: problemController,
                    hintText: 'Masalah',
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  // pesan textfield
                  MyTextField(
                    controller: messageController,
                    hintText: 'Pesan',
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  // button
                  MyButton(
                    text: 'Simpan',
                    onTap: () {
                      contactus(emailController.text, problemController.text,
                          messageController.text);
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
