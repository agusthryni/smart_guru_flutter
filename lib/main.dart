import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_guru/presentation/pages/aichat/aichat.dart';
import 'package:smart_guru/presentation/pages/exam/create.dart';
import 'package:smart_guru/presentation/pages/login/lupa_kata_sandi.dart';
import 'package:smart_guru/presentation/pages/beranda/riwayat.dart';
import 'package:smart_guru/presentation/pages/beranda/beranda.dart';
import 'package:smart_guru/presentation/pages/login/login.dart';
import 'package:smart_guru/presentation/pages/login/kata_sandi_baru.dart';
import 'package:smart_guru/presentation/pages/login/otp.dart';
import 'package:smart_guru/presentation/pages/profil/hubungi_kami.dart';
import 'package:smart_guru/presentation/pages/profil/profil.dart';
import 'package:smart_guru/presentation/pages/profil/ubah_profil.dart';
import 'package:smart_guru/presentation/pages/profil/ubah_kata_sandi.dart';
import 'package:smart_guru/presentation/pages/register/register.dart';
import 'package:smart_guru/presentation/pages/register/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  runApp(MyApp(initialRoute: token == null ? '/splash' : '/beranda'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Poppins'),
          primaryTextTheme:
              Theme.of(context).textTheme.apply(fontFamily: 'Poppins'),
          textSelectionTheme:
              TextSelectionThemeData(cursorColor: Colors.grey.shade700)),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => LoginPage(
              onTap: () {},
            ),
        '/lupa_kata_sandi': (context) => LupaKataSandiPage(
              onTap: () {},
            ),
        '/otp': (context) => OTPPage(
              onTap: () {},
            ),
        '/kata_sandi_baru': (context) => KataSandiBaruPage(
              onTap: () {},
            ),
        '/register': (context) => RegisterPage(
              onTap: () {},
            ),
        '/beranda': (context) => const Beranda(),
        '/buat': (context) => CreatePage(
              onTap: () {},
            ),
        '/riwayat': (context) => RiwayatPage(
              onTap: () {},
            ),
        '/aichat': (context) => const AIChatPage(),
        '/profil': (context) => const ProfilPage(),
        '/ubah_profil': (context) => UbahProfilPage(
              onTap: () {},
            ),
        '/ubah_kata_sandi': (context) => UbahKataSandiPage(
              onTap: () {},
            ),
        '/hubungi_kami': (context) => HubungiKamiPage(
              onTap: () {},
            ),
      },
    );
  }
}
