import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_project/models/models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

import '../data/mock_data.dart';
import '../utils/theme.dart'; // <--- REQUIRED FOR DRAWING CUSTOM MARKERS

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  GoogleMapController? _mapController;
  final PageController _pageController = PageController(viewportFraction: 0.85);
  
  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(11.5564, 104.9282),
    zoom: 13.0,
  );

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Replaced the old method with the new async version
    _loadCustomMarkers(); 
  }

  // --- NEW: ASYNC MARKER GENERATOR ---
  Future<void> _loadCustomMarkers() async {
    Set<Marker> tempMarkers = {};

    for (var unit in mockUnits) {
      // 1. Format the price to match the image (e.g., 150000 -> "$150k")
      String priceText = unit.price >= 1000000
          ? "\$${(unit.price / 1000000).toStringAsFixed(2)}M"
          : "\$${(unit.price / 1000).toStringAsFixed(0)}k";

      // 2. Generate the custom image bitmap
      final BitmapDescriptor customIcon = await _createCustomMarkerBitmap(priceText);

      // 3. Add to the marker set
      tempMarkers.add(
        Marker(
          markerId: MarkerId(unit.id),
          position: LatLng(unit.lat, unit.lng),
          icon: customIcon,
          // We removed the InfoWindow because the price is already on the marker!
          onTap: () {
            final index = mockUnits.indexOf(unit);
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      );
    }

    // Update the state once all markers are drawn
    setState(() {
      _markers = tempMarkers;
    });
  }

  // --- NEW: CANVAS DRAWING LOGIC FOR THE BUBBLE ---
  Future<BitmapDescriptor> _createCustomMarkerBitmap(String price) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = const Color(0xFF1E548E); // Match the blue from the image

    const double width = 160;
    const double height = 80;
    const double arrowHeight = 20;
    const double radius = 16;

    // 1. Draw the rounded rectangle
    final RRect rrect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, 0, width, height),
      const Radius.circular(radius),
    );
    canvas.drawRRect(rrect, paint);

    // 2. Draw the downward pointing triangle (arrow)
    final Path path = Path();
    path.moveTo(width / 2 - 15, height); // Left point
    path.lineTo(width / 2, height + arrowHeight); // Bottom point
    path.lineTo(width / 2 + 15, height); // Right point
    path.close();
    canvas.drawPath(path, paint);

    // 3. Draw the text inside the bubble
    final TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: price,
      style: const TextStyle(
        fontSize: 36, // Large size to stay crisp on high-res screens
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    
    // Center the text inside the rounded rectangle
    textPainter.paint(
      canvas,
      Offset((width - textPainter.width) / 2, (height - textPainter.height) / 2),
    );

    // 4. Convert the drawing into a PNG image bytes
    final ui.Picture picture = pictureRecorder.endRecording();
    final ui.Image image = await picture.toImage(width.toInt(), (height + arrowHeight).toInt());
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  void _moveCameraTo(PropertyUnit unit) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(unit.lat, unit.lng),
          zoom: 15.0, 
          tilt: 45.0, 
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: _markers, // This now holds our custom drawn markers!
            myLocationEnabled: true,
            zoomControlsEnabled: false, 
            mapToolbarEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mockUnits.isNotEmpty) _moveCameraTo(mockUnits.first);
              });
            },
          ),

          Positioned(
            top: 50, left: 20, right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: Colors.black.withValues( alpha: 0.1), blurRadius: 10)],
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(hintText: "Search areas...", border: InputBorder.none),
                    ),
                  ),
                  Icon(Icons.tune, color: AppColors.primary),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 20, left: 0, right: 0,
            height: 140, 
            child: PageView.builder(
              controller: _pageController,
              itemCount: mockUnits.length,
              onPageChanged: (int index) {
                _moveCameraTo(mockUnits[index]);
              },
              itemBuilder: (context, index) {
                return _buildMapCard(mockUnits[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapCard(PropertyUnit unit) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues( alpha: 0.08 ), 
            blurRadius: 15, 
            offset: const Offset(0, 5)
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16), 
            child: Image.network(
              unit.imageUrl, 
              width: 100, 
              height: 100, 
              fit: BoxFit.cover
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        unit.unitCode, 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textMain), 
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis
                      ),
                    ),
                    Icon(
                      unit.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: unit.isFavorite ? Colors.redAccent : Colors.blueGrey.shade300,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "\$ ${(unit.price).toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}", 
                  style: const TextStyle(color: AppColors.priceRed, fontWeight: FontWeight.bold, fontSize: 18)
                ),
                const SizedBox(height: 8),
                const Text(
                  "QUICK SPECS",
                  style: TextStyle(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      _mapSpecItem(Icons.hotel_outlined, "${unit.beds} Bed"),
                      const SizedBox(width: 12),
                      _mapSpecItem(Icons.bathtub_outlined, "${unit.baths} Bath"),
                      const SizedBox(width: 12),
                      _mapSpecItem(Icons.square_foot, "${unit.area}m²"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapSpecItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.blueGrey.shade400),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade700)),
      ],
    );
  }
}