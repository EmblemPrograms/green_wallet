import 'package:flutter/material.dart';
import 'package:green_wallet/Card/Invoice.dart';

class CustomerDetails extends StatefulWidget {
  const CustomerDetails({super.key});

  @override
  _CustomerDetailsState createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  final String customerName = 'Anita Amadi';
  final String customerEmail = 'Anitamadi@gmail.com';
  final String billingAddress = 'N/A';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildCustomerCard(),
            Spacer(),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFFF9F8FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Name of customer', customerName),
          Divider(),
          _buildDetailRow('Email of customer', customerEmail),
          Divider(),
          _buildDetailRow('Billing address', billingAddress),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700])),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InvoiceP()),
        ); // Handle continue action
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF402978),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16),
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text('Continue'),
    );
  }
}
