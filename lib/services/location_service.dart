import 'package:geolocator/geolocator.dart';

class Store {
  final String name;
  final double lat;
  final double lng;
  final String address;

  const Store({
    required this.name,
    required this.lat,
    required this.lng,
    required this.address,
  });
}

class StoreService {
  // Sementara koordinat mirota dl 
  static const List<Store> stores = [
    Store(
      name: "D'Shop – Toko 1",
      lat: -7.751614660210925,
      lng: 110.3844828462198,
      address: 'Jl. Toko 1, Yogyakarta',
    ),
    Store(
      name: "D'Shop – Toko 2",
      lat: -7.769414135913038,
      lng: 110.39058155278614,
      address: 'Jl. Toko 2, Yogyakarta',
    ),
    Store(
      name: "D'Shop – Toko 3",
      lat: -7.780408930157068,
      lng: 110.41484550093058,
      address: 'Jl. Toko 3, Yogyakarta',
    ),
    Store(
      name: "D'Shop – Toko 4",
      lat: -7.77432010224516,
      lng: 110.37455139924629,
      address: 'Jl. Toko 4, Yogyakarta',
    ),
    Store(
      name: "D'Shop – Toko 5",
      lat: -7.779422578015132,
      lng: 110.3499179921407,
      address: 'Jl. Toko 5, Yogyakarta',
    ),
  ];

  Future<List<Map<String, dynamic>>> distancesFrom(Position userPos) async {
    final list = stores.map((s) {
      final meters = Geolocator.distanceBetween(
        userPos.latitude, userPos.longitude, s.lat, s.lng,
      );
      return {
        'store': s,
        'distanceKm': meters / 1000.0,
      };
    }).toList();

    list.sort((a, b) =>
        (a['distanceKm'] as double).compareTo(b['distanceKm'] as double));
    return list;
  }
}
