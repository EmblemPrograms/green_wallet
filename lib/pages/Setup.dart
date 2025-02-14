import 'package:green_wallet/pages/Pin_setup.dart';
import 'package:green_wallet/widgets/textborder.dart';
import 'package:flutter/material.dart';
import 'package:green_wallet/pages/Verify.dart';
import 'package:file_picker/file_picker.dart';

import 'Startup.dart';

class Setup extends StatefulWidget {
  const Setup({super.key});

  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  final TextEditingController _dateController = TextEditingController();
  String? _selectedCountry;
  String? _selectedGender;
  String? _selectedOccupation;
  final globalKey = GlobalKey<FormState>();
  String? fileName; // Variable to hold the file name

  // Future<void> pickFile() async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles();
  //     if (result != null) {
  //       setState(() {
  //         fileName = result.files.single.name; // Get the file name
  //       });
  //     } else {
  //       // User canceled the picker
  //       print("No file selected.");
  //     }
  //   } catch (e) {
  //     print("An error occurred while picking the file: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Startup()),
            );
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 4,
              decoration: BoxDecoration(
                color: Bcolor.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: 30,
              height: 4,
              decoration: BoxDecoration(
                color: Bcolor.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: 30,
              height: 4,
              decoration: BoxDecoration(
                color: Bcolor.indicatorcolor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.headphones),
            onPressed: () {
              // Add support functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: globalKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Finish your Account Setup",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Home Address",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  validator: filltextbox,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Enter your current home address',
                    enabledBorder: Bcolor.enabledBorder,
                  ),
                ),
                SizedBox(height: 10),
                const Text(
                  "Country",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: _selectedCountry, // Replace with your variable
                  onChanged: (value) {
                    setState(() {
                      _selectedCountry = value;
                    });
                  },
                  validator: filltextbox,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: Bcolor.enabledBorder,
                  ),
                  hint: const Text('Enter country'),
                  items: ['USA', 'Canada', 'India']
                      .map((country) => DropdownMenuItem<String>(
                            value: country,
                            child: Text(country),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 10),
                const Text(
                  "State",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  validator: filltextbox,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Enter State',
                    enabledBorder: Bcolor.enabledBorder,
                  ),
                ),
                SizedBox(height: 10),
                const Text(
                  "City",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  validator: filltextbox,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Enter city',
                    enabledBorder: Bcolor.enabledBorder,
                  ),
                ),
                SizedBox(height: 10),
                const Text(
                  'Upload Utility Bill',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: fileName ?? 'Select a file to upload',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: TextButton(
                            onPressed: () async {
                              try {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();
                                if (result != null) {
                                  setState(() {
                                    fileName = result.files.single.name; // Get the file name
                                  });
                                } else {
                                  // User canceled the picker
                                  print("No file selected.");
                                }
                              } catch (e) {
                                print(
                                    "An error occurred while picking the file: $e");
                              }
                            },
                            child: const Text(
                              "Upload",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF3F2771),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                const Text(
                  "Date of Birth",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _dateController, // Bind the controller to the field
                  readOnly: true, // Prevent manual text input
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date of birth';
                    }
                    return null;
                  },
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      _dateController.text = "${selectedDate.toLocal()}".split(' ')[0]; // Format the selected date
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Select your date of birth',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Gender",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: _selectedGender, // Replace with your variable
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  validator: filltextbox,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: Bcolor.enabledBorder,
                  ),
                  hint: const Text('Select Gender'),
                  items: ['Male', 'Female', 'Other']
                      .map((gender) => DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Occupation",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: _selectedOccupation, // Replace with your variable
                  onChanged: (value) {
                    setState(() {
                      _selectedOccupation = value;
                    });
                  },
                  validator: filltextbox,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: Bcolor.enabledBorder,
                  ),
                  hint: const Text('Select Occupation'),
                  items: ['Student', 'Employee', 'Entrepreneur', 'Doctor']
                      .map((occupation) => DropdownMenuItem<String>(
                            value: occupation,
                            child: Text(occupation),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PinSetup(),
                      ),
                    );
                    // Add form submission functionality
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String? filltextbox(String? text) {
  if (text == null || text.trim().isEmpty) {
    return 'Field cannot be empty';
  }
  return null;
}
