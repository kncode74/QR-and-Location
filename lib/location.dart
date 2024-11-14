import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationDetail extends StatefulWidget {
  const LocationDetail({super.key});

  @override
  State<LocationDetail> createState() => _LocationDetailState();
}

class _LocationDetailState extends State<LocationDetail> {
  Position? _currentPosition;
  Placemark? _currentAddress;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return Future.error('Location services are disabled.');
    }

    // Check for permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When permissions are granted, get the position
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<void> getLocation() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  getAddress() async {
    Placemark? placemark = await _getAdress();
    setState(() {
      _currentAddress = placemark;
    });
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
      appBar: AppBar(
        title: Text('Location Detail'),
      ),
      body: _content(),
    );
  }

  Widget _content() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  getLocation().then((_) {
                    getAddress();
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
    );
  }
}
