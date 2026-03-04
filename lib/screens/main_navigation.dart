import 'package:flutter/material.dart';
import 'package:flutter_app_project/screens/explore_screen.dart'; 
import '../utils/theme.dart';
import '../widgets/home_content.dart';
import 'booking_screen.dart';
import 'profile_screen.dart';
import 'schedule_screen.dart';
import 'package:flowbite_icons/flowbite_icons.dart';

class RealEstateHome extends StatefulWidget {
  const RealEstateHome({super.key});

  @override
  State<RealEstateHome> createState() => _RealEstateHomeState();
}

class _RealEstateHomeState extends State<RealEstateHome> {
  int _currentIndex = 0;

  // List of screens for the Bottom Navigation Bar
  final List<Widget> _screens = [
    const HomeContent(), 
    const ExploreScreen(), 
    const BookingScreen(),
    const ScheduleScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      items: const [
        BottomNavigationBarItem(
          icon: FlowbiteIcon(FlowbiteOutlineIcons.home), 
          activeIcon: FlowbiteIcon(FlowbiteSolidIcons.home), // Filled when selected
          label: "Home"
        ),
        BottomNavigationBarItem(
          // map_pin or compass are great Flowbite alternatives for explore
          icon: FlowbiteIcon(FlowbiteOutlineIcons.map_pin), 
          activeIcon: FlowbiteIcon(FlowbiteSolidIcons.map_pin), 
          label: "Explore"
        ),
        BottomNavigationBarItem(
          icon: FlowbiteIcon(FlowbiteOutlineIcons.calendar_month), 
          activeIcon: FlowbiteIcon(FlowbiteSolidIcons.calendar_month), 
          label: "Booking"
        ),
        BottomNavigationBarItem(
          icon: FlowbiteIcon(FlowbiteOutlineIcons.clipboard_list), 
          activeIcon: FlowbiteIcon(FlowbiteSolidIcons.clipboard_list), 
          label: "Appointments"
        ),
        BottomNavigationBarItem(
          icon: FlowbiteIcon(FlowbiteOutlineIcons.user), 
          activeIcon: FlowbiteIcon(FlowbiteSolidIcons.user), 
          label: "Profile"
        ),
      ],
    );
  }
}
