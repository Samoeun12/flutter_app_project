// --- DATA MODELS ---

class Project {
  final String id;
  final String name;
  final String type; // e.g., 'Borey', 'Condo'
  final String imageUrl;
  final int totalUnits;
  final int availableUnits;
  final double progress; 
  final bool isVerified;

  Project({
    required this.id,
    required this.name,
    required this.type,
    required this.imageUrl,
    required this.totalUnits,
    required this.availableUnits,
    required this.progress,
    this.isVerified = false,
  });
}

class PropertyUnit {
  final String id;
  final String unitCode;
  final String type; // e.g., 'Borey', 'Condo'
  final String imageUrl; // Small thumbnail for lists
  final List<String> galleryImages; // <-- USED FOR THE DETAIL SCREEN CAROUSEL
  final double price;
  final int beds;
  final int baths;
  final int area; // in square meters
  final bool isFavorite;
  final double lat; // <-- USED FOR GOOGLE MAPS
  final double lng; // <-- USED FOR GOOGLE MAPS

  PropertyUnit({
    required this.id,
    required this.unitCode,
    required this.type,
    required this.imageUrl,
    required this.galleryImages,
    required this.price,
    required this.beds,
    required this.baths,
    required this.area,
    this.isFavorite = false,
    required this.lat,
    required this.lng,
  });
}

class Booking {
  final String id;
  final PropertyUnit unit;
  final DateTime date;
  final String status; // e.g., 'Pending', 'Confirmed', 'Completed', 'Cancelled'

  Booking({
    required this.id,
    required this.unit,
    required this.date,
    required this.status,
  });
}
