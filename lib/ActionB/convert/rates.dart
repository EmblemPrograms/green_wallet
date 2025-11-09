import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services/auth_service.dart'; // adjust import path to your project

class RatesScreen extends StatefulWidget {
  const RatesScreen({super.key});

  @override
  State<RatesScreen> createState() => _RatesScreenState();
}

class _RatesScreenState extends State<RatesScreen> {
  bool _isLoading = true;
  List<dynamic> _rates = [];
  int _refreshCountdown = 30;
  Timer? _timer;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _fetchRates();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _refreshCountdown--;
      });
      if (_refreshCountdown == 0) {
        _fetchRates();
        _refreshCountdown = 30;
      }
    });
  }

  Future<void> _fetchRates() async {
    setState(() => _isLoading = true);

    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception("No token found");

      final url = Uri.parse(
          'https://greenwallet-6a1m.onrender.com/api/yolat/rates?from_currency=NGN&to_currency=USDT&token=$token');

      final response = await http.get(url, headers: {'accept': 'application/json'});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _rates = data['rates'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load rates');
      }
    } catch (e) {
      debugPrint("Error fetching rates: $e");
      setState(() => _isLoading = false);
    }
  }

  List<dynamic> get _filteredRates {
    if (_selectedFilter == 'All') return _rates;
    return _rates
        .where((r) =>
    r['sendCode'] == _selectedFilter || r['receiveCode'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Rates",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var filter in ['All', 'NGN', 'CAD', 'KES', 'GBP'])
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: _selectedFilter == filter,
                        selectedColor: const Color(0xFF3F2771),
                        onSelected: (selected) {
                          setState(() => _selectedFilter = filter);
                        },
                        labelStyle: TextStyle(
                          color: _selectedFilter == filter
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Refresh timer
            Text(
              "Rates will refresh in $_refreshCountdown seconds",
              style: const TextStyle(
                  color: Color(0xFF3F2771), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            // Rates list
            Expanded(
              child: ListView.builder(
                itemCount: _filteredRates.length,
                itemBuilder: (context, index) {
                  final rate = _filteredRates[index];
                  final from = rate['sendCode'];
                  final to = rate['receiveCode'];
                  final amount = rate['amount'];

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // _getFlagIcon(from),
                            const SizedBox(width: 2),
                            Text(
                              "$from → $to",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        Text(
                          "1 $from = $amount $to",
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 15),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getFlagIcon(String code) {
    // Basic country flag mapping
    String asset = 'assets/flags/default.png';
    switch (code) {
      case 'NGN':
        asset = 'assets/flags/ng.png';
        break;
      case 'USD':
        asset = 'assets/flags/us.png';
        break;
      case 'CAD':
        asset = 'assets/flags/ca.png';
        break;
      case 'GBP':
        asset = 'assets/flags/gb.png';
        break;
      case 'KES':
        asset = 'assets/flags/ke.png';
        break;
      case 'EUR':
        asset = 'assets/flags/eu.png';
        break;
    }
    return Image.asset(asset, width: 20, height: 20, fit: BoxFit.cover);
  }
}
