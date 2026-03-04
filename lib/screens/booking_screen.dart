import 'package:flutter/material.dart';
import 'package:flutter_app_project/models/models.dart';
import '../data/mock_data.dart';
import '../utils/theme.dart';
import 'unit_detail_screen.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Filter our mock bookings into two lists
    final activeBookings = mockBookings.where((b) => b.status == 'Pending' || b.status == 'Confirmed').toList();
    final pastBookings = mockBookings.where((b) => b.status == 'Completed' || b.status == 'Cancelled').toList();

    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text("MY BOOKINGS"),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Active Bookings
            _buildBookingList(activeBookings),
            
            // Tab 2: Past Bookings
            _buildBookingList(pastBookings),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(List<Booking> bookings) {
    if (bookings.isEmpty) {
      return const Center(
        child: Text("No bookings found.", style: TextStyle(color: Colors.grey, fontSize: 16)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildBookingCard(context, bookings[index]);
      },
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking) {
    // Determine the color of the status badge
    Color statusColor;
    if (booking.status == 'Confirmed') {
      statusColor = const Color(0xFF2E7D32); // Green
    } else if (booking.status == 'Pending') {
      statusColor = const Color(0xFFE65100); // Orange
    } else if (booking.status == 'Cancelled') {
      statusColor = const Color(0xFFD32F2F); // Red
    } else {
      statusColor = Colors.blueGrey; // Completed
    }

    // Format the date simply (e.g., 2026-03-05)
    String formattedDate = "${booking.date.year}-${booking.date.month.toString().padLeft(2, '0')}-${booking.date.day.toString().padLeft(2, '0')}";

    return GestureDetector(
      onTap: () {
        // Tapping the booking takes them to the property details
        Navigator.push(context, MaterialPageRoute(builder: (context) => UnitDetailScreen(unit: booking.unit)));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(booking.unit.imageUrl, width: 90, height: 90, fit: BoxFit.cover),
            ),
            const SizedBox(width: 16),
            
            // Booking Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row: Unit Code and Status Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          booking.unit.unitCode,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textMain),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          booking.status.toUpperCase(),
                          style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  
                  // Property Price
                  Text(
                    "\$${booking.unit.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  
                  // Viewing Date Details
                  Row(
                    children: [
                      Icon(Icons.calendar_month, size: 16, color: Colors.blueGrey.shade400),
                      const SizedBox(width: 6),
                      Text(
                        "Viewing: $formattedDate",
                        style: TextStyle(fontSize: 13, color: Colors.blueGrey.shade700, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}