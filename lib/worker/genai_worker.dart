import 'dart:async';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../data/chat_content.dart';

class GenAIWorker {
  late final GenerativeModelWrapper _model;

  final List<ChatContent> _content = [];
  final StreamController<List<ChatContent>> _streamController =
      StreamController.broadcast();

  Stream<List<ChatContent>> get stream => _streamController.stream;

  GenAIWorker({GenerativeModelWrapper? wapper}) {
    _model = wapper ?? GenerativeModelWrapper();
  }

  Future<void> sendToGemini(String message) async {
    _content.add(ChatContent.user(message));
    _streamController.sink.add(_content);
    try {
      final response = await _model.generateContent([Content.text(message)]);

      final String? text = response.text;

      if (text == null) {
        _content.add(const ChatContent.gemini("Unable to generate response"));
      } else {
        _content.add(ChatContent.gemini(text));
      }
    } catch (e) {
      _content.add(const ChatContent.gemini("Unable to generate response"));
    }
    _streamController.sink.add(_content);
  }
}

class GenerativeModelWrapper {
  late final GenerativeModel _model;

  GenerativeModelWrapper() {
    const apiKey = String.fromEnvironment('apiKey');
    _model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey);
  }
  Future<GenerateContentResponse> generateContent(Iterable<Content> prompt) =>
      _model.generateContent(prompt);
}
