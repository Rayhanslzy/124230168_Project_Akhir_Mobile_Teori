// ---------------------------------------------------
// lib/data/repositories/location_repository.dart (File Baru)
// ---------------------------------------------------

import 'package:geolocator/geolocator.dart';

class LocationRepository {
  /// Mengambil posisi GPS pengguna saat ini.
  /// Method ini menangani seluruh alur perizinan (permission).
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Cek apakah layanan lokasi di HP aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Jika tidak aktif, kirim error
      return Future.error('Layanan lokasi dimatikan.');
    }

    // 2. Cek izin (permission)
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Jika ditolak, minta izin
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Jika tetap ditolak, kirim error
        return Future.error('Izin lokasi ditolak.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Jika ditolak permanen, kirim error
      return Future.error(
          'Izin lokasi ditolak permanen, silakan aktifkan di pengaturan HP.');
    }

    // 3. Jika semua aman, ambil lokasi
    // Kita set akurasi ke 'high' untuk demo GPS
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}