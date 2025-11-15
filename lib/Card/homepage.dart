import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_wallet/ActionB/TopUp.dart';
import 'package:green_wallet/Card/NCard.dart';
import 'package:green_wallet/Card/Profile.dart';
import 'package:green_wallet/Card/Transfer.dart';
import 'package:green_wallet/services/auth_service.dart';
import 'package:green_wallet/widgets/Navigation_bar.dart';
import 'package:green_wallet/widgets/profileheader.dart';
import 'package:green_wallet/KycTier2/NoticeID.dart';
import 'package:http/http.dart' as http;

import '../ActionB/convert/rates.dart';


// Helper method for bottom navigation items

class HomeContainer extends StatefulWidget {
  const HomeContainer({super.key});

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  int _selectedIndex = 0;

  // List of screens (widgets) for navigation

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomepageScreen(),
      const MyCardsPage(),
      const Transfer(),
      const Profile(),
    ];
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onNavItemTapped,
      ),
    );
  }
}

// Helper method for action buttons
Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
  return Column(
    children: [
      GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.2),
          child: Icon(icon, color: Colors.white),
        ),
      ),
      const SizedBox(height: 6),
      Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    ],
  );
}

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  bool _isObscured = true;
  String _fullName = "Loading..."; // Default value
  String _kycTier = "0"; // Default: not verified
  bool _isLoadingUser = false;
  double _walletBalance = 0.0;
  List<Transaction> _transactions = [];
  bool _loadingTransactions = true;

  @override
  void initState() {
    super.initState();
    if (!_isLoadingUser) {
      _isLoadingUser = true;
      _loadSavedBalance();
      // ✅ Fetch and store profile (includes account_id)
      AuthService.fetchAndSaveUserProfile().then((_) {
        _loadUserData();        // Update UI with latest profile data
        _fetchTransactions();   // ✅ Fetch transactions using saved account_id + token
      });
    }
  }

  Future<void> _loadSavedBalance() async {
    final balance = await AuthService.getWalletBalance();
    setState(() {
      _walletBalance = balance;
    });
  }


  Future<void> _loadUserData() async {
    String? token = await AuthService.getToken();

    if (token == null) {
      debugPrint("❌ No token found");
      return;
    }

    final url =
        "https://greenwallet-6a1m.onrender.com/api/users/profile?token=$token";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Accept": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (!mounted) return;

        // ✅ Update UI values
        setState(() {
          _fullName = data['full_name'] ?? "User";
          _kycTier = data['kyc_tier']?.toString() ?? "0";
          _walletBalance = (data['wallet_balance']?['NGN'] ?? 0).toDouble();
        });

        // ✅ Save in local storage for offline use
        await AuthService.saveUserProfile(
          fullName: data['full_name'] ?? "User",
          email: data['email'] ?? "Unknown",
          bvn: data['bvn'] ?? "Unknown",
          selfie: data['selfie'] ?? "",
          cardId: data['virtual_cards'] != null &&
              data['virtual_cards'].isNotEmpty
              ? data['virtual_cards'][0]['card_id']
              : "",
        );

        await AuthService.saveKycTier(_kycTier);

        // ✅ Save wallet balance locally
        if (data['wallet_balance'] != null &&
            data['wallet_balance']['NGN'] != null) {
          await AuthService.saveWalletBalance(
              (data['wallet_balance']['NGN']).toDouble());
        }
      } else {
        debugPrint("❌ Profile fetch failed: ${response.body}");
      }
    } catch (e) {
      debugPrint("⚠️ Error fetching user data: $e");
    }
  }

  Future<void> _fetchTransactions() async {
    String? token = await AuthService.getToken();
    String? accountId = await AuthService.getAccountId();

    if (token == null || accountId == null) {
      debugPrint("❌ Missing token or account ID");
      return;
    }
    final url =
        "https://greenwallet-6a1m.onrender.com/api/transactions/accounts/$accountId/transactions?token=$token";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          _transactions = data.map((tx) => Transaction.fromJson(tx)).toList();
          _loadingTransactions = false;
        });
      } else {
        debugPrint("⚠️ Transaction fetch failed: ${response.body}");
        setState(() => _loadingTransactions = false);
      }
    } catch (e) {
      debugPrint("⚠️ Error fetching transactions: $e");
      setState(() => _loadingTransactions = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F2771), // Purple background
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ProfileHeader(),
                  // Notification Icon
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(Icons.notifications, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Main Content Section
            Stack(
              children: [
                // Purple Background
                Container(
                  height: MediaQuery.of(context).size.height * 0.78,
                  color: const Color(0xFF3F2771), // Purple background
                ),

                // White Card Section
                Positioned(
                  top: 156,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    // Responsive height: take 50% of screen height
                    height: MediaQuery.of(context).size.height * 0.60,
                    width: double.infinity, // Full width of the screen
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: _kycTier == "1"
                        ? _buildUpgradeToTier2()
                        : _buildTransactionSection(),
                  ),
                ),

                // Account Balance Section
                Positioned(
                  top: 0,
                  left: 20,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1039),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        // Background gold coins image
                        Positioned(
                          top: 0, // Start at the top
                          right: 0, // Align to the extreme right
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                            ),
                            child: Image.asset(
                              'assets/gold_coins.png', // Replace with your image asset
                              height: 100, // Adjust height as needed
                              fit: BoxFit
                                  .contain, // Ensures the image fits within bounds
                            ),
                          ),
                        ),
                        // Content on top of the image
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Account Balance",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _isObscured
                                        ? "******"
                                        : "₦${_walletBalance.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  IconButton(
                                    icon: Icon(
                                      _isObscured
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscured =
                                            !_isObscured; // Toggle visibility
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildActionButton(
                                      Icons.currency_exchange, "Rates", () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RatesScreen()),
                                    );
                                  }),
                                  _buildActionButton(Icons.add, "Top-up", () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Topup()),
                                    );
                                  }),
                                                                  ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// 🟣 Shown if user has NOT verified BVN (kyc_tier != 2)
  Widget _buildTransactionSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 25,
        bottom: 10,
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Transaction History",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1D1F),
                ),
              ),
              Text(
                "View All",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 🔹 Show loading, empty or list
          if (_loadingTransactions)
            const Center(child: CircularProgressIndicator())
          else if (_transactions.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "No transactions yet",
                  style: TextStyle(color: Colors.black45),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final tx = _transactions[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.account_balance_wallet,
                                  color: Color(0xFF6D28D9)),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx.reason,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1D1F)),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${tx.createdAt.hour}:${tx.createdAt.minute.toString().padLeft(2, '0')} PM",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          "₦${tx.amount.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1D1F)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }


// 🟢 Shown if KYC Tier 1 is already completed
  Widget _buildUpgradeToTier2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/Done.png', // Replace with your image
          width: 150, // Matches the Icon size
          height: 150,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 20),
        const Text(
          "You're verified to Tier 1!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "Upgrade to Tier 2 to unlock more features",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Navigate to Tier 2 upgrade screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NoticeId()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3F2771),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text(
            "Upgrade to Tier 2",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
class Transaction {
  final String id;
  final String type;
  final String reason;
  final double amount;
  final String currency;
  final String status;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.type,
    required this.reason,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    final attrs = json['attributes'];
    return Transaction(
      id: json['id'],
      type: json['type'],
      reason: attrs['reason'] ?? 'No reason',
      amount: (attrs['amount'] ?? 0).toDouble(),
      currency: attrs['currency'] ?? 'NGN',
      status: attrs['status'] ?? 'PENDING',
      createdAt: DateTime.parse(attrs['createdAt']),
    );
  }
}
