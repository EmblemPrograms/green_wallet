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