import 'package:flutter/foundation.dart';
import 'package:green_wallet/services/auth_service.dart';

class KycProvider extends ChangeNotifier {
  String _kycTier = "0";
  String get kycTier => _kycTier;

  // Load from SharedPreferences
  Future<void> loadKycTier() async {
    final tier = await AuthService.getKycTier();
    _kycTier = tier ?? "0";
    notifyListeners();
  }

  // Update and save new tier
  Future<void> updateKycTier(String newTier) async {
    _kycTier = newTier;
    await AuthService.saveKycTier(newTier);
    notifyListeners();
  }
}
