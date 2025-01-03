import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationService {
  final BuildContext context;

  LocationService(this.context);

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen konum servisini açınız')),
      );
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Konum izni reddedildi')),
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Konum izinleri kalıcı olarak reddedildi. Ayarlardan izin vermeniz gerekiyor.'),
        ),
      );
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> openInGoogleMaps(Position position) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';

    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harita açılamadı')),
      );
    }
  }
}
