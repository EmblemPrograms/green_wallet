import 'package:flutter/material.dart';
import 'package:green_wallet/InoviceCreation/sendN.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({super.key});

  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Preview', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('INV #75RHD64FS',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 4),
          Text('Due: 07/07/2024', style: TextStyle(color: Colors.grey[600])),
          SizedBox(height: 20),
          _buildUserCard(),
          SizedBox(height: 20),
          _buildItemSection(title: 'Item Details', items: [
            _buildItemRow('Landing page', 'Qty 2*500', '\$1000'),
            _buildItemRow('Mobile App', 'Qty 1*2000', '\$2000'),
          ]),
          SizedBox(height: 10),
          _buildItemSection(title: 'Items Details', items: [
            _buildSummaryRow('Subtotal', '\$3000'),
            _buildSummaryRow('Tax 10%', '\$300'),
            _buildSummaryRow('Admin', '\$100'),
          ]),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Color(0xFFF4F0FB),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('\$2600', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.add),
            label: Text('Add Item'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF4F0FB),
              foregroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        color: Color(0xFFF4F0FB),
        child: Row(
          children: [
            _bottomIconButton(Icons.copy, () {}),
            SizedBox(width: 10),
            _bottomIconButton(Icons.share, () {}),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InvoiceList()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF402978),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Send now',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.arrow_forward),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage:
                AssetImage('assets/avatar.png'), // Replace with your asset
            radius: 20,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ordered by', style: TextStyle(color: Colors.grey)),
              Text('Abdul Gafar',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemSection(
      {required String title, required List<Widget> items}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Edit', style: TextStyle(color: Colors.red)),
          ],
        ),
        Divider(thickness: 1, color: Colors.grey[300], height: 20),
        ...items,
      ],
    );
  }

  Widget _buildItemRow(String name, String qty, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: TextStyle(fontWeight: FontWeight.w500)),
            Text(qty, style: TextStyle(color: Colors.grey)),
          ]),
          Text(price, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }

  Widget _bottomIconButton(IconData icon, VoidCallback onTap) {
    return Ink(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: CircleBorder(),
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onTap,
      ),
    );
  }
}
