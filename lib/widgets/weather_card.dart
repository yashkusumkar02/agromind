import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller/home_controller.dart';

class WeatherCard extends StatelessWidget {
  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.city.value.isEmpty) {
        return _buildPlaceholderWeatherCard();
      }

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.location_pin, color: Colors.white, size: 16),
                const SizedBox(width: 5),
                Text(
                  "${controller.city.value}, IND",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Image.asset(
                  _getWeatherImage(controller.weatherCondition.value),
                  height: 40,
                  width: 40,
                ),
                const SizedBox(width: 5),
                Text(
                  "${controller.temperature.value}°C",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPlaceholderWeatherCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          const SizedBox(width: 10),
          Text("Fetching weather...",
              style: TextStyle(color: Colors.black87, fontSize: 14)),
        ],
      ),
    );
  }

  String _getWeatherImage(String condition) {
    condition = condition.toLowerCase();
    if (condition.contains("clear")) return 'assets/images/sunny.png';
    if (condition.contains("cloud")) return 'assets/images/cloud.png';
    if (condition.contains("rain")) return 'assets/images/rain.png';
    if (condition.contains("storm")) return 'assets/images/storm.png';
    return 'assets/images/sunny.png';
  }
}
