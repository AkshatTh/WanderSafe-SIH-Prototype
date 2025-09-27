// This class defines what a chat message is.
// It holds the text of the message and a flag to know if it's from the AI or the user.
class ChatMessage {
  final String text;
  final bool isFromAI;

  ChatMessage({required this.text, required this.isFromAI});
}
