import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_guru/config/theme/colors.dart';
import 'package:smart_guru/presentation/pages/exam/ulasan.dart';
import 'package:smart_guru/presentation/service/api_function.dart';
import 'package:smart_guru/presentation/widget/button.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:smart_guru/presentation/service/alert_dialog.dart';

class QuestionPage extends StatefulWidget {
  final String idSoal;
  final Function()? onTap;
  const QuestionPage({super.key, required this.onTap, required this.idSoal});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final int jumlahSoal = 20;
  int _selectedIndex = -1;
  int selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  late Map<String, dynamic> courseDetail;
  List<Map<String, dynamic>> questions = [];
  List<Map<String, dynamic>> userAnswers = [];
  String courseTitle = "Loading...";
  bool isLoading = true;

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.position.pixels - 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.position.pixels + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void showExitConfirmationDialog(BuildContext context) {
    showConfirmationDialog(
      context: context,
      title: 'Konfirmasi Keluar',
      content: 'Yakin ingin kembali? Nilai 0',
      confirmText: 'Ya',
      cancelText: 'Tidak',
      onConfirm: () {
        Navigator.popUntil(context, ModalRoute.withName('/beranda'));
      },
      onCancel: () {},
    );
  }

  Future<void> getSoal(String idCourse) async {
    Map<String, dynamic> courseQuestion = await get(
        context,
        'https://${dotenv.env['API_URL']}/course/$idCourse',
        10,
        "Gagal memuat soal",
        "Berhasil memuat soal");
    Map<String, dynamic> courseDetail = await get(
        context,
        'https://${dotenv.env['API_URL']}/course/$idCourse/detail',
        10,
        "Gagal memuat soal",
        "Berhasil memuat soal",
        false);

    if (courseQuestion.isNotEmpty &&
        courseDetail.isNotEmpty &&
        courseQuestion['statusCode'] == 200 &&
        courseDetail['statusCode'] == 200) {
      setState(() {
        questions = List<Map<String, dynamic>>.from(courseQuestion['data']);
        courseTitle = courseDetail['data']['subject_topic'];
        userAnswers = questions.map((question) {
          return {
            'id': question['id'],
            'question': question['question'],
            'selectedIndex': -1,
            'answerId': null,
            'answer': null,
          };
        }).toList();
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSoal(widget.idSoal); // Fetch questions for course with idSoal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => showExitConfirmationDialog(context),
          child: const Icon(Icons.arrow_back),
        ),
        title: isLoading
            ? const Text(
                'Loading',
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            : Text(
                courseTitle,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(primaryColor)))
          : Column(
              children: [
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _scrollLeft,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: questions.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                  _selectedIndex = userAnswers[selectedIndex]
                                          ['selectedIndex'] ??
                                      -1;
                                });
                              },
                              child: Container(
                                width: 50,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: selectedIndex == index
                                      ? primaryColor
                                      : secondaryColor,
                                  shape: BoxShape.circle,
                                  border: selectedIndex == index
                                      ? null
                                      : Border.all(
                                          color: Colors.grey.shade800,
                                          width: 1.0,
                                        ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                        color: selectedIndex == index
                                            ? Colors.white
                                            : Colors.grey[800],
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: _scrollRight,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // pertanyaan
                if (selectedIndex != -1)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: TeXView(
                        child: TeXViewDocument(
                            (questions[selectedIndex]['question'] ?? '')
                                .replaceAll(r'\\', r'\')),
                      ),
                    ),
                  ),
                // pilihan ganda choicechip
                if (selectedIndex != -1)
                  Column(
                    children: List.generate(
                      questions[selectedIndex]['answers'].length,
                      (index) {
                        return ChoiceChip(
                          visualDensity:
                              const VisualDensity(horizontal: 4, vertical: 4),
                          showCheckmark: false,
                          label: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(
                                questions[selectedIndex]['answers'][index]
                                    ['content'],
                                softWrap: true,
                                maxLines: 3,
                              )
                              //     TeXView(
                              //   child: TeXViewDocument((questions[selectedIndex]
                              //           ['answers'][index]['content'])
                              //       .replaceAll(r'\\', r'\')),
                              // )
                              ),
                          selected: _selectedIndex == index,
                          backgroundColor: _selectedIndex == index
                              ? primaryColor
                              : secondaryColor,
                          selectedColor: primaryColor,
                          labelStyle: TextStyle(
                            fontSize: 16,
                            color: _selectedIndex == index
                                ? secondaryColor
                                : Colors.grey[800],
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              _selectedIndex = selected ? index : -1;
                              if (selected) {
                                // save user answer and selected index
                                userAnswers[selectedIndex] = {
                                  'id': questions[selectedIndex]['id'],
                                  'question': questions[selectedIndex]
                                      ['question'],
                                  'selectedIndex': index,
                                  'answerId': questions[selectedIndex]
                                      ['answers'][index]['id'],
                                  'answer': questions[selectedIndex]['answers']
                                      [index]['content'],
                                };
                              } else {
                                // remove the answer if unselected
                                userAnswers[selectedIndex] = {
                                  'id': questions[selectedIndex]['id'],
                                  'question': questions[selectedIndex]
                                      ['question'],
                                  'selectedIndex': -1,
                                  'answerId': null,
                                  'answer': null,
                                };
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                if (selectedIndex + 1 == questions.length)
                  MyButton(
                    text: 'Selesai',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UlasanPage(
                                onTap: () {},
                                questionsAndAnswers: userAnswers,
                                idCourse: widget.idSoal,
                              )));
                    },
                    buttonColor: primaryColor,
                    textColor: secondaryColor,
                  ),
              ],
            ),
    );
  }
}
