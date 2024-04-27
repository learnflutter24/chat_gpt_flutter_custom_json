import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../model/MessageModel.dart';
import '../model/ResponseModel.dart';
import '../widgets/card.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  static const kValue = 15.0;
  final textController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  static const apiKey = 'YOUR-API-KEY';
  final messages = [MessageModel(true, 'Hi')];
  bool isBotTyping = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('ChatGPT Custom JSON'),
          leading: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/chatGpt.png'),
            ),
          ),
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final isBot = messages[index].isBot;
                    final alignment =
                        isBot ? Alignment.centerLeft : Alignment.centerRight;
                    return Align(
                      alignment: alignment,
                      child: card(
                        index: index,
                        alignment: alignment,
                        isBot: isBot,
                        message: messages[index].message.trim(),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: kValue / 2,
                    vertical: kValue / 1.5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(kValue),
                      topLeft: Radius.circular(kValue),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.23),
                        offset: const Offset(kValue / 1.2, .5),
                        blurRadius: kValue,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.12),
                            borderRadius: BorderRadius.circular(kValue * 3.33),
                          ),
                          child: TextFormField(
                            controller: textController,
                            autofocus: true,
                            decoration: const InputDecoration(
                              hintText: 'Enter question here',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(kValue),
                            ),
                            textInputAction: TextInputAction.send,
                            validator: (value) =>
                                value!.isEmpty ? 'Enter some question' : null,
                          ),
                        ),
                      ),
                      isBotTyping
                          ? Transform.scale(
                              scale: 0.8,
                              child: const CircularProgressIndicator(
                                strokeWidth: 5,
                                color: Color(0xff0360a6),
                              ),
                            )
                          : GestureDetector(
                              onTap: askQuestion,
                              child: Container(
                                margin: const EdgeInsets.all(kValue / 2),
                                width: kValue * 3,
                                height: kValue * 3,
                                decoration: BoxDecoration(
                                  color: const Color(0xff0360a6),
                                  borderRadius:
                                      BorderRadius.circular(kValue * 3.33),
                                ),
                                child: const Icon(
                                  Icons.send,
                                  size: kValue * 1.6,
                                  color: Color(0xffffffff),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );

  void askQuestion() async {
    if (formKey.currentState!.validate()) {
      messages.add(
        MessageModel(false, textController.text),
      );
      setState(() => isBotTyping = true);

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey'
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo",
            "messages": [
              {
                "role": "user",
                "content": textController.text,
              },
            ],
          },
        ),
      );
      textController.clear();
      debugPrint('response :$response');
      debugPrint('response.body :${response.body}');
      debugPrint('response.statusCode :${response.statusCode}');
      if (response.statusCode == 200) {
        setState(() {
          final responseModel = ResponseModel.fromJson(
            jsonDecode(response.body),
          );
          messages.add(
            MessageModel(
              true,
              responseModel.choices[0].message!.content.toString(),
            ),
          );
          isBotTyping = false;
        });
      }
    }
  }
}
