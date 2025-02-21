import 'package:flutter/material.dart';
import 'package:green_wallet/widgets/textborder.dart';
import 'package:green_wallet/InoviceCreation/Create_invoice2.dart';

class CreateInvoice1 extends StatefulWidget {
  const CreateInvoice1({super.key});

  @override
  State<CreateInvoice1> createState() => _CreateInvoice1State();
}

class _CreateInvoice1State extends State<CreateInvoice1> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController(text: "12-07-2024");
  final TextEditingController _dueDateController = TextEditingController(text: "12-07-2024");

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Card Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step Indicator
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _stepIndicator(true),
                    _stepIndicator(false, isCurrentStep: true, stepText: "2"),
                    const SizedBox(width: 5),
                    const Text(
                      "Receiving account details",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 38),
                    _stepIndicator(false, stepText: "3"),

                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Input Fields
              _buildLabel("Amount"),
              _buildTextField("Amount to be received", _amountController),

              const SizedBox(height: 16),
              _buildLabel("Issue Date"),
              _buildDateField(_issueDateController, "When do you want to issue your invoice?"),

              const SizedBox(height: 16),
              _buildLabel("Invoice Due Date"),
              _buildDateField(_dueDateController, "When will your invoice be due for payment?"),

              const SizedBox(height: 16),
              _buildLabel("Add Product"),
              _buildProductField(),

              const SizedBox(height: 110),

              // Next Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F2771),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateInvoice2()),);
                  },
                  child: const Text("Next", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: Bcolor.enabledBorder,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today, color: Color(0xFF3F2771)),
              onPressed: () => _selectDate(context, controller),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: Bcolor.enabledBorder,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          hintText,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildProductField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Add your first product", style: TextStyle(color: Colors.grey)),
          IconButton(
            icon: const Icon(Icons.add_circle, color: Color(0xFF3F2771)),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => CustomDialogWidget(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _stepIndicator(bool isCompleted, {bool isCurrentStep = false, String? stepText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: CircleAvatar(
        radius: 14,
        backgroundColor: isCurrentStep
            ? const Color(0xFF3F2771)
            : (isCompleted ? const Color(0xFF3F2771) : const Color(0xFFE0E0E0)),
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : Text(
          stepText ?? "",
          style: TextStyle(
            color: isCurrentStep ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class CustomDialogWidget extends StatefulWidget {
  const CustomDialogWidget({super.key});

  @override
  State<CustomDialogWidget> createState() => _CustomDialogWidgetState();
}

class _CustomDialogWidgetState extends State<CustomDialogWidget> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController(text: '0');
  final TextEditingController amountController = TextEditingController(text: '0.00');

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add Products",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Product Name Field
              const Text("Product Name"),
              const SizedBox(height: 5),
              TextField(
                controller: productNameController,
                decoration: InputDecoration(
                  hintText: "Enter product name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: Bcolor.enabledBorder,
                ),
              ),
              const SizedBox(height: 15),

              // Description Field
              const Text("Description"),
              const SizedBox(height: 5),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: "Enter product name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: Bcolor.enabledBorder,
                ),
              ),
              const SizedBox(height: 15),

              // Quantity Field
              const Text("Quantity"),
              const SizedBox(height: 5),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: Bcolor.enabledBorder,
                ),
              ),
              const SizedBox(height: 15),

              // Amount Per Quantity Field
              const Text("Amount Per Quantity"),
              const SizedBox(height: 5),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: Bcolor.enabledBorder,
                ),
              ),
              const SizedBox(height: 20),

              // Add Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle add product action here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F2771), // Purple color
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Add",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}