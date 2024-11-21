import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_guru/presentation/pages/exam/nilai.dart';
import 'package:smart_guru/presentation/service/api_function.dart';
import 'package:smart_guru/presentation/widget/appbar.dart';
import 'package:smart_guru/presentation/widget/listtile.dart';
import '../../../config/theme/colors.dart';
import '../../widget/button.dart';

class UlasanPage extends StatefulWidget {
  final Function()? onTap;
  final List<Map<String, dynamic>> questionsAndAnswers;
  final String idCourse;

  const UlasanPage(
      {super.key,
      required this.onTap,
      required this.questionsAndAnswers,
      required this.idCourse});

  @override
  State<UlasanPage> createState() => _UlasanPageState();
}

class _UlasanPageState extends State<UlasanPage> {
  bool isLoading = false;

  void _submit(
      String idCourse, List<Map<String, dynamic>> questionsAndAnswers) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> sendPost = await post(
        context,
        'http://${dotenv.env['API_URL']}/submit/${prefs.getString('id')}',
        10,
        <String, dynamic>{
          'id_course': idCourse,
          'answers': questionsAndAnswers
              .map((qa) => {
                    'id': qa['id'],
                    'answerId': qa['answerId'],
                  })
              .toList(),
        },
        "Gagal submit jawaban.",
        "Berhasil submit jawaban!");

    if (sendPost.isNotEmpty && sendPost['statusCode'] == 200) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              NilaiPage(onTap: () {}, idCourse: widget.idCourse)));
    }

    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: const CustomAppBar(
        title: 'Ulasan Jawaban',
      ),
      body: !isLoading
          ? SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ...widget.questionsAndAnswers
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> qa = entry.value;
                        return Column(
                          children: [
                            MyListTile(
                              title: qa['question'],
                              subtitle: qa['answer'] ?? "Belum dijawab",
                              leading: Text('${index + 1}'),
                              tileColor: const Color(0xFFEEF0FC),
                              shape: BorderRadius.circular(15.0),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                      const SizedBox(height: 15),
                      // button ubah jawaban
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MyButton(
                            text: 'Ubah Jawaban',
                            onTap: () {
                              Navigator.pop(context);
                            },
                            buttonColor: primaryColor,
                            textColor: secondaryColor,
                          ),
                          // button kirim
                          MyButton(
                            text: 'Kirim',
                            onTap: () {
                              _submit(
                                  widget.idCourse, widget.questionsAndAnswers);
                            },
                            buttonColor: primaryColor,
                            textColor: secondaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
            )),
    );
  }
}
