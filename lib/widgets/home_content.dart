import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/models.dart';
import '../screens/project_detail_screen.dart';
import '../screens/unit_detail_screen.dart';
import '../utils/theme.dart';
import 'package:flowbite_icons/flowbite_icons.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {

  String _selectedType = 'All'; 
  RangeValues _priceRange = const RangeValues(0, 5000000); 

  List<Project> _filteredProjects = [];
  List<PropertyUnit> _filteredUnits = [];

  @override
  void initState() {
    super.initState();
    _applyFilters(_selectedType, _priceRange);
  }

  void _applyFilters(String type, RangeValues range) {
    setState(() {
      _selectedType = type;
      _priceRange = range;

      _filteredProjects = mockProjects.where((project) {
        // NEW: If 'All' is selected, automatically return true for the type check
        return type == 'All' || project.type.toLowerCase() == type.toLowerCase();
      }).toList();

      _filteredUnits = mockUnits.where((unit) {
        // NEW: Check if 'All' is selected OR if the types match
        final matchesType = type == 'All' || unit.type.toLowerCase() == type.toLowerCase();
        final matchesPrice = unit.price >= range.start && unit.price <= range.end;
        return matchesType && matchesPrice;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                // --- PROJECTS LIST ---
                if (_filteredProjects.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: Text("No projects found for this filter.", style: TextStyle(color: Colors.grey))),
                  )
                else
                  SizedBox(
                    height: 370, 
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredProjects.length, 
                      itemBuilder: (context, index) {
                        return _buildProjectCard(_filteredProjects[index]); 
                      },
                    ),
                  ),

                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Text(
                    "Recently Added",
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                
                // --- UNITS LIST ---
                if (_filteredUnits.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: Text("No units found in this price range.", style: TextStyle(color: Colors.grey))),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    itemCount: _filteredUnits.length, 
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildRecentlyAddedCardDetail(context, _filteredUnits[index]); 
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
      color: AppColors.primary,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "HOME",
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1.2),
              ),
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
                child: const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.15),
                    hintText: "SEARCH PROJECT OR LOCATION...",
                    hintStyle: const TextStyle(color: Colors.white60, fontSize: 12),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _showFilterSheet(context),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white70),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // FIX 1: The chips now check the `_selectedType` state dynamically
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _categoryChip("All", active: _selectedType == "All", hasNotification: true),
              _categoryChip("Borey", active: _selectedType == "Borey"),
              _categoryChip("Condo", active: _selectedType == "Condo"),
              _categoryChip("Land", active: _selectedType == "Land"),
              _categoryChip("Warehouse", active: _selectedType == "Warehouse"),
            ],
          )
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    String tempSelectedType = _selectedType;
    RangeValues tempPriceRange = _priceRange;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Search Filter", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  const Text("Property Type", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: ['All', 'Borey', 'Condo', 'Land', 'Warehouse'].map((String type) {
                      return FilterChip(
                        label: Text(type),
                        selected: tempSelectedType == type,
                        selectedColor: AppColors.primary.withValues(alpha: 0.15),
                        checkmarkColor: AppColors.primary,
                        onSelected: (bool selected) {
                          setModalState(() {
                            tempSelectedType = type; 
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Budget Range (\$)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        "\$${_formatPrice(tempPriceRange.start)} - \$${_formatPrice(tempPriceRange.end)}",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      )
                    ],
                  ),
                  RangeSlider(
                    values: tempPriceRange, 
                    min: 0, 
                    max: 5000000, 
                    divisions: 100, 
                    activeColor: AppColors.primary, 
                    inactiveColor: AppColors.primary.withValues(alpha: 0.15), 
                    onChanged: (RangeValues values) {
                      setModalState(() {
                        tempPriceRange = values; 
                      });
                    }
                  ),
                  const SizedBox(height: 30),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _applyFilters(tempSelectedType, tempPriceRange);
                        Navigator.pop(context); 
                      },
                      child: const Text("Apply Filter"),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  // FIX 2: Added GestureDetector so tapping the chip actually updates the lists
  Widget _categoryChip(String label, {bool active = false, bool hasNotification = false}) {
    return GestureDetector(
      onTap: () => _applyFilters(label, _priceRange), // <-- This triggers the update!
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: active ? Colors.blue.withValues(alpha: 0.3) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: active ? FontWeight.bold : FontWeight.normal),
            ),
          ),
          if (hasNotification)
            const Positioned(top: 4, right: 4, child: CircleAvatar(radius: 4, backgroundColor: Colors.red)),
        ],
      ),
    );
  }

  // --- UPDATED PROJECT CARD IN homescreen.dart ---
  Widget _buildProjectCard(Project project) {
    // 1. Removed the outer GestureDetector from here!
    return Container(
      width: 310,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // 2. Wrapped ONLY the Image (and badge) in a GestureDetector
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectDetailScreen(project: project),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Hero(
                    tag: 'project_${project.id}', 
                    child: Image.network(project.imageUrl, height: 190, width: double.infinity, fit: BoxFit.cover),
                  ),
                  if (project.isVerified) 
                    Positioned(
                      top: 10, right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFF2E7D32), borderRadius: BorderRadius.circular(20)),
                        child: const Row(
                          children: [
                            FlowbiteIcon(FlowbiteSolidIcons.badge_check, size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text("CPL Verified", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // 3. The bottom text details are no longer clickable
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.primary)),
                const SizedBox(height: 4),
                Text(
                  "UNITS: ${project.totalUnits} | AVAILABLE: ${project.availableUnits} | PROGRESS: ${(project.progress * 100).toInt()}%", 
                  style: const TextStyle(color: Colors.black54, fontSize: 11)
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: project.progress, backgroundColor: Colors.grey[200], color: AppColors.primary, minHeight: 6, borderRadius: BorderRadius.circular(10)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      // Schedule Visit button (not wired up to navigate yet)
                      child: _actionButton("Schedule Visit", isPrimary: true)
                    ),
                    const SizedBox(width: 8),
                    
                    // 4. View Detail button is still clickable!
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                           Navigator.push(
                             context, 
                             MaterialPageRoute(
                               builder: (context) => ProjectDetailScreen(project: project)
                             )
                           );
                        },
                        child: _actionButton("View Detail", isPrimary: false)
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _actionButton(String title, {required bool isPrimary}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.primary : Colors.white,
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          color: isPrimary ? Colors.white : AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildRecentlyAddedCardDetail(BuildContext context, PropertyUnit unit) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UnitDetailScreen(unit: unit),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12), 
              child: Hero(
                tag: unit.id, 
                child: Image.network(unit.imageUrl, width: 100, height: 100, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 16), 
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded( 
                        child: Text(
                          unit.unitCode, 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A1A1A)), 
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        unit.isFavorite ? Icons.favorite : Icons.favorite_border, 
                        size: 20, 
                        color: unit.isFavorite ? Colors.redAccent : AppColors.primary.withValues(alpha: 0.5)
                      ),
                    ],
                  ),
                  const SizedBox(height: 4), 
                  Text("\$ ${(unit.price).toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}", style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w800, fontSize: 18)),
                  const SizedBox(height: 10),
                  const Text(
                    "QUICK SPECS", 
                    style: TextStyle(fontSize: 11, color: Colors.blueGrey, letterSpacing: 0.5, fontWeight: FontWeight.bold) 
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        _specItem(Icons.hotel_outlined, "${unit.beds} Bed"), 
                        const SizedBox(width: 12),
                        _specItem(Icons.bathtub_outlined, "${unit.baths} Bath"), 
                        const SizedBox(width: 12),
                        _specItem(Icons.square_foot, "${unit.area}m²"), 
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return "${(price / 1000000).toStringAsFixed(1)}M";
    } else {
      return "${(price / 1000).toStringAsFixed(0)}k";
    }
  }

  Widget _specItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min, 
      children: [
        Icon(icon, size: 14, color: Colors.blueGrey), 
        const SizedBox(width: 4), 
        Text(
          text, 
          style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500) 
        ), 
      ],
    );
  }
}