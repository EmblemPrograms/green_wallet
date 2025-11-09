import 'package:flutter/material.dart';
import 'package:green_wallet/ActionB/send/intSend1.dart';

class intSend extends StatefulWidget {
  const intSend({super.key});

  @override
  State<intSend> createState() => _intSendState();
}

class _intSendState extends State<intSend> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCountry = "";

  final List<Map<String, String>> countries = [
    {"name": "United States", "flag": "🇺🇸"},
    {"name": "United Kingdom", "flag": "🇬🇧"},
    {"name": "Uganda", "flag": "🇺🇬"},
    {"name": "Rwanda", "flag": "🇷🇼"},
    {"name": "Zambia", "flag": "🇿🇲"},
    {"name": "Cameroon", "flag": "🇨🇲"},
    {"name": "Ghana", "flag": "🇬🇭"},
    {"name": "Korea", "flag": "🇰🇷"},
  ];

  List<Map<String, String>> filteredCountries = [];

  @override
  void initState() {
    super.initState();
    filteredCountries = countries;
  }

  void _filterCountries(String query) {
    setState(() {
      filteredCountries = countries
          .where((country) =>
          country["name"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Select country",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            TextField(
              controller: _searchController,
              onChanged: _filterCountries,
              decoration: InputDecoration(
                hintText: "Type a country....",
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Available Countries",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700]),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredCountries.length,
                itemBuilder: (context, index) {
                  final country = filteredCountries[index];
                  return ListTile(
                    leading: Text(country["flag"]!, style: TextStyle(fontSize: 24)),
                    title: Text(country["name"]!, style: TextStyle(fontSize: 16)),
                    onTap: () {
                      setState(() {
                        selectedCountry = country["name"]!;
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedCountry.isNotEmpty
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IntSend1()),
                  );// Add next action logic
                }: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3F2771),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "Next",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}