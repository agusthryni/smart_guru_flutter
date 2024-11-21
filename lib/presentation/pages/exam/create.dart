import 'package:flutter/material.dart';
import 'package:smart_guru/presentation/pages/exam/list_materi.dart';
import 'package:smart_guru/presentation/widget/dropdown.dart';
import '../../../config/theme/colors.dart';
import '../../widget/button.dart';

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
  String? selectedJumlahPertanyaan;
  String? selectedTipeJawaban;
  String? selectedJumlahJawaban;

  List<String> materiDropdown = [];

  void updateDropdownMateri() {
    if (selectedMataPelajaran == "Matematika") {
      materiDropdown = mtkDropdown[selectedKelas]!;
    } else if (selectedMataPelajaran == "Fisika") {
      materiDropdown = fisikaDropdown[selectedKelas]!;
    } else if (selectedMataPelajaran == "Kimia") {
      materiDropdown = kimiaDropdown[selectedKelas]!;
    } else if (selectedMataPelajaran == "Informatika") {
      materiDropdown = ifDropdown[selectedKelas]!;
    } else if (selectedMataPelajaran == "Biologi") {
      materiDropdown = bioDropdown[selectedKelas]!;
    }
    selectedMateri = null;
    setState(() {});
  }

  bool _showJumlahJawaban = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        appBar: AppBar(
          backgroundColor: secondaryColor,
          elevation: 0,
          title: const Text(
            'Buat Pertanyaan',
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
                  // subtitle
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                    items: const ['10', '11', '12'],
                    hintText: 'Kelas',
                    onChanged: (value) {
                      selectedKelas = value;
                      updateDropdownMateri();
                    },
                  ),
                  const SizedBox(height: 20),
                  // mata pelajaran dropdown
                  MyDropdown(
                    items: const [
                      'Matematika',
                      'Kimia',
                      'Fisika',
                      'Informatika',
                      'Biologi',
                    ],
                    hintText: 'Mata Pelajaran',
                    onChanged: (value) {
                      selectedMataPelajaran = value;
                      updateDropdownMateri();
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: DropdownButtonFormField<String>(
                      value: selectedMateri,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        fillColor: secondaryColor,
                        filled: true,
                      ),
                      hint: Text("Materi",
                          style: TextStyle(color: Colors.grey[500])),
                      dropdownColor: Colors.white,
                      isExpanded: true,
                      items: materiDropdown.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMateri = newValue;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // jumlah pertanyaan dropdown
                  MyDropdown(
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
                      Navigator.pushNamed(context, '/soal');
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
