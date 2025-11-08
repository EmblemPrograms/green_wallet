import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:green_wallet/services/auth_service.dart';

class CardService {
  static const String _baseUrl =
      'https://greenwallet-6a1m.onrender.com/api/cards/details';

  /// Fetch card details for [cardId].
  /// If [useRelay] is true, the server may return decrypted values (subject to server config).
  /// Returns a Map with both raw fields (when returned by API) and masked fields.
  static Future<Map<String, dynamic>> getCardDetails(
      String cardId, {
        bool useRelay = false,
      }) async {
    final token = await AuthService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('No authentication token found. Please log in.');
    }

    final uri = Uri.parse(
        '$_baseUrl/$cardId?use_relay=${useRelay.toString()}&token=$token');

    final response = await http.get(
      uri,
      headers: {
        'accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to fetch card details. Status code: ${response.statusCode}');
    }

    final Map<String, dynamic> jsonBody = json.decode(response.body);
    final data = jsonBody['data'] as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Card details missing in response.');
    }

    // Helper masking functions
    String maskCardNumberFromData(Map<String, dynamic> d) {
      // If API returned a decrypted card_number (not starting with "ev:")
      final rawNumber = d['card_number'] as String?;
      final last4 = d['last_4'] as String?;
      if (rawNumber != null && !rawNumber.startsWith('ev:')) {
        // Keep only last 4 digits visible, mask rest.
        final digitsOnly = rawNumber.replaceAll(RegExp(r'\D'), '');
        if (digitsOnly.length >= 4) {
          final visible = digitsOnly.substring(digitsOnly.length - 4);
          return '**** **** **** $visible';
        } else {
          return '**** **** **** $digitsOnly';
        }
      }

      // Encrypted or unavailable: use last_4 if present
      if (last4 != null && last4.isNotEmpty) {
        return '**** **** **** $last4';
      }

      // Fallback
      return '**** **** **** ****';
    }

    String maskCvvFromData(Map<String, dynamic> d) {
      final cvv = d['cvv'] as String?;
      if (cvv != null && !cvv.startsWith('ev:')) {
        // If decrypted but we still want to fully mask for safety:
        return '*' * cvv.length;
      }
      // Encrypted or missing: mask as 3 stars (safe default)
      return '***';
    }

    String maskExpiryYearFromData(Map<String, dynamic> d) {
      final year = d['expiry_year'] as String?;
      if (year != null && !year.startsWith('ev:')) {
        // show full year only if decrypted and you're sure it's safe
        final digits = year.replaceAll(RegExp(r'\D'), '');
        if (digits.length >= 4) {
          return digits; // e.g. 2028
        } else if (digits.isNotEmpty) {
          return digits;
        }
      }
      // Masked fallback
      return '****';
    }

    // Build result map
    final result = <String, dynamic>{
      // Raw values returned by the API (may be encrypted strings)
      'raw': data,

      // Safe, masked display values
      'masked_card_number': maskCardNumberFromData(data),
      'masked_cvv': maskCvvFromData(data),
      'masked_expiry_year': maskExpiryYearFromData(data),

      // Helpful unmasked / safer fields (server-provided)
      'last_4': data['last_4'],
      'brand': data['brand'],
      'card_currency': data['card_currency'],
      'card_name': data['card_name'],
      'card_id': data['card_id'],
      'is_active': data['is_active'],
      'available_balance': data['available_balance'],
    };

    return result;
  }
}
