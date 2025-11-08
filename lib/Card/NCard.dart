import 'package:flutter/material.dart';
import '../services/cardid_service.dart';
import '../services/auth_service.dart';
import '../widgets/Navigation_bar.dart';
import 'Create_card.dart';
import 'Invoice.dart';
import 'Profile.dart';
import 'card_details.dart';
import 'homepage.dart'; // 👈 Create this new file

class Ncard extends StatefulWidget {
  const Ncard({super.key});

  @override
  State<Ncard> createState() => _NcardState();
}

class _NcardState extends State<Ncard> {
  int _selectedIndex = 1;

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
      const Invoice(),
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

class MyCardsPage extends StatefulWidget {
  const MyCardsPage({super.key});

  @override
  State<MyCardsPage> createState() => _MyCardsPageState();
}

class _MyCardsPageState extends State<MyCardsPage> {
  List<Map<String, dynamic>> _cards = [];
  String _fullName = "";
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ✅ Load user full name and cards
  Future<void> _loadUserData() async {
    try {
      final name = await AuthService.getFullName();
      final cards = await CardIdService.getUserCards();

      setState(() {
        _fullName = name ?? "User";
        _cards = cards;
        _loading = false;
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'My Cards',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF3F2771),
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _cards.isEmpty
                ? const Center(child: Text('No cards found'))
                : ListView.builder(
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CardDetailsPage(
                          cardId: card['card_id'], // ✅ Pass the selected card ID dynamically
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.credit_card,
                          color: Colors.purple),
                      title: Text('Card Name: $_fullName'),
                      subtitle: Text(
                        'Currency: ${card['currency']}\nLimit: ${card['card_limit']}',
                      ),
                      trailing:
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateCard(),
                  ),
                ).then((_) => _loadUserData()); // Refresh list after creating a card
              },
              icon: const Icon(Icons.add),
              label: const Text("Create Card"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F2771),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
