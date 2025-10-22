import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _tokenKey = 'auth_token';
  static const _fullNameKey = 'full_name';
  static const _emailKey = 'email';
  static const _bvnKey = 'bvn';
  static const _kycTierKey = 'kyc_tier';
  static const _selfieKey = 'selfie';
  static const _cardIdKey = 'card_id';

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
    await prefs.remove(_tokenKey);
    await prefs.remove(_fullNameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_bvnKey);
    await prefs.remove(_kycTierKey);
    await prefs.remove(_selfieKey);
    await prefs.remove(_cardIdKey);
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
    };
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
