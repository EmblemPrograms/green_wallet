import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _tokenKey = 'auth_token';
  static const _fullNameKey = 'full_name';
  static const _emailKey = 'email';
  static const _bvnKey = 'bvn';
  static const _kycTierKey = 'kyc_tier';
  static const _selfieKey = 'selfie';
  static const _cardIdKey = 'card_id';
  // ✅ New keys for account & address details
  static const _accountNameKey = 'account_name';
  static const _bankNameKey = 'bank_name';
  static const _accountNumberKey = 'account_number';
  static const _nipCodeKey = 'nip_code';
  static const _addressKey = 'address';
  static const _walletBalanceKey = 'wallet_balance_ngn';

// ✅ Save wallet balance
  static Future<void> saveWalletBalance(double balance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_walletBalanceKey, balance);
  }

// ✅ Retrieve wallet balance
  static Future<double> getWalletBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_walletBalanceKey) ?? 0.0;
  }

  // ✅ Save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // ✅ Retrieve token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // ✅ Remove all saved data
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ✅ Save user profile
  static Future<void> saveUserProfile({
    required String fullName,
    required String email,
    String? bvn,
    String? selfie,
    String? cardId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fullNameKey, fullName);
    await prefs.setString(_emailKey, email);
    if (bvn != null) await prefs.setString(_bvnKey, bvn);
    if (selfie != null) await prefs.setString(_selfieKey, selfie);
    if (cardId != null) await prefs.setString(_cardIdKey, cardId);
  }

  // ✅ Retrieve user profile
  static Future<Map<String, String>> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "full_name": prefs.getString(_fullNameKey) ?? "",
      "email": prefs.getString(_emailKey) ?? "",
      "bvn": prefs.getString(_bvnKey) ?? "",
      "selfie": prefs.getString(_selfieKey) ?? "",
      "card_id": prefs.getString(_cardIdKey) ?? "",
      "account_name": prefs.getString(_accountNameKey) ?? "",
      "bank_name": prefs.getString(_bankNameKey) ?? "",
      "account_number": prefs.getString(_accountNumberKey) ?? "",
      "nip_code": prefs.getString(_nipCodeKey) ?? "",
      "address": prefs.getString(_addressKey) ?? "",
    };
  }

  // ✅ Save Account & Address Details
  static Future<void> saveAccountDetails({
    required String accountName,
    required String bankName,
    required String accountNumber,
    required String nipCode,
    required String address,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accountNameKey, accountName);
    await prefs.setString(_bankNameKey, bankName);
    await prefs.setString(_accountNumberKey, accountNumber);
    await prefs.setString(_nipCodeKey, nipCode);
    await prefs.setString(_addressKey, address);
  }
  //✅ Add this method inside AuthService:
  static Future<void> fetchAndSaveUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token == null) {
      throw Exception("No token found");
    }

    final url = Uri.parse(
        'https://greenwallet-6a1m.onrender.com/api/users/profile?token=$token');

    final response = await http.get(url, headers: {
      'accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // ✅ Save main user details
      await saveUserProfile(
        fullName: data['full_name'] ?? '',
        email: data['email'] ?? '',
        bvn: data['bvn'] ?? '',
        selfie: data['selfie'] ?? '',
        cardId: data['virtual_cards'] != null && data['virtual_cards'].isNotEmpty
            ? data['virtual_cards'][0]['card_id']
            : '',
      );

      // ✅ Save account details (first deposit account)
      if (data['deposit_accounts'] != null &&
          data['deposit_accounts'].isNotEmpty) {
        final account = data['deposit_accounts'][0];
        await saveAccountDetails(
          accountName: account['account_name'] ?? '',
          bankName: account['bank_name'] ?? '',
          accountNumber: account['account_number'] ?? '',
          nipCode: account['nip_code'] ?? '',
          address: data['home_address'] ?? '',
        );
      }

      // ✅ Save KYC tier
      if (data['kyc_tier'] != null) {
        await saveKycTier(data['kyc_tier']);
      }
    } else {
      throw Exception(
          'Failed to fetch user profile. Status: ${response.statusCode}');
    }
  }

  // ✅ Save KYC tier
  static Future<void> saveKycTier(String kycTier) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kycTierKey, kycTier);
  }

  // ✅ Retrieve KYC tier
  static Future<String?> getKycTier() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kycTierKey);
  }

  // ✅ Single value getters
  static Future<String?> getCardId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cardIdKey);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fullNameKey);
  }
}
