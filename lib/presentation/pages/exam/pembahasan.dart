import 'package:flutter/material.dart';
import 'package:smart_guru/presentation/service/api_function.dart';
import 'package:smart_guru/presentation/widget/appbar.dart';
import 'package:smart_guru/presentation/widget/listtile.dart';
import '../../../config/theme/colors.dart';
import '../../widget/button.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PembahasanPage extends StatefulWidget {
  final Function()? onTap;
  final String idCourse;
  const PembahasanPage(
      {super.key, required this.onTap, required this.idCourse});

  @override
  State<PembahasanPage> createState() => _PembahasanPageState();
}

class _PembahasanPageState extends State<PembahasanPage> {
  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getSoal(widget.idCourse);
  }

  Future<void> getSoal(String idCourse) async {
    Map<String, dynamic> courseQuestion = await get(
        context,
        'http://${dotenv.env['API_URL']}/course/$idCourse/review',
        10,
        "Gagal memuat soal",
        "Berhasil memuat soal",
        false);

    if (courseQuestion.isNotEmpty && courseQuestion['statusCode'] == 200) {
      setState(() {
        questions = List<Map<String, dynamic>>.from(courseQuestion['data']);
        isLoading = false;
      });
    }
  }

  String getResultText(Map<String, dynamic> question) {
    final userAnswer = question['userAnswer'];
    final correctAnswer = question['correctAnswer'];

    if (userAnswer == null || userAnswer['id_answer'] == null) {
      return 'Tidak dijawab\n\nJawaban benar: \n${correctAnswer != null ? correctAnswer['answer_content'] : 'Tidak tersedia'}';
    } else if (question['is_correct'] == 0) {
      return '${userAnswer['answer_content']}\n\nJawaban benar: \n${correctAnswer != null ? correctAnswer['answer_content'] : 'Tidak tersedia'}';
    } else {
      return userAnswer['answer_content'];
    }
  }

  String getCorrectnessText(Map<String, dynamic> question) {
    return question['is_correct'] == 1 ? 'Benar' : 'Salah';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: const CustomAppBar(
        title: 'Pembahasan',
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (var i = 0; i < questions.length; i++) ...[
                        MyListTile(
                          title: questions[i]['question'],
                          subtitle: "Jawaban :\n${getResultText(questions[i])}",
                          subtitle2: "\n${getCorrectnessText(questions[i])}",
                          leading: Text((i + 1).toString()),
                          tileColor: const Color(0xFFEEF0FC),
                          shape: BorderRadius.circular(15.0),
                          trailing: questions[i]['is_correct'] == 0
                              ? const Icon(Icons.error_outline,
                                  color: Colors.red)
                              : null,
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
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
}
