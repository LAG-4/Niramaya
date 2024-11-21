import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dart_openai/dart_openai.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _chatHistory = [];

  @override
  void initState() {
    super.initState();
    _initOpenAI();
  }

  void _initOpenAI() {
    OpenAI.apiKey = dotenv.env['OPEN_AI_API_KEY']!;
  }

  Future<void> _handleSendMessage() async {
    final userMessage = _messageController.text;
    _messageController.clear();

    setState(() {
      _chatHistory.add({'role': 'user', 'text': userMessage});
    });

    try {
      final systemMessage = OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.system,
        content: "You are a friendly and supportive chatbot designed to assist users dealing with mental health challenges. Always respond in an empathetic, kind, and uplifting manner. Avoid offering clinical advice and instead encourage users to seek help from trusted professionals or support networks if needed.",
      );

      final chatMessages = [
        systemMessage,
        ..._chatHistory.map((message) {
          final role = message['role'] == 'user'
              ? OpenAIChatMessageRole.user
              : OpenAIChatMessageRole.assistant;
          return OpenAIChatCompletionChoiceMessageModel(
            role: role,
            content: message['text']!,
          );
        }),
      ];

      final response = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: chatMessages,
        maxTokens: 150,
        temperature: 0.5,
      );

      final aiResponse = response.choices.first.message.content.trim();

      setState(() {
        _chatHistory.add({'role': 'model', 'text': aiResponse});
      });
    } catch (e) {
      setState(() {
        _chatHistory.add({'role': 'model', 'text': 'Error: $e'});
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dawn'),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 255, 254, 211), // Start color
              Color.fromARGB(255, 187, 233, 255), // End color
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _chatHistory.length,
                itemBuilder: (context, index) {
                  final message = _chatHistory[index]['text']!;
                  final isUserMessage = _chatHistory[index]['role'] == 'user';
                  return Row(
                    mainAxisAlignment: isUserMessage
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Padding(
                          padding:
                          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: isUserMessage
                                  ? const Color.fromRGBO(136, 192, 255, 1)
                                  : const Color.fromARGB(255, 255, 255, 255),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: isUserMessage
                                ? Text(
                              message,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 37, 21, 65)),
                            )
                                : MarkdownBody(
                              data: message,
                              styleSheet: MarkdownStyleSheet(
                                p: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(
                        color: Color.fromARGB(255, 247, 249, 255),
                      ),
                      controller: _messageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Type a message...',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 14, 43, 86),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _handleSendMessage,
                    icon: const Icon(Icons.send),
                    color: const Color.fromARGB(255, 10, 50, 83),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
