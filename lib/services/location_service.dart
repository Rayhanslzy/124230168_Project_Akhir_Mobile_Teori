// ---------------------------------------------------
// lib/services/location_service.dart
// ---------------------------------------------------

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<Map<String, dynamic>> getCurrentLocation() async {
    // 1. Cek Service GPS Nyala/Gak
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('GPS mati, nyalain dulu bos!');
    }

    // 2. Cek Izin Lokasi
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Izin lokasi ditolak 😢');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Izin lokasi ditolak permanen. Cek setting HP lo.');
    }

    // 3. Ambil Koordinat (Latitude, Longitude)
    Position position = await Geolocator.getCurrentPosition();

    // 4. Reverse Geocoding (Cari Nama Kota)
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String city = 'Unknown City';
      if (placemarks.isNotEmpty) {
        // Ambil kota/kabupaten atau kecamatan kalau kosong
        city = placemarks[0].locality ?? placemarks[0].subAdministrativeArea ?? 'Somewhere';
      }

      // 5. Tebak Timezone Indonesia (Simple Logic by Longitude)
      // WIB  : < 110 BT (Jawa, Sumatera, Kalbar)
      // WITA : 110 - 125 BT (Bali, Nusa Tenggara, Sulawesi, Kaltim)
      // WIT  : > 125 BT (Papua, Maluku)
      
      String zone = 'WIB';
      int offset = 7;
      double long = position.longitude;

      if (long >= 125) {
        zone = 'WIT';
        offset = 9;
      } else if (long >= 110) {
        zone = 'WITA';
        offset = 8;
      }

      return {
        'city': city,
        'zone': zone,
        'offset': offset,
      };

    } catch (e) {
      // Fallback kalau gagal dapet nama kota
      return {
        'city': 'Lokasi Terdeteksi',
        'zone': 'WIB',
        'offset': 7,
      };
    }
  }
}