import 'package:flutter/material.dart';
import 'package:flutter_app_project/models/models.dart';
import '../data/mock_data.dart';
import '../utils/theme.dart';
import 'unit_detail_screen.dart'; // Needed so we can click into specific units from here

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFFF9F9FB);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // --- 1. SLIVER APP BAR ---
          SliverAppBar(
            expandedHeight: 280.0,
            pinned: true,
            backgroundColor: AppColors.primary,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Hero animation linking from the Home Screen
                  Hero(
                    tag: 'project_${project.id}', 
                    child: Image.network(project.imageUrl, fit: BoxFit.cover),
                  ),
                  const Positioned(
                    top: 0, left: 0, right: 0, height: 100,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter, end: Alignment.bottomCenter,
                          colors: [Colors.black54, Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- 2. MAIN CONTENT ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Verified Badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          project.name,
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.textMain, height: 1.2),
                        ),
                      ),
                      if (project.isVerified)
                        Container(
                          margin: const EdgeInsets.only(left: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: AppColors.successGreen, borderRadius: BorderRadius.circular(20)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle, size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text("Verified", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Project Type Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      project.type.toUpperCase(),
                      style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                    ),
                  ),
                  
                  const SizedBox(height: 30),

                  // --- PROJECT PROGRESS & STATS ---
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Construction Progress", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text("${(project.progress * 100).toInt()}%", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: project.progress, 
                          backgroundColor: Colors.grey[200], 
                          color: AppColors.primary, 
                          minHeight: 8, 
                          borderRadius: BorderRadius.circular(10)
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(height: 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatColumn("Total Units", "${project.totalUnits}"),
                            Container(width: 1, height: 40, color: Colors.grey.shade200),
                            _buildStatColumn("Available", "${project.availableUnits}", isHighlight: true),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- AVAILABLE UNITS SECTION ---
                  const Text("Units in this Project", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain)),
                  const SizedBox(height: 16),
                  
                  // Using our mockUnits as a placeholder for units inside this project
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    // For a real app, you would filter this: mockUnits.where((u) => u.projectId == project.id).toList()
                    itemCount: mockUnits.length, 
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildUnitCard(context, mockUnits[index]);
                    },
                  ),

                  const SizedBox(height: 100), // Bottom padding for CTA
                ],
              ),
            ),
          ),
        ],
      ),
      
      // --- BOTTOM CTA ---
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text("Contact Developer"),
          ),
        ),
      ),
    );
  }

  // Helper: Stat Column
  Widget _buildStatColumn(String label, String value, {bool isHighlight = false}) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: isHighlight ? AppColors.priceRed : AppColors.textMain)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
      ],
    );
  }

  // Helper: A compact version of the unit card specifically for this list
  Widget _buildUnitCard(BuildContext context, PropertyUnit unit) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => UnitDetailScreen(unit: unit)));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(unit.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(unit.unitCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text("\$${unit.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}", style: const TextStyle(color: AppColors.priceRed, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.hotel_outlined, size: 14, color: Colors.blueGrey),
                      const SizedBox(width: 4),
                      Text("${unit.beds} Bed", style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                      const SizedBox(width: 12),
                      const Icon(Icons.square_foot, size: 14, color: Colors.blueGrey),
                      const SizedBox(width: 4),
                      Text("${unit.area}m²", style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}