import 'package:flutter/material.dart';
import 'package:smart_guru/config/theme/colors.dart';
import 'package:smart_guru/presentation/widget/button.dart';

class HasilPengerjaanPage extends StatefulWidget {
  final Function()? onTap;
  const HasilPengerjaanPage({super.key, required this.onTap});

  @override
  State<HasilPengerjaanPage> createState() => _HasilPengerjaanPageState();
}

class _HasilPengerjaanPageState extends State<HasilPengerjaanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
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
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // banner congrats
                Container(
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          // image slape
                          Image.asset(
                            'assets/images/faq.png',
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // subtitle
                          const Text(
                            'Kamu mendapat nilai 80',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // button lihat pembahasan
                          MyButton(
                            text: 'Lihat Pembahasan',
                            onTap: () {
                              Navigator.pushNamed(context, '/pembahasan');
                            },
                            buttonColor: secondaryColor,
                            textColor: primaryColor,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard(title: 'Jumlah Soal', value: '20'),
                    _buildStatCard(title: 'Jawaban Kosong', value: '1'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard(title: 'Jumlah Benar', value: '18'),
                    _buildStatCard(title: 'Jawaban Salah', value: '1'),
                  ],
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
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value}) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(fontSize: 20)),
      ],
    );
  }
}
