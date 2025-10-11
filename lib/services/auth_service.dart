import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _tokenKey = 'auth_token';
  static const _fullNameKey = 'full_name';
  static const _emailKey = 'email';
  static const _bvnkey = 'bvn';
  static const _kycTierKey = 'kyc_tier'; // 👈 Added
  static const _selfieKey = 'selfie'; // 👈 Added

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
    await prefs.remove(_bvnkey);
    await prefs.remove(_kycTierKey);
    await prefs.remove(_selfieKey);
  }

  // ✅ Save user profile
  static Future<void> saveUserProfile(String fullName, String email, String bvn, String selfie) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fullNameKey, fullName);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_bvnkey, bvn);
    await prefs.setString(_selfieKey, selfie);
  }

  // ✅ Retrieve user profile
  static Future<Map<String, String?>> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "full_name": prefs.getString(_fullNameKey),
      "email": prefs.getString(_emailKey),
      "bvn": prefs.getString(_bvnkey),
      "selfie": prefs.getString(_selfieKey),
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
}
