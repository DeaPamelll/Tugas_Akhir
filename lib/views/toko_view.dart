import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tugas_akhir/services/location_service.dart';
import 'widgets/header_widget.dart';

class TokoView extends StatefulWidget {
  const TokoView({super.key});

  @override
  State<TokoView> createState() => _TokoViewState();
}

class _TokoViewState extends State<TokoView> {
  final _service = StoreService();
  final MapController _mapController = MapController();

  Position? _userPos;
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _storeDistances = [];

  static const rose = Color(0xFFE8A0BF);

  List<Map<String, dynamic>> get _top2Stores =>
      _storeDistances.length >= 2 ? _storeDistances.take(2).toList() : _storeDistances;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) throw 'Layanan lokasi (GPS) tidak aktif';

      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) throw 'Izin lokasi ditolak';
      }
      if (perm == LocationPermission.deniedForever) {
        throw 'Izin lokasi ditolak permanen (deniedForever)';
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final distances = await _service.distancesFrom(pos);
      distances.sort((a, b) =>
          (a['distanceKm'] as double).compareTo(b['distanceKm'] as double));

      setState(() {
        _userPos = pos;
        _storeDistances = distances;
        _loading = false;
      });

      // ⬇️ Pertama kali: fokus ke LOKASI KAMU (bukan toko terdekat)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _moveCameraToUser();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _moveCameraToUser() {
    if (_userPos == null) return;
    final target = LatLng(_userPos!.latitude, _userPos!.longitude);
    try {
      _mapController.move(target, 13.5);
    } catch (_) {}
  }

  void _moveCameraToStore(Store s) {
    final target = LatLng(s.lat, s.lng);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        _mapController.move(target, 15);
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final userLatLng =
        LatLng(_userPos?.latitude ?? -7.77, _userPos?.longitude ?? 110.39);

    // Marker: user + 2 toko terdekat (total 3 simbol)
    final markers = <Marker>[
      if (_userPos != null)
        Marker(
          point: userLatLng,
          width: 44,
          height: 44,
          child: const Icon(Icons.my_location, color: rose, size: 32),
        ),
      for (final data in _top2Stores)
        Marker(
          point: LatLng((data['store'] as Store).lat, (data['store'] as Store).lng),
          width: 44,
          height: 44,
          child: const Icon(Icons.storefront, color: Colors.blueAccent, size: 32),
        ),
    ];

    return Scaffold(
      appBar: const HeaderWidget(title: 'Toko Kami'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: userLatLng, // fallback awal
                        initialZoom: 13,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                          userAgentPackageName: 'com.example.tugas_akhir',
                        ),
                        MarkerLayer(markers: markers),
                      ],
                    ),

                    // Panel bawah: 2 cabang terdekat + tombol "Lokasi Saya"
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              '2 Cabang Terdekat',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            if (_top2Stores.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Tidak ada data toko'),
                              )
                            else
                              ..._top2Stores.map((data) {
                                final s = data['store'] as Store;
                                final dKm = (data['distanceKm'] as double).toStringAsFixed(2);
                                return ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(Icons.store_mall_directory, color: rose),
                                  title: Text(s.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                                  subtitle: Text('${s.address}\n$dKm km dari Anda'),
                                  isThreeLine: true,
                                  onTap: () => _moveCameraToStore(s), // fokus ke toko saat di-tap
                                );
                              }),
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: rose,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: _initLocation, // refresh + fokus ke user
                              icon: const Icon(Icons.my_location, color: Colors.white),
                              label: const Text(
                                'Lokasi Saya',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
