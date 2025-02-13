import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';


class CountryCodeDropdown extends StatefulWidget {
  @override
  _CountryCodeDropdownState createState() => _CountryCodeDropdownState();
}

class _CountryCodeDropdownState extends State<CountryCodeDropdown> {
  String _selectedCountryCode = "+1"; // Default country code (USA)

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            showCountryPicker(
              context: context,
              showPhoneCode: true, // Show phone codes
              onSelect: (Country country) {
                setState(() {
                  _selectedCountryCode = "+${country.phoneCode}";
                });
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(_selectedCountryCode),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Enter phone number",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
        ),
      ],
    );
  }
}
