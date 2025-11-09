import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/auth_service.dart';


class BankList extends StatefulWidget {
  const BankList({super.key});

  @override
  State<BankList> createState() => _BankListState();
}

class _BankListState extends State<BankList> {
  List<dynamic> _banks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBanks();
  }

  Future<void> _loadBanks() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cachedBanks');

    if (cachedData != null) {
      // Load cached banks
      setState(() {
        _banks = jsonDecode(cachedData);
        _isLoading = false;
      });
    } else {
      // Fetch from API
      await _fetchBanksFromApi();
    }
  }

  Future<void> _fetchBanksFromApi() async {
    const String url = "https://greenwallet-6a1m.onrender.com/api/transactions/banks";

    try {
      final token = await AuthService.getToken(); // get the dynamic token
      final response = await http.get(Uri.parse("$url?token=$token"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<dynamic> banks = data["banks"]
            .map((b) => {
          "name": b["attributes"]["name"],
          "nipCode": b["attributes"]["nipCode"],
        })
            .toList();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cachedBanks', jsonEncode(banks));

        setState(() {
          _banks = banks;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load banks');
      }
    } catch (e) {
      debugPrint("Error fetching banks: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Select Bank"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('cachedBanks');
              setState(() {
                _isLoading = true;
              });
              await _fetchBanksFromApi();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF3F2771)))
          : ListView.separated(
        itemCount: _banks.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final bank = _banks[index];
          return ListTile(
            title: Text(bank["name"]),
            onTap: () {
              Navigator.pop(context, bank["name"]);
            },
          );
        },
      ),
    );
  }
}
