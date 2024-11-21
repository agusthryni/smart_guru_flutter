import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_guru/config/theme/colors.dart';
import 'package:smart_guru/presentation/pages/exam/pembahasan.dart';
import 'package:smart_guru/presentation/service/api_function.dart';
import 'package:smart_guru/presentation/widget/appbar.dart';
import 'package:smart_guru/presentation/widget/button.dart';

class NilaiPage extends StatefulWidget {
  final Function()? onTap;
  final String idCourse;
  const NilaiPage({super.key, required this.onTap, required this.idCourse});

  @override
  State<NilaiPage> createState() => _NilaiPageState();
}

class _NilaiPageState extends State<NilaiPage> {
  int score = 0;
  int totalQuestion = 0;
  int totalCorrect = 0;
  int totalWrong = 0;
  int totalNull = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getStats(widget.idCourse);
  }

  Future<void> getStats(String idCourse) async {
    Map<String, dynamic> statsGet = await get(
        context,
        'https://${dotenv.env['API_URL']}/course/$idCourse/stats',
        10,
        "",
        "",
        false);

    if (statsGet.isNotEmpty && statsGet['statusCode'] == 200) {
      score = statsGet['score'];
      totalQuestion = statsGet['total_questions'];
      totalCorrect = statsGet['total_correct'];
      totalWrong = statsGet['total_wrong'];
      totalNull = statsGet['total_not_answered'];
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: const CustomAppBar(
        title: 'Nilai',
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(primaryColor)))
          : SafeArea(
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
                                  'assets/images/slap.png',
                                  width: 100,
                                  height: 100,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                // subtitle
                                Text(
                                  'Kamu mendapat nilai $score', // Add score here
                                  style: const TextStyle(
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
                                    // print(widget.idCourse);
                                    // Navigator.pushNamed(context, '/pembahasan');
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PembahasanPage(
                                                    onTap: () {},
                                                    idCourse:
                                                        widget.idCourse)));
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
                          _buildStatCard(
                              title: 'Jumlah Soal', value: '$totalQuestion'),
                          _buildStatCard(
                              title: 'Jawaban Kosong', value: '$totalNull'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard(
                              title: 'Jawaban Benar', value: '$totalCorrect'),
                          _buildStatCard(
                              title: 'Jawaban Salah', value: '$totalWrong'),
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
