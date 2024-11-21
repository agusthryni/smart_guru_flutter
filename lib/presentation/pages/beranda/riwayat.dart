import 'dart:convert';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_guru/config/theme/colors.dart';
import 'package:smart_guru/presentation/pages/exam/nilai.dart';
import 'package:smart_guru/presentation/widget/appbar.dart';
import 'package:smart_guru/presentation/widget/listtile.dart';
import 'package:http/http.dart' as http;

class RiwayatPage extends StatefulWidget {
  final Function()? onTap;
  const RiwayatPage({super.key, required this.onTap});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  Map<String, List<Map<String, dynamic>>> coursesByDate = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    fetchData();
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http
          .get(
            Uri.parse(
                'http://${dotenv.env['API_URL']}/user/course/${prefs.getString('id')}?limit=1000'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Group courses by date
        final List<dynamic> courseData = data['data'];
        for (var course in courseData) {
          final String date = course['time_created'].substring(0, 10);
          if (!coursesByDate.containsKey(date)) {
            coursesByDate[date] = [];
          }
          coursesByDate[date]!.add(course);
        }

        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
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
        title: 'Riwayat',
        showLeading: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoading)
                  const Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(primaryColor),
                  ))
                else
                  // Grouped list of courses
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: coursesByDate.entries.map((entry) {
                      final date = entry.key;
                      final courses = entry.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatDate(date),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: courses
                                .map((course) => Column(
                                      children: [
                                        MyListTile(
                                          title: course['subject'] ?? '',
                                          subtitle:
                                              ('${course['score'] ?? '0'}'),
                                          leading: const Icon(Icons.history),
                                          trailing:
                                              const Icon(Icons.chevron_right),
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) => NilaiPage(
                                                        onTap: () {},
                                                        idCourse:
                                                            '${course['id']}')));
                                          },
                                          tileColor: const Color(0xFFEEF0FC),
                                          shape: BorderRadius.circular(15.0),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat.yMMMMd('id_ID');
    final now = DateTime.now();
    if (parsedDate.year == now.year &&
        parsedDate.month == now.month &&
        parsedDate.day == now.day) {
      return 'Today';
    } else {
      return formatter.format(parsedDate);
    }
  }
}
