import 'package:flutter/material.dart';
import 'package:gemini_flutter/widgets/chat_bubble_widget.dart';
import 'package:gemini_flutter/widgets/message_box_widget.dart';
import 'package:gemini_flutter/worker/genai_worker.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final GenAIWorker _worker = GenAIWorker();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder<List<ChatContent>>(
                      stream: _worker.stream,
                      builder: (context, snapshot) {
                        final List<ChatContent> data = snapshot.data ?? [];

                        return ListView(
                            children: data.map((e) {
                              final bool isMine = e.sender == Sender.user;
                              final String? photoUrl = isMine ? null : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThr7qrIazsvZwJuw-uZCtLzIjaAyVW_ZrlEQ&s';
                              return ChatBubble(isMine: isMine, photoUrl: photoUrl, message: e.message);
                            },).toList()
                        );
                      }
                  )),
              MessageBox(
                onSendMessage: (value) {
                  _worker.sendToGemini(value);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
