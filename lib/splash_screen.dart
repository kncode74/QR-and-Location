import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Position? _currentPosition;
  Placemark? _currentAddress;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<Placemark?> _getAdress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.latitude);

      return placemarks[0];
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final position = await _determinePosition();

                    setState(() {
                      _currentPosition = position;
                    });
                    final address = await _getAdress();
                    setState(() {
                      _currentAddress = address;
                    });
                  },
                  child: Icon(Icons.location_on),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _currentPosition = null;
                      _currentAddress = null;
                    });
                  },
                  child: Icon(Icons.refresh),
                ),
              ],
            ),
            SizedBox(height: 20),
            const Text(
              'My current location',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
                'Latitude : ${_currentPosition?.latitude.toString()}, Longtitude : ${_currentPosition?.longitude.toString()}'),
            const Text(
              'My address',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(' ${_currentAddress?.locality}, ${_currentAddress?.country}'),
          ],
        ),
      ),
    );
  }
}
