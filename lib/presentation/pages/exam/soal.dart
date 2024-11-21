import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_guru/config/theme/colors.dart';
import 'package:smart_guru/presentation/widget/button.dart';

class QuestionPage extends StatefulWidget {
  final Function()? onTap;
  const QuestionPage({super.key, required this.onTap});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final int jumlahSoal = 20;
  int _selectedIndex = -1;
  int selectedIndex = 0; // Set initial selected index to 0
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> questions = [];
  Map<int, int> userAnswers = {}; // Map to store user answers
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

  Future<void> getSoal(String idCourse) async {
    final url = 'https://besg.panti.my.id/course/$idCourse';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          questions = List<Map<String, dynamic>>.from(data['data']);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSoal('2'); // Fetch questions for course with id 2
  }

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
          'Trigonometri',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
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
                                  _selectedIndex = userAnswers[
                                          questions[selectedIndex]['id']] ??
                                      -1; // Set the selected choice based on previous answer
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
                // Bagian pertanyaan
                if (selectedIndex != -1)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Text(
                        questions[selectedIndex]['question'] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                // Bagian pilihan ganda choicechip
                if (selectedIndex != -1)
                  Column(
                    children: List.generate(
                      questions[selectedIndex]['answers'].length,
                      (index) {
                        return ChoiceChip(
                          visualDensity:
                              const VisualDensity(horizontal: 4, vertical: 4),
                          showCheckmark: false,
                          label: Text(questions[selectedIndex]['answers'][index]
                              ['content']),
                          selected: _selectedIndex == index,
                          backgroundColor: _selectedIndex == index
                              ? primaryColor
                              : secondaryColor,
                          selectedColor: primaryColor,
                          labelStyle: TextStyle(
                            fontSize: 16,
                            color: _selectedIndex == index
                                ? secondaryColor
                                : Colors.grey[700],
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 100.0,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              _selectedIndex = selected ? index : -1;
                              if (selected) {
                                // Save user answer
                                userAnswers[questions[selectedIndex]['id']] =
                                    questions[selectedIndex]['answers'][index]
                                        ['id'];
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
                      // print(userAnswers);
                      Navigator.pushNamed(context, '/ulasan');
                    },
                    buttonColor: primaryColor,
                    textColor: secondaryColor,
                  ),
              ],
            ),
    );
  }
}
