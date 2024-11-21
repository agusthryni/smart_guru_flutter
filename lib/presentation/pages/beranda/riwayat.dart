import 'package:flutter/material.dart';
import 'package:smart_guru/config/theme/colors.dart';
import 'package:smart_guru/presentation/widget/listtile.dart';

class RiwayatPage extends StatefulWidget {
  final Function()? onTap;
  const RiwayatPage({super.key, required this.onTap});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0,
        title: const Text(
          'Riwayat',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // date
                const Text(
                  'Terbaru',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                // listtile
                MyListTile(
                  title: 'Topik',
                  subtitle: 'Nilai',
                  leading: const Icon(Icons.history),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(context, '/riwayat_lengkap');
                  },
                  tileColor: const Color(0xFFEEF0FC),
                  shape: BorderRadius.circular(15.0),
                ),
                const SizedBox(height: 10),
                // date
                const Text(
                  '13 Desember 2023',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                // listtile
                MyListTile(
                  title: 'Topik',
                  subtitle: 'Nilai',
                  leading: const Icon(Icons.history),
                  trailing: const Icon(Icons.chevron_right),
                  // onTap: () => print('Item 1 tapped!'),
                  tileColor: const Color(0xFFEEF0FC),
                  shape: BorderRadius.circular(15.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
