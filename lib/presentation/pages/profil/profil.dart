import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_guru/config/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:smart_guru/presentation/service/snackbar.dart';
import 'package:smart_guru/presentation/widget/curve_painter.dart';
import 'package:smart_guru/presentation/widget/listtile.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:smart_guru/presentation/service/alert_dialog.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  String imageUrl = '';
  String name = '';
  String email = '';
  File? imageFile;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      final decodedToken = JwtDecoder.decode(token);

      setState(() {
        imageUrl = prefs.getString('image') ?? '';
        name = decodedToken['name'];
        email = decodedToken['email'];
      });
    }
  }

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      _showUploadConfirmationDialog();
    }
  }

  Future<void> _uploadImage(String image) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final client = http.Client();

    final uri = Uri.parse(
        'http://${dotenv.env['API_URL']}/user/upload_profile_photo/${prefs.getString('id')}');

    final mimeTypeData =
        lookupMimeType(image, headerBytes: [0xFF, 0xD8])?.split('/');
    if (mimeTypeData == null || mimeTypeData.length != 2) {
      throw 'Invalid mime type';
    }

    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      await http.MultipartFile.fromPath(
        'profile_photo',
        image,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      ),
    );

    try {
      final responses =
          await request.send().timeout(const Duration(seconds: 10));

      if (responses.statusCode == 200) {
        final responseData = await responses.stream.bytesToString();
        final data = jsonDecode(responseData);

        prefs.setString('image',
            "http://${dotenv.env['API_URL']}/uploads/${data['photo_name']}");
        setState(() {
          imageUrl =
              "http://${dotenv.env['API_URL']}/uploads/${data['photo_name']}";
        });

        showCustomSnackBar(context, 'Berhasil upload foto', true);
      } else {
        showCustomSnackBar(
            context,
            'Gagal mengupload foto. Kode kesalahan: ${responses.statusCode}',
            false);
      }
    } on TimeoutException {
      showCustomSnackBar(
          context, 'Request timed out. Periksa koneksi internet Anda', false);
    } finally {
      client.close();
    }
  }

  void _showUploadConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Unggah Foto'),
          content: imageFile != null
              ? Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                )
              : const Text('No image selected'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal', style: TextStyle(color: primaryColor)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _uploadImage(imageFile!.path);
              },
              child: const Text('Unggah'),
            ),
          ],
        );
      },
    );
  }

  // fungsi logout
  void signUserOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.remove('token');
      await prefs.remove('id');
      await prefs.remove('nama');
      await prefs.remove('email');
      await prefs.remove('telp');
      await prefs.remove('address');
      await prefs.remove('image');

      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

      showCustomSnackBar(context, 'Berhasil keluar dari aplikasi!', true);
    } catch (e) {
      showCustomSnackBar(
          context, 'Gagal keluar dari aplikasi: ${e.toString()}', false);
    }
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showConfirmationDialog(
      context: context,
      title: 'Konfirmasi Keluar',
      content: 'Yakin ingin keluar dari aplikasi?',
      confirmText: 'Ya',
      cancelText: 'Tidak',
      onConfirm: () {
        Navigator.popUntil(context, ModalRoute.withName('/login'));
        signUserOut(context);
      },
      onCancel: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: Container(
          decoration: BoxDecoration(
              color: primaryColor,
              border: Border.all(width: 0, color: secondaryColor)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width,
                color: secondaryColor,
                child: CustomPaint(
                  painter: CurvePainter(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.35,
                        vertical: MediaQuery.of(context).size.height * 0.05),
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: imageUrl != ''
                            ? ClipOval(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: Colors.grey[800],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                decoration: const BoxDecoration(color: secondaryColor),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Column(
                        children: [
                          Column(
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
                          ),
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
                                  onTap: () => Navigator.pushNamed(
                                      context, '/ubah_profil'),
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
                                  onTap: () => Navigator.pushNamed(
                                      context, '/hubungi_kami'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextButton(
                            onPressed: () =>
                                showLogoutConfirmationDialog(context),
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
                  ),
                ),
              ))
            ],
          ),
        ));
  }
}
