import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:green_wallet/services/auth_service.dart';

class CardIdService {
  static const String _baseUrl =
      'https://greenwallet-6a1m.onrender.com/api/cards/my-cards';

  // ✅ Fetch all user cards (token auto-loaded from SharedPreferences)
  static Future<List<Map<String, dynamic>>> getUserCards() async {
    final token = await AuthService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No authentication token found. Please log in again.');
    }

    final url = Uri.parse('$_baseUrl?token=$token');

    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List cards = data['cards'];

      // ✅ Extract only card_id, currency, and card_limit
      return cards
          .map((card) => {
        'card_id': card['card_id'],
        'currency': card['currency'],
        'card_limit': card['card_limit'],
      })
          .toList();
    } else {
      throw Exception(
          'Failed to load cards. Status code: ${response.statusCode}');
    }
  }
}
