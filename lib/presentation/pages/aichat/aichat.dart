import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_guru/config/theme/colors.dart';
import 'package:smart_guru/presentation/widget/message_tile.dart';
import 'package:smart_guru/presentation/widget/appbar.dart';
import 'package:smart_guru/presentation/service/api_function.dart';
import 'package:smart_guru/presentation/widget/textfield.dart';

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AIChatPageState createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final TextEditingController _chatController = TextEditingController();
  bool _isLoading = false;
  final List<String> _chatMessages = [];

  void _sendMessage() async {
    String message = _chatController.text;
    if (message.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      _chatController.clear();
      Map<String, dynamic>? response = await post(
          context,
          'http://${dotenv.env['API_URL']}/chat',
          10,
          {"message": message},
          'Gagal mengirim pesan silahkan coba lagi',
          'Pesan terkirim');
      if (response['statusCode'] == 200) {
        String aiResponse = response['answer'];
        if (aiResponse.trim().isNotEmpty) {
          setState(() {
            _chatMessages.add(aiResponse);
          });
        }
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: const CustomAppBar(
        title: 'AIChat',
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _chatMessages.length,
                    itemBuilder: (context, index) {
                      final message = _chatMessages[index];

                      if (message.isNotEmpty) {
                        return MessageTile(
                          message: message,
                          index: index,
                          onDelete: (int index) {
                            setState(() {
                              _chatMessages.removeAt(index);
                            });
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(primaryColor)),
                    )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: MyTextField(
                        controller: _chatController,
                        hintText: 'AIChat',
                        obscureText: false)),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: primaryColor,
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
