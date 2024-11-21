import 'package:flutter/material.dart';
import 'package:smart_guru/presentation/pages/aichat/aichat.dart';
import 'package:smart_guru/presentation/pages/exam/create.dart';
import 'package:smart_guru/presentation/pages/exam/nilai.dart';
import 'package:smart_guru/presentation/pages/profil/profil.dart';
import 'package:smart_guru/presentation/service/api_function.dart';
import 'package:smart_guru/presentation/widget/button_with_icon.dart';
import 'package:smart_guru/presentation/widget/greeting.dart';
import 'package:smart_guru/presentation/widget/listtile.dart';
import '../../../config/theme/colors.dart';
import '../../widget/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeWidget(),
    CreatePage(onTap: () {}),
    const AIChatPage(),
    const ProfilPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          _onItemTapped(index);
        },
      ),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  String? _name;
  String imageUrl = '';

  Future<Map<dynamic, dynamic>> getCourses() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String idUser = prefs.getString('id') as String;
    return await get(
        context,
        'http://${dotenv.env['API_URL']}/user/course/$idUser',
        10,
        '',
        '',
        false);
  }

  void getName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name')!;
    });
  }

  void getImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imageUrl = prefs.getString('image') ?? '';
      print(imageUrl);
    });
  }

  @override
  void initState() {
    super.initState();
    getCourses();
    getName();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: GestureDetector(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.zero,
              ),
              child: ListTile(
                title: Text(
                  'Halo, $_name',
                  style: const TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  getGreeting(),
                  style: TextStyle(color: Colors.grey[600]),
                ),
                leading: Icon(getGreetingIcons()),
                trailing: imageUrl != ''
                    ? CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ))
                    : const Icon(Icons.account_circle),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                onTap: () => Navigator.pushNamed(context, '/profil'),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: primaryColor, borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                      'Tentukan pertanyaan Anda sesuai dengan uji pemahaman yang Anda inginkan disini',
                      style: TextStyle(
                        fontSize: 14,
                        color: secondaryColor,
                      ),
                      textAlign: TextAlign.center),
                  const SizedBox(
                    height: 20,
                  ),
                  MyButtonIcon(
                    text: 'Buat',
                    onTap: () {
                      Navigator.pushNamed(context, '/buat');
                    },
                    icon: const Icon(Icons.assignment_add, color: primaryColor),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Terbaru',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/riwayat');
                    },
                    child: const Row(
                      children: [
                        Text(
                          'Lihat Riwayat',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FutureBuilder<Map<dynamic, dynamic>>(
                future: getCourses(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data!['data'] == null) {
                      return const Center(
                          child: Text('Belum ada riwayat pengerjaan'));
                    }
                    if (snapshot.data!['error'] != null) {
                      return const Center(child: Text('Error loading courses'));
                    }
                    List<Widget> totalTile = [];
                    snapshot.data!['data'].forEach((item) {
                      totalTile.add(
                        MyListTile(
                          title: (item['subject']),
                          subtitle: ('${item['score'] ?? '0'}'),
                          leading: const Icon(Icons.history),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => NilaiPage(
                                    onTap: () {}, idCourse: '${item['id']}')));
                          },
                          tileColor: const Color(0xFFEEF0FC),
                          shape: BorderRadius.circular(15.0),
                        ),
                      );
                    });
                    return ListView.builder(
                      itemCount: totalTile.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: totalTile[index],
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(primaryColor)));
                  }
                }),
          ),
        ),
      ],
    );
  }
}
