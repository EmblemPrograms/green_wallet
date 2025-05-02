import 'package:flutter/material.dart';
import 'package:green_wallet/widgets/textborder.dart';

class Kin extends StatefulWidget {
  @override
  _KinState createState() => _KinState();
}

class _KinState extends State<Kin> {
  final _formKey = GlobalKey<FormState>();
  String? _firstName;
  String? _lastName;
  String? _relationship;
  String? _email;
  String? _phone;

  final List<String> _relationshipOptions = [
    'Parent',
    'Sibling',
    'Spouse',
    'Friend',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next of Kin'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('First Name', onSaved: (val) => _firstName = val),
              _buildTextField('Last Name', onSaved: (val) => _lastName = val),
              _buildDropdown(),
              _buildTextField('Email Address', onSaved: (val) => _email = val),
              _buildTextField('Phone Number', onSaved: (val) => _phone = val),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF402978),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Save Update',
                    style: TextStyle(
                        fontSize: 16,
                    color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {required Function(String?) onSaved}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: Bcolor.enabledBorder,
        ),
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Relationship',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: Bcolor.enabledBorder,
        ),
        value: _relationship,
        items: _relationshipOptions.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (val) {
          setState(() {
            _relationship = val;
          });
        },
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Handle the save logic (e.g., API call, local storage)
      print('Saved: $_firstName, $_lastName, $_relationship, $_email, $_phone');
    }
  }
}
