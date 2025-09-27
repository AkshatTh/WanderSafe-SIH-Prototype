import 'package:flutter/material.dart';
import 'package:wandersafe_app/core/services/gemini_service.dart'; // Import the new service
import 'package:wandersafe_app/core/services/user_manager.dart';
import 'package:wandersafe_app/features/home/data/models/chat_message.dart';
import 'package:wandersafe_app/features/home/presentation/widgets/chat_bubble_widget.dart';

class AiCompanionScreen extends StatefulWidget {
  const AiCompanionScreen({super.key});

  @override
  State<AiCompanionScreen> createState() => _AiCompanionScreenState();
}

class _AiCompanionScreenState extends State<AiCompanionScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final GeminiService _geminiService = GeminiService(); // Create an instance of the service

  // Add a loading state
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final username = UserManager().username?.split(' ')[0] ?? 'there';
    _messages.add(
      ChatMessage(
        text: 'Hi $username! I\'m your WanderSafe AI, connected to real-time information. Ask me anything about Hyderabad!',
        isFromAI: true,
      ),
    );
  }

  // Updated function to call the Gemini Service
  void _sendMessage() async {
    final text = _textController.text;
    if (text.trim().isEmpty || _isLoading) {
      return; 
    }

    setState(() {
      _messages.add(ChatMessage(text: text, isFromAI: false));
      _isLoading = true; // Start loading
      _messages.add(ChatMessage(text: "...", isFromAI: true)); // Add a "thinking" bubble
    });

    _textController.clear();
    _scrollToBottom();

    // Get the real response from the Gemini API
    final aiResponse = await _geminiService.getResponse(text);
    
    // Remove the "thinking" bubble and add the real response
    setState(() {
      _messages.removeLast(); // Remove the "..."
      _messages.add(ChatMessage(text: aiResponse, isFromAI: true));
      _isLoading = false; // Stop loading
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    // A small delay ensures the list has time to update before we scroll
    Future.delayed(const Duration(milliseconds: 50), () {
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
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('AI Companion', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubbleWidget(
                  text: message.text,
                  isFromAI: message.isFromAI,
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)]),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onSubmitted: _isLoading ? null : (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: _isLoading ? 'WanderSafe is thinking...' : 'Ask me anything...',
                        filled: true,
                        fillColor: const Color(0xFFF0F4F8),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Disable the button while the AI is responding
                  IconButton(
                    icon: _isLoading ? const CircularProgressIndicator() : const Icon(Icons.send, color: Color(0xFF364F6B)),
                    onPressed: _isLoading ? null : _sendMessage,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

