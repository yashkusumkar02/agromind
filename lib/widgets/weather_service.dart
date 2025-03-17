import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = "5710ae45242046421c2c729efc23f134"; // Replace with your API Key

  // ✅ 1. Get User's Current Location (Latitude & Longitude)
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    // Check & request permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied.");
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // ✅ 2. Convert Coordinates to City Name
  Future<String> _getCityFromCoordinates(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        return placemarks.first.locality ?? "Unknown City";
      }
    } catch (e) {
      print("Error fetching city name: $e");
    }
    return "Unknown City";
  }

  // ✅ 3. Fetch Weather Data Based on GPS Location
  Future<Map<String, dynamic>?> fetchWeather() async {
    try {
      Position position = await _getCurrentLocation();
      String city = await _getCityFromCoordinates(
          position.latitude, position.longitude);

      final url = Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        data["city"] = city; // Add city name to response
        return data;
      } else {
        print("Error: Failed to fetch weather data");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}
