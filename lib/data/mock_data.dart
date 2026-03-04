import '../models/models.dart';

// --- DUMMY DATA ---

final List<Project> mockProjects = [
  Project(
    id: 'p1',
    name: 'Borey Mekong Phase 2',
    type: 'Borey',
    imageUrl: 'https://camrealtyservice.com/wp-content/uploads/2025/10/5-bedrooms-queen-villa-for-rent-borey-mekong-royal-6a-vl5041168-2.jpg',
    totalUnits: 120,
    availableUnits: 45,
    progress: 0.65,
    isVerified: true,
  ),
  Project(
    id: 'p2',
    name: 'Royal Skyland',
    type: 'Condo',
    imageUrl: 'https://picsum.photos/seed/condo/400/200',
    totalUnits: 300,
    availableUnits: 80,
    progress: 0.90,
    isVerified: false,
  ),
];

final List<PropertyUnit> mockUnits = [
  PropertyUnit(
    id: 'u1',
    unitCode: 'Unit Code: B-405',
    type: 'Borey',
    imageUrl: 'https://picsum.photos/seed/room1/150/150', // Thumbnail
    galleryImages: [ // The carousel images!
      'https://picsum.photos/seed/room1/600/400',
      'https://picsum.photos/seed/room1b/600/400',
      'https://picsum.photos/seed/room1c/600/400',
    ],
    price: 85000,
    beds: 1,
    baths: 1,
    area: 65,
    isFavorite: false,
    lat: 11.5761, 
    lng: 104.9230,
  ),
  PropertyUnit(
    id: 'u2',
    unitCode: 'Unit Code: A-102',
    type: 'Condo',
    imageUrl: 'https://picsum.photos/seed/room2/150/150',
    galleryImages: [
      'https://picsum.photos/seed/room2/600/400',
      'https://picsum.photos/seed/room2b/600/400',
    ],
    price: 150000,
    beds: 3,
    baths: 2,
    area: 120,
    isFavorite: true,
    lat: 11.5564, 
    lng: 104.9282,
  ),
  PropertyUnit(
    id: 'u3',
    unitCode: 'Mekong Villa V-12',
    type: 'Borey',
    imageUrl: 'https://picsum.photos/seed/villa/150/150',
    galleryImages: [
      'https://picsum.photos/seed/villa/600/400',
      'https://picsum.photos/seed/villa2/600/400',
    ],
    price: 3250000, 
    beds: 4, 
    baths: 5, 
    area: 250,
    lat: 11.5900, 
    lng: 104.9500,
  ),
];


final List<Booking> mockBookings = [
  Booking(
    id: 'b1',
    unit: mockUnits[0], 
    // Set to TODAY at 10:30 AM
    date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 30), 
    status: 'Confirmed',
  ),
  Booking(
    id: 'b2',
    unit: mockUnits[1], 
    // Set to TODAY at 2:00 PM (14:00)
    date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 14, 0), 
    status: 'Pending',
  ),
  Booking(
    id: 'b3',
    unit: mockUnits[2], 
    // Set to TOMORROW at 9:00 AM
    date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, 9, 0), 
    status: 'Confirmed',
  ),
];