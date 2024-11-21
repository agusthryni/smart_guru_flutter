import 'package:flutter/material.dart';
import 'package:smart_guru/presentation/widget/textfield.dart';
import '../../../config/theme/colors.dart';

class AIChatPage extends StatefulWidget {
  final Function()? onTap;
  const AIChatPage({super.key, required this.onTap});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  // text editing controllers
  final chatController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        appBar: AppBar(
          backgroundColor: secondaryColor,
          elevation: 0,
          title: const Text(
            'Pesan Baru',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // teks
                    const Text('Tanya apapun, dapatkan jawabanmu disini!'),
                    // textfield
                    MyTextField(
                      controller: chatController,
                      hintText: '',
                      obscureText: false,
                    ),
                  ]),
            ),
          ),
        ));
  }
}
