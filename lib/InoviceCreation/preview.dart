import 'package:flutter/material.dart';
import 'package:green_wallet/InoviceCreation/proceed.dart';

class InvoicePreview extends StatefulWidget {
  const InvoicePreview({super.key});

  @override
  State<InvoicePreview> createState() => _InvoicePreviewState();
}

class _InvoicePreviewState extends State<InvoicePreview> {
  final TextEditingController _projectController = TextEditingController(text: "Website - Landing Page Design");
  final TextEditingController _descriptionController = TextEditingController(text: "Website - Landing Page UX Refactor");
  final TextEditingController _qtyController = TextEditingController(text: "1");
  final TextEditingController _priceController = TextEditingController(text: "\$1000");
  final TextEditingController _totalController = TextEditingController(text: "\$1000");

  final TextEditingController _issuedDateController = TextEditingController(text: "12-07-2024");
  final TextEditingController _dueDateController = TextEditingController(text: "12-07-2024");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Preview", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("INV #75RHD64FS", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text("Due: 07/07/2024", style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage("assets/avatar.png"), // Replace with your image asset
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Recipient", style: TextStyle(color: Colors.grey)),
                      Text("Anita Amadi", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text("Project", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _projectController,
              decoration: _inputDecoration(),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Item", style: TextStyle(fontWeight: FontWeight.w600)),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, color: Color(0xFF3F2771)),
                  label: const Text("+ Add Item", style: TextStyle(color: Color(0xFF3F2771))),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.purple.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Description", style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _descriptionController,
                    decoration: _inputDecoration(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLabeledInput("Qty", _qtyController),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildLabeledInput("Price", _priceController),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildLabeledInput("Total", _totalController),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildLabeledInput("Issued date", _issuedDateController)),
                const SizedBox(width: 12),
                Expanded(child: _buildLabeledInput("Due date", _dueDateController)),
              ],
            ),

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Total", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("\$1000", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F2771),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                label: const Text("Proceed", style: TextStyle(fontSize: 16, color: Colors.white)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        PreviewPage()),
                  );// Proceed logic
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
    );
  }

  Widget _buildLabeledInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: _inputDecoration(),
        ),
      ],
    );
  }
}
