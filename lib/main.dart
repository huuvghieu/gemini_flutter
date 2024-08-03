import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_flutter/blocs/genai_bloc.dart';
import 'package:gemini_flutter/widgets/chat_bubble_widget.dart';
import 'package:gemini_flutter/widgets/message_box_widget.dart';

import 'data/chat_content.dart';

void main() {
  runApp(BlocProvider<GenaiBloc>(
    create: (context) => GenaiBloc(),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Expanded(child: BlocBuilder<GenaiBloc, GenaiState>(builder: (context, state) {
                final List<ChatContent> data = [];
                if (state is MessageUpdate) {
                  data.addAll(state.contents);
                }

                return ListView(
                    children: data.map(
                  (e) {
                    final bool isMine = e.sender == Sender.user;
                    final String? photoUrl = isMine
                        ? null
                        : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThr7qrIazsvZwJuw-uZCtLzIjaAyVW_ZrlEQ&s';
                    return ChatBubble(isMine: isMine, photoUrl: photoUrl, message: e.message);
                  },
                ).toList());
              })),
              MessageBox(
                onSendMessage: (value) {
                  context.read<GenaiBloc>().add(SendMessageEvent(value));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
