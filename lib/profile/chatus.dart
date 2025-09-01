import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }


  final List<String> _botReplies = [
    "Hello! How can I help you today?",
    "That's interesting!",
    "We'll get back to you shortly.",
    "Please hold on while I check that.",
    "Thanks for reaching out.",
    "Can you explain more?",
    "I’ll look into that for you.",
  ];

  void _sendMessage() {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({
          "text": message,
          "isUser": true,
          "time": _formatTime(DateTime.now())
        });
      });
      _messageController.clear();
      _scrollToBottom();

      Future.delayed(const Duration(seconds: 1), () {
        _addBotReply(message);
      });
    }
  }

  void _addBotReply(String userMessage) {
    String reply;
    if (userMessage.toLowerCase().contains("hello")) {
      reply = "Hi there! How can I help?";
    } else if (userMessage.toLowerCase().contains("problem")) {
      reply = "I'm sorry to hear that. Can you describe the problem?";
    } else {
      reply = _botReplies[Random().nextInt(_botReplies.length)];
    }

    setState(() {
      _messages.add({
        "text": reply,
        "isUser": false,
        "time": _formatTime(DateTime.now())
      });
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Chat with us now!",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message["isUser"] as bool;
                final time = message["time"] as String;

                return Column(
                  crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                      isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (!isUser)
                          const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.smart_toy, size: 14, color: Colors.white),
                          ),
                        const SizedBox(width: 6),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                          decoration: BoxDecoration(
                            color: isUser
                                ? const Color(0xFF3F2771)
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isUser ? 16 : 0),
                              bottomRight: Radius.circular(isUser ? 0 : 16),
                            ),
                          ),
                          child: Text(
                            message["text"],
                            style: TextStyle(
                              color: isUser ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (isUser)
                          const CircleAvatar(
                            radius: 12,
                            backgroundColor: Color(0xFF3F2771),
                            child: Icon(Icons.person, size: 14, color: Colors.white),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 2, bottom: 6, left: 6, right: 6),
                      child: Text(
                        time,
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Input field
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3F2771),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF3F2771)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter your question",
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send,
                                color: Color(0xFF3F2771)),
                            onPressed: _sendMessage,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}