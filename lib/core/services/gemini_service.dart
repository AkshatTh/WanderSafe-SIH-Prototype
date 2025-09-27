import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wandersafe_app/core/services/api_keys.dart'; // Import the new key file

class GeminiService {
  // The API key is now read from the secure, untracked file.
  final String _apiKey = geminiApiKey; 
  late final Uri _apiUrl;

  GeminiService() {
    _apiUrl = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-05-20:generateContent?key=$_apiKey'
    );
  }

  final _systemPrompt = """
  You are WanderSafe AI, a friendly and expert travel safety assistant. 
  The user is a tourist currently in Hyderabad, India.
  Today's date is September 27, 2025.

  Your primary goal is to provide helpful, concise, and safety-conscious advice.
  You MUST use your real-time Google Search capabilities to answer questions about places, opening times, travel routes, and local safety conditions.
  Always prioritize the user's safety in your recommendations.
  If asked about a place, provide a brief description and a key safety tip.
  For example: "Charminar is a beautiful historic monument. It can get very crowded, so be mindful of your belongings."
  """;

  Future<String> getResponse(String userMessage) async {
    try {
      final payload = {
        // --- THIS IS THE CORRECTED PART ---
        "contents": [
          {
            "role": "user", // This "role" key was missing and is required by the API.
            "parts": [{"text": userMessage}]
          }
        ],
        "tools": [
          {"google_search": {}}
        ],
        "systemInstruction": {
          "parts": [{"text": _systemPrompt}]
        },
      };

      final response = await http.post(
        _apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        // Add a safety check for the response structure
        if (decodedResponse['candidates'] != null && decodedResponse['candidates'][0]['content'] != null) {
             return decodedResponse['candidates'][0]['content']['parts'][0]['text'];
        } else {
            return "Sorry, I received an unexpected response from the AI.";
        }
      } else {
        // Provide more detailed error info for debugging
        return "Sorry, I couldn't connect to my brain right now. Error ${response.statusCode}: ${response.body}";
      }
    } catch (e) {
      return "Sorry, something went wrong. Please check your connection and try again.";
    }
  }
}

