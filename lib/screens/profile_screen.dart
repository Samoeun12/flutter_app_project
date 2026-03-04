import 'package:flutter/material.dart';
import 'package:flowbite_icons/flowbite_icons.dart';
import '../utils/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // --- 1. PROFILE HEADER ---
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "MY PROFILE",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 1.0),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      // Avatar with Edit Icon
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                            child: const CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'),
                            ),
                          ),
                          Positioned(
                            bottom: 0, right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: Icon(Icons.edit, size: 14, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      
                      // User Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Alex Chen", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text("alex.chen@example.com", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
                            const SizedBox(height: 10),
                            
                            // --- UPDATED: Read-only Badges Row (Verified & User Type) ---
                            Wrap(
                              spacing: 8, // Space between badges horizontally
                              runSpacing: 8, // Space between badges vertically if they wrap
                              children: [
                                // 1. Verified Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FlowbiteIcon(FlowbiteSolidIcons.badge_check, size: 14, color: Colors.greenAccent),
                                      SizedBox(width: 4),
                                      Text("Verified", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                // 2. User Type Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.person, size: 14, color: Colors.white70),
                                      SizedBox(width: 4),
                                      Text("CPL Agent", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),

          // --- 2. MAIN MENU SETTINGS ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildQuickStat(Icons.favorite, "Saved", "12"),
                      _buildQuickStat(Icons.visibility, "Viewed", "45"),
                      _buildQuickStat(Icons.rate_review, "Reviews", "3"),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  const Text("ACCOUNT SETTINGS", style: TextStyle(fontSize: 13, color: Colors.blueGrey, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 12),
                  
                  // Settings Group 1
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      children: [
                        _buildMenuOption(Icons.person_outline, "Personal Information"),
                        _buildDivider(),
                        _buildMenuOption(Icons.payment, "Payment Methods"),
                        _buildDivider(),
                        _buildMenuOption(Icons.notifications_none, "Notifications"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Text("PREFERENCES & SUPPORT", style: TextStyle(fontSize: 13, color: Colors.blueGrey, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 12),
                  
                  // Settings Group 2
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      children: [
                        _buildMenuOption(Icons.language, "Language", trailingText: "English"),
                        _buildDivider(),
                        _buildMenuOption(Icons.dark_mode_outlined, "Dark Mode", isToggle: true),
                        _buildDivider(),
                        _buildMenuOption(Icons.help_outline, "Help Center & FAQ"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  
                  // Log Out Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.priceRed, // Red text
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.priceRed.withValues( alpha: 0.5)),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: const Text("Log Out"),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget: Quick Stats
  Widget _buildQuickStat(IconData icon, String label, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.textMain)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // Helper Widget: Menu Option Row
  Widget _buildMenuOption(IconData icon, String title, {String? trailingText, bool isToggle = false}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textMain)),
      trailing: isToggle 
        ? Switch(value: false, onChanged: (val) {}, activeThumbColor: AppColors.primary)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailingText != null)
                Text(trailingText, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
              if (trailingText != null) const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
      onTap: () {},
    );
  }

  // Helper Widget: Subtle Divider between list items
  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey.shade100, indent: 60, endIndent: 20);
  }
}