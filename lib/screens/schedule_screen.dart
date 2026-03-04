import 'package:flutter/material.dart';
import 'package:flutter_app_project/models/models.dart';
import '../data/mock_data.dart';
import '../utils/theme.dart';
import 'unit_detail_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final Color primaryBlue = AppColors.primary;
  late DateTime _selectedDate;
  
  // Generate a list of 30 days starting from today for the calendar strip
  late List<DateTime> _dateList;

  @override
  void initState() {
    super.initState();
    // Start with today selected (stripping out the time so midnight matches)
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    
    // Generate 15 days in the past and 30 days in the future
    _dateList = List.generate(45, (index) {
      return DateTime(now.year, now.month, now.day).add(Duration(days: index - 15));
    });
  }

  // Helper to get abbreviated day names (e.g., "Mon")
  String _getShortDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  // Helper to format time (e.g., "10:00 AM")
  String _formatTime(DateTime date) {
    int hour = date.hour > 12 ? date.hour - 12 : date.hour;
    if (hour == 0) hour = 12;
    String minute = date.minute.toString().padLeft(2, '0');
    String amPm = date.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute $amPm";
  }

  @override
  Widget build(BuildContext context) {
    // Filter bookings to only show ones matching the currently selected date
    final dailyBookings = mockBookings.where((booking) {
      return booking.date.year == _selectedDate.year &&
             booking.date.month == _selectedDate.month &&
             booking.date.day == _selectedDate.day;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("MY SCHEDULE"),
      ),
      body: Column(
        children: [
          // --- 1. HORIZONTAL CALENDAR STRIP ---
          Container(
            color: primaryBlue,
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            child: SizedBox(
              height: 85,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                // Start the list scrolled roughly to "Today"
                controller: ScrollController(initialScrollOffset: 15 * 65.0), 
                itemCount: _dateList.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final date = _dateList[index];
                  final isSelected = date == _selectedDate;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 60,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent, 
                          width: 2
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getShortDayName(date.weekday),
                            style: TextStyle(
                              color: isSelected ? primaryBlue : Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${date.day}",
                            style: TextStyle(
                              color: isSelected ? primaryBlue : Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // --- 2. TIMELINE LIST ---
          Expanded(
            child: dailyBookings.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: dailyBookings.length,
                    itemBuilder: (context, index) {
                      return _buildTimelineCard(dailyBookings[index], isLast: index == dailyBookings.length - 1);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --- UI: TIMELINE EVENT CARD ---
  Widget _buildTimelineCard(Booking booking, {required bool isLast}) {
    Color statusColor = booking.status == 'Confirmed' ? AppColors.successGreen : const Color(0xFFE65100);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Side: Time & Timeline Line
          SizedBox(
            width: 70,
            child: Column(
              children: [
                Text(
                  _formatTime(booking.date),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: isLast
                      ? const SizedBox.shrink()
                      : Container(width: 2, color: Colors.grey.shade300), // The vertical line
                ),
              ],
            ),
          ),
          
          // Right Side: The Event Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UnitDetailScreen(unit: booking.unit)));
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              booking.status.toUpperCase(),
                              style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Icon(Icons.more_horiz, color: Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Viewing: ${booking.unit.unitCode}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textMain),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "${booking.unit.type} • \$${booking.unit.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                              style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Agent Row
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 14,
                            backgroundImage: NetworkImage('https://randomuser.me/api/portraits/women/44.jpg'),
                          ),
                          const SizedBox(width: 8),
                          const Text("Sarah Connor", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
                            child: const Icon(Icons.chat_bubble_outline, size: 14, color: AppColors.primary),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI: EMPTY STATE ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20)],
            ),
            child: Icon(Icons.event_busy, size: 48, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 24),
          const Text(
            "No schedules today",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
          ),
          const SizedBox(height: 8),
          const Text(
            "Take a break, you have no viewings\nscheduled for this date.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }
}