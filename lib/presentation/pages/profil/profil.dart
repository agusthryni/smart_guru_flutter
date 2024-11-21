import 'package:flutter/material.dart';
import 'package:smart_guru/config/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:smart_guru/presentation/widget/listtile.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  Future<Map<String, dynamic>> decodedToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return JwtDecoder.decode(prefs.getString('token')!);
  }

  // fungsi logout
  void signUserOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.remove('token');
      await prefs.remove('nama');
      await prefs.remove('email');

      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil keluar dari aplikasi!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal keluar dari aplikasi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: Container(
          decoration: const BoxDecoration(color: primaryColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width,
                color: secondaryColor,
                child: CustomPaint(
                  painter: CurvePainter(),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 80),
                    child: CircleAvatar(),
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                decoration: const BoxDecoration(color: secondaryColor),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: [
                      // nama & email
                      FutureBuilder(
                          future: decodedToken(),
                          builder: (ctx, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              final name = snapshot.data!['name'];
                              final email = snapshot.data!['email'];
                              return Column(
                                children: [
                                  Text(name,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                  Text(email,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400))
                                ],
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          }),
                      // text akun
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Akun',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      // listtile akun
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            MyListTile(
                              title: 'Ubah Profil',
                              leading: const Icon(Icons.person),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () =>
                                  Navigator.pushNamed(context, '/ubah_profil'),
                            ),
                            MyListTile(
                              title: 'Ubah Kata Sandi',
                              leading: const Icon(Icons.password),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => Navigator.pushNamed(
                                  context, '/ubah_kata_sandi'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      // text umum
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Umum',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      // listtile umum
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            MyListTile(
                              title: 'Hubungi Kami',
                              leading: const Icon(Icons.contact_mail),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () =>
                                  Navigator.pushNamed(context, '/hubungi_kami'),
                            ),
                            MyListTile(
                              title: 'FAQ',
                              leading: const Icon(Icons.quiz),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => Navigator.pushNamed(context, '/faq'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      // logout
                      TextButton(
                        onPressed: () => {signUserOut(context)},
                        child: const Text(
                          'Keluar',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ))
            ],
          ),
        ));
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = primaryColor;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.6);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 1, size.width, size.height * 0.6);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.moveTo(0, size.height * 0.25);
    path.quadraticBezierTo(
        size.width / 2, size.height / 2, size.width, size.height * 0.25);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
