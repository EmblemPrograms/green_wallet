import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 70,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBottomNavItem(Icons.home_rounded, "Home", 0),
            _buildBottomNavItem(Icons.credit_card, "Card", 1),
            _buildBottomNavItem(Icons.edit_calendar_rounded, "Invoice", 2),
            _buildBottomNavItem(Icons.account_balance, "Account", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    return Expanded(
      child: InkWell(
        onTap: () => onItemSelected(index), // Pass selected index to parent
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 27,
              color: selectedIndex == index
                  ? const Color(0xFF3F2771)
                  : Colors.grey,
            ),
            const SizedBox(height: 2), // Reduce spacing between icon & text
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: selectedIndex == index
                    ? const Color(0xFF3F2771)
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:green_wallet/Card/Invoice.dart';
// import 'package:green_wallet/Card/VCard.dart';
// import 'package:green_wallet/Card/Profile.dart';
// import 'package:green_wallet/Card/hompage.dart';
//
// class BottomNavBar extends StatefulWidget {
//   final int selectedIndex;
//   final ValueChanged<int> onItemSelected;
//   const BottomNavBar({super.key,
//     required this.selectedIndex,
//     required this.onItemSelected,});
//
//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }
//
// class _BottomNavBarState extends State<BottomNavBar> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: BottomAppBar(
//         height: 70,
//         shape: const CircularNotchedRectangle(),
//         // Adds notch for FloatingActionButton
//         notchMargin: 8.0,
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 2),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildBottomNavItem(Icons.home_rounded, "Home", 0),
//               _buildBottomNavItem(Icons.credit_card, "Card", 1),
//               _buildBottomNavItem(Icons.edit_calendar_rounded, "Invoice", 2),
//               _buildBottomNavItem(Icons.account_balance, "Account", 3),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBottomNavItem(IconData icon, String label, int index) {
//     return Expanded(
//       child: InkWell(
//         onTap: () {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               size: 28,
//               icon,
//               color: _selectedIndex == index
//                   ? const Color(0xFF3F2771)
//                   : Colors.grey,
//             ),
//             const SizedBox(height: 0),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//                 color: _selectedIndex == index
//                     ? const Color(0xFF3F2771)
//                     : Colors.grey,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
