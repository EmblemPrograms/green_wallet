import 'package:flutter/material.dart';

import 'customerd.dart';

class InvoiceList extends StatefulWidget {
  const InvoiceList({super.key});

  @override
  _InvoiceListState createState() => _InvoiceListState();
}

class _InvoiceListState extends State<InvoiceList> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 20),
            _buildInvoiceCard(
              name: 'Anita Amadi',
              invoiceNumber: '#75RHD64FS',
              amount: '\$1000',
              date: '07/07/2024',
              status: 'Draft',
            ),
            Spacer(),
            _buildCreateNewButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search invoice',
        prefixIcon: Icon(Icons.search),
        suffixIcon: Icon(Icons.tune, color: Colors.purple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildInvoiceCard({
    required String name,
    required String invoiceNumber,
    required String amount,
    required String date,
    required String status,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF4F0FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(invoiceNumber, style: TextStyle(color: Colors.grey[700])),
                SizedBox(height: 4),
                Text(date, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.purple[800],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreateNewButton() {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CustomerDetails()),
        );
      },
      icon: Icon(Icons.add),
      label: Text('Create New'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF402978),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
