import 'package:flutter/material.dart';
import 'package:smart_guru/presentation/widget/listtile.dart';
import '../../../config/theme/colors.dart';
import '../../widget/button.dart';

class PembahasanPage extends StatefulWidget {
  final Function()? onTap;
  const PembahasanPage({super.key, required this.onTap});

  @override
  State<PembahasanPage> createState() => _PembahasanPageState();
}

class _PembahasanPageState extends State<PembahasanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: secondaryColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
          ],
          title: const Text(
            'Pembahasan',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // list pembahasan
                  MyListTile(
                    title: 'Jika sin θ = 0,8, berapakah nilai cos θ?',
                    subtitle: '0.6',
                    subtitle2: 'Benar',
                    leading: const Text('1'),
                    tileColor: const Color(0xFFEEF0FC),
                    shape: BorderRadius.circular(15.0),
                  ),
                  const SizedBox(height: 10),
                  MyListTile(
                    title:
                        'Diketahui sudut A pada segitiga ABC adalah 30 derajat. Jika panjang sisi AB = 8 cm dan BC = 4 cm, hitunglah panjang sisi AC!',
                    subtitle: '8 cm',
                    subtitle2: 'Benar',
                    leading: const Text('2'),
                    tileColor: const Color(0xFFEEF0FC),
                    shape: BorderRadius.circular(15.0),
                  ),
                  const SizedBox(height: 10),
                  MyListTile(
                    title: 'Jika tan α = 2, hitunglah nilai sin α.',
                    subtitle: '0.5',
                    subtitle2: 'Benar',
                    leading: const Text('3'),
                    tileColor: const Color(0xFFEEF0FC),
                    shape: BorderRadius.circular(15.0),
                  ),
                  const SizedBox(height: 10),
                  MyListTile(
                    title: 'Jika tan γ = 3, hitunglah nilai cos γ.',
                    subtitle: '0.2',
                    subtitle2: 'Benar',
                    leading: const Text('4'),
                    tileColor: const Color(0xFFEEF0FC),
                    shape: BorderRadius.circular(15.0),
                  ),
                  const SizedBox(height: 10),
                  MyListTile(
                    title:
                        'Sudut A dalam sebuah segitiga adalah 30 derajat dan sisi berhadapan adalah 8 cm. Berapakah panjang sisi lain yang berhadapan dengan sudut A jika segitiga tersebut adalah segitiga sama sisi?',
                    subtitle: '4 cm',
                    subtitle2: 'Benar',
                    leading: const Text('5'),
                    tileColor: const Color(0xFFEEF0FC),
                    shape: BorderRadius.circular(15.0),
                  ),
                  const SizedBox(height: 10),
                  MyListTile(
                    title:
                        'Diketahui sebuah segitiga siku-siku dengan panjang sisi-sisinya sebagai berikut: panjang sisi tegak 6 cm dan panjang sisi miring 10 cm. Berapakah nilai dari sinus sudut yang berhadapan dengan sisi tegak?',
                    subtitle: '',
                    subtitle2: 'Salah',
                    leading: const Text('6'),
                    trailing:
                        const Icon(Icons.error_outline, color: Colors.red),
                    tileColor: const Color(0xFFEEF0FC),
                    shape: BorderRadius.circular(15.0),
                  ),
                  const SizedBox(height: 10),
                  MyListTile(
                    title:
                        'Diketahui segitiga siku-siku dengan panjang sisi-sisinya adalah 3 cm, 4 cm, dan 5 cm. Berapakah nilai dari sin(α)?',
                    subtitle: '4/3',
                    subtitle2: 'Benar',
                    leading: const Text('7'),
                    tileColor: const Color(0xFFEEF0FC),
                    shape: BorderRadius.circular(15.0),
                  ),
                  const SizedBox(height: 10),
                  MyListTile(
                    title:
                        'Diketahui segitiga siku-siku dengan panjang sisi-sisinya adalah 3 cm, 4 cm, dan 5 cm. Berapakah nilai dari sin(α)?',
                    subtitle: '4/3',
                    subtitle2: 'Benar',
                    leading: const Text('8'),
                    tileColor: const Color(0xFFEEF0FC),
                    shape: BorderRadius.circular(15.0),
                  ),
                  const SizedBox(height: 20),
                  // button selesai
                  MyButton(
                    text: 'Selesai',
                    onTap: () {
                      Navigator.pushNamed(context, '/beranda');
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
