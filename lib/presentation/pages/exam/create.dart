import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_guru/presentation/pages/exam/list_materi.dart';
import 'package:smart_guru/presentation/pages/exam/soal.dart';
import 'package:smart_guru/presentation/service/api_function.dart';
import 'package:smart_guru/presentation/service/snackbar.dart';
import 'package:smart_guru/presentation/widget/appbar.dart';
import 'package:smart_guru/presentation/widget/dropdown.dart';
import '../../../config/theme/colors.dart';
import '../../widget/button.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CreatePage extends StatefulWidget {
  final Function()? onTap;
  const CreatePage({super.key, required this.onTap});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  String? selectedKelas;
  String? selectedMataPelajaran;
  String? selectedMateri;
  String? selectedSubMateri;
  String? selectedJumlahPertanyaan;
  String? selectedTipeJawaban;
  String selectedJumlahJawaban = "0";

  bool isLoading = false;

  List<String> materiDropdown = [];

  void generate(
      String grade,
      String subject,
      String subjectTopic,
      String? subSubjectTopic,
      String questionsTotal,
      String questionType,
      String choicesTotal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (questionType == 'Benar atau Salah') {
      choicesTotal = '2';
    }

    if ((selectedKelas == '' && selectedKelas != null) ||
        (selectedMataPelajaran == '' && selectedMataPelajaran != null) ||
        (selectedMateri == '' && selectedMateri != null) ||
        (selectedJumlahPertanyaan == '' && selectedJumlahPertanyaan != null) ||
        (selectedTipeJawaban == '' && selectedTipeJawaban != null) ||
        (selectedJumlahJawaban == '' && selectedJumlahJawaban != '0')) {
      showCustomSnackBar(context, 'Harap lengkapi semua data', false);
      return;
    }

    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> sendPost = await post(
        context,
        'http://${dotenv.env['API_URL']}/generate-course/${prefs.getString('id')}',
        10,
        <String, dynamic>{
          'grade': grade,
          'subject': subject,
          'subject_topic': subjectTopic,
          if (subSubjectTopic != null) 'sub_subject_topic': subSubjectTopic,
          'questions_total': questionsTotal,
          'question_type': questionType,
          'choices_total': choicesTotal
        },
        'Terjadi kesalahan pada server. Silakan coba lagi nanti',
        'Berhasil membuat soal!');

    if (sendPost.isNotEmpty && sendPost['statusCode'] == 200) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              QuestionPage(onTap: () {}, idSoal: '${sendPost['course_id']}')));
    }

    setState(() {
      isLoading = false;
    });
  }

  bool _showJumlahJawaban = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        appBar: const CustomAppBar(title: 'Buat Pertanyaan', showLeading: true),
        body: !isLoading
            ? SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // subtitle
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Text(
                              'Sesuaikan kebutuhaan uji pemahaman Anda disini',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // kelas dropdown
                        MyDropdown(
                          items: materiMaps.keys.toList(),
                          hintText: 'Kelas',
                          onChanged: (value) {
                            selectedKelas = null;
                            setState(() {
                              selectedKelas = value;
                              selectedMataPelajaran = null;
                              selectedMateri = null;
                              selectedSubMateri = null;
                              selectedJumlahPertanyaan = null;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        // mata pelajaran dropdown
                        MyDropdown(
                          initialValue: selectedMataPelajaran,
                          items: selectedKelas != null
                              ? (materiMaps[selectedKelas]
                                      as Map<String, dynamic>)
                                  .keys
                                  .toList()
                              : [],
                          hintText: 'Mata Pelajaran',
                          onChanged: (value) {
                            setState(() {
                              selectedMataPelajaran = value;
                              selectedMateri = null;
                              selectedSubMateri = null;
                              selectedJumlahPertanyaan = null;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        MyDropdown(
                          initialValue: selectedMateri,
                          items: selectedMataPelajaran != null
                              ? (materiMaps[selectedKelas]
                                          [selectedMataPelajaran]
                                      as Map<String, dynamic>)
                                  .keys
                                  .toList()
                              : [],
                          hintText: 'Materi',
                          onChanged: (value) {
                            setState(() {
                              selectedMateri = value;
                              selectedSubMateri = null;
                              selectedJumlahPertanyaan = null;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        // topic dropdown
                        MyDropdown(
                          initialValue: selectedSubMateri,
                          items: selectedMateri != null
                              ? (materiMaps[selectedKelas]
                                              [selectedMataPelajaran]
                                          [selectedMateri] ??
                                      <String>[])
                                  .toList()
                              : [],
                          hintText: 'Topik',
                          onChanged: (value) {
                            setState(() {
                              selectedSubMateri = value;
                              selectedJumlahPertanyaan = null;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        // jumlah pertanyaan dropdown
                        MyDropdown(
                          initialValue: selectedJumlahPertanyaan,
                          items: const ['5', '10', '15', '20'],
                          hintText: 'Jumlah Pertanyaan',
                          onChanged: (value) {
                            selectedJumlahPertanyaan = value;
                          },
                        ),
                        const SizedBox(height: 20),
                        // tipe jawaban dropdown
                        MyDropdown(
                          items: const ['Pilihan Ganda', 'Benar atau Salah'],
                          hintText: 'Tipe Jawaban',
                          onChanged: (value) {
                            setState(() {
                              selectedTipeJawaban = value;
                              _showJumlahJawaban = value == 'Pilihan Ganda';
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        // jumlah pilihan jawaban dropdown
                        if (_showJumlahJawaban)
                          MyDropdown(
                            items: const ['3', '4', '5'],
                            hintText: 'Jumlah Pilihan Jawaban',
                            onChanged: (value) {
                              selectedJumlahJawaban = value;
                            },
                          ),
                        const SizedBox(height: 20),
                        // button
                        MyButton(
                          text: 'Mulai',
                          onTap: () {
                            generate(
                                selectedKelas!,
                                selectedMataPelajaran!,
                                selectedMateri!,
                                selectedSubMateri,
                                selectedJumlahPertanyaan!,
                                selectedTipeJawaban!,
                                selectedJumlahJawaban);
                          },
                          buttonColor: primaryColor,
                          textColor: secondaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(primaryColor))));
  }
}
