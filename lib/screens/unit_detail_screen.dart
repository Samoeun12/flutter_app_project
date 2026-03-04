import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // Required for making TextSpans clickable
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_app_project/models/models.dart';

import '../utils/theme.dart'; // Ensure this points to your models

class UnitDetailScreen extends StatefulWidget {
  final PropertyUnit unit;

  const UnitDetailScreen({super.key, required this.unit});

  @override
  State<UnitDetailScreen> createState() => _UnitDetailScreenState();
}

class _UnitDetailScreenState extends State<UnitDetailScreen> {
  int _currentImageIndex = 0;
  bool _isDescriptionExpanded = false;
  late TapGestureRecognizer _readMoreRecognizer;
  
  final Color backgroundColor = const Color(0xFFF9F9FB);

  final String _fullDescription = "Experience the epitome of luxury living in this stunning modern estate. Featuring floor-to-ceiling glass walls, an infinity pool with city views, and a state-of-the-art home theater. The master suite offers unparalleled comfort with a private balcony and a spa-like bathroom. Designed by world-renowned architects, this property is a true masterpiece.";

  @override
  void initState() {
    super.initState();
    // Initialize the tap recognizer for the "Read more" text
    _readMoreRecognizer = TapGestureRecognizer()..onTap = () {
      setState(() {
        _isDescriptionExpanded = !_isDescriptionExpanded;
      });
    };
  }

  @override
  void dispose() {
    _readMoreRecognizer.dispose();
    super.dispose();
  }

  // Helper method to add commas to prices (e.g., 150000 -> 150,000)
  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},'
    );
  }

  @override
  Widget build(BuildContext context) {
    // Generate the short version of the description
    String shortDescription = _fullDescription.length > 150 
        ? "${_fullDescription.substring(0, 150)}..." 
        : _fullDescription;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // --- 1. SLIVER APP BAR (IMAGE CAROUSEL & HEADER BUTTONS) ---
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: AppColors.primary,
            elevation: 0,
            automaticallyImplyLeading: false, 
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    itemCount: widget.unit.galleryImages.length,
                    onPageChanged: (index) => setState(() => _currentImageIndex = index),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Hero(
                          tag: widget.unit.id,
                          child: Image.network(widget.unit.galleryImages[index], fit: BoxFit.cover),
                        );
                      }
                      return Image.network(widget.unit.galleryImages[index], fit: BoxFit.cover);
                    },
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

                  Positioned(
                    bottom: 16, right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${_currentImageIndex + 1}/${widget.unit.galleryImages.length}",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circularHeaderButton(Icons.arrow_back, () => Navigator.pop(context)),
                Row(
                  children: [
                    _circularHeaderButton(widget.unit.isFavorite ? Icons.favorite : Icons.favorite_border, () {}, iconColor: widget.unit.isFavorite ? Colors.red : Colors.white),
                    const SizedBox(width: 10),
                    _circularHeaderButton(Icons.share, () {}),
                  ],
                ),
              ],
            ),
          ),

          // --- 2. MAIN CONTENT ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.unit.unitCode, 
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textMain, height: 1.2),
                  ),
                  const SizedBox(height: 10),
                  
                  Row(
                    children: [
                      Icon(Icons.location_on, color: AppColors.primary, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "123 Palm Drive, Beverly Hills, CA", // Replace with unit.address if you add it to your model
                          style: TextStyle(fontSize: 14, color: AppColors.primary.withValues(alpha: 0.8), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${_formatPrice(widget.unit.price)}", // Uses the new formatting method
                        style: TextStyle(fontSize: 30, color: AppColors.primary, fontWeight: FontWeight.w900)
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.lightBlueHighlight, borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          "FOR SALE",
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Specs Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSpecCard(Icons.bed, "${widget.unit.beds}", "Beds"),
                      _buildSpecCard(Icons.bathtub, "${widget.unit.baths}", "Baths"),
                      _buildSpecCard(Icons.square_foot, "${widget.unit.area}", "Sqft"),
                      _buildSpecCard(Icons.directions_car, "3", "Cars"), 
                    ],
                  ),

                  const SizedBox(height: 30),
                  
                  // Description with Read More toggle
                  const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain)),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
                      children: [
                        TextSpan(
                          text: _isDescriptionExpanded ? _fullDescription : shortDescription,
                        ),
                        const TextSpan(text: " "),
                        TextSpan(
                          text: _isDescriptionExpanded ? "Show less" : "Read more",
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                          recognizer: _readMoreRecognizer, // Triggers the state change on tap
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Location Map
                  const Text("Location", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain)),
                  const SizedBox(height: 16),
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(target: LatLng(widget.unit.lat, widget.unit.lng), zoom: 14.0),
                        markers: {
                          Marker(
                            markerId: MarkerId(widget.unit.id),
                            position: LatLng(widget.unit.lat, widget.unit.lng),
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // Matches the blue theme
                          )
                        },
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                        scrollGesturesEnabled: false, 
                        zoomGesturesEnabled: false,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Listing Agent
                  const Text("Listing Agent", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            const CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage('https://randomuser.me/api/portraits/women/44.jpg'), 
                            ),
                            Positioned(
                              bottom: 0, right: 0,
                              child: Container(
                                width: 14, height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 16),
                        
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Sarah Connor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text("CPLAgent • Premier", style: TextStyle(fontSize: 13, color: Colors.blueGrey.shade400)),
                            ],
                          ),
                        ),
                        
                        _agentActionButton(Icons.chat_bubble_rounded),
                        const SizedBox(width: 12),
                        _agentActionButton(Icons.phone),
                      ],
                    ),
                  ),

                  // Fixed: Expanded bottom padding to prevent clipping by the bottom sheet
                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ),
        ],
      ),
      
      // --- 3. BOTTOM FIXED ACTION BAR ---
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Total Price", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                Text("\$${_formatPrice(widget.unit.price)}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.calendar_month, size: 20),
                label: const Text("Book Viewing"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circularHeaderButton(IconData icon, VoidCallback onTap, {Color iconColor = Colors.white}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3), 
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }

  Widget _buildSpecCard(IconData icon, String value, String label) {
    return Container(
      width: 75,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textMain)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _agentActionButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.lightBlueHighlight,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primary, size: 20),
    );
  }
}