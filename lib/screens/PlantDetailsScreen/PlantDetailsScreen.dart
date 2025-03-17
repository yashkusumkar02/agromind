import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlantDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ✅ Fetch plant details from arguments
    final Map<String, dynamic> plant = Get.arguments ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text(plant["common_name"] ?? "Plant Details"),
        backgroundColor: Colors.green[200],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Plant Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  plant["image_url"].isNotEmpty ? plant["image_url"] : "https://via.placeholder.com/150",
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 100),
                ),
              ),
            ),

            SizedBox(height: 16),

            // ✅ Plant Name & Scientific Name
            Text(
              plant["common_name"] ?? "Unknown Plant",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              plant["scientific_name"] ?? "N/A",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.green),
            ),

            SizedBox(height: 16),

            // ✅ Watering & Cycle
            Row(
              children: [
                Icon(Icons.water_drop, color: Colors.blue),
                SizedBox(width: 5),
                Text("Watering: ${plant["watering"]}"),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.nature, color: Colors.brown),
                SizedBox(width: 5),
                Text("Life Cycle: ${plant["cycle"]}"),
              ],
            ),

            SizedBox(height: 10),

            // ✅ Sunlight Requirements
            if (plant["sunlight"].isNotEmpty) ...[
              Text("☀️ Sunlight Requirements:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...List.generate(
                plant["sunlight"].length,
                    (index) => Text("- ${plant["sunlight"][index]}"),
              ),
              SizedBox(height: 10),
            ],

            // ✅ Hardiness Zone
            if (plant["hardiness"].isNotEmpty) ...[
              Text("🌍 Hardiness Zone:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...List.generate(
                plant["hardiness"].length,
                    (index) => Text("Zone: ${plant["hardiness"][index]}"),
              ),
              SizedBox(height: 10),
            ],

            // ✅ Hardiness Map (Image)
            if (plant["hardiness_map"].isNotEmpty) ...[
              Text("📍 Hardiness Map:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    plant["hardiness_map"],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 100),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],

            // ✅ Soil Type
            Text("🌱 Preferred Soil Type:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(plant["soil"]),
            SizedBox(height: 10),

            // ✅ Toxicity
            Text(
              "⚠️ Toxicity:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            Text(
              plant["poisonous_to_humans"] ? "This plant is toxic to humans." : "Not toxic to humans.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),

            // ✅ Medicinal Uses
            if (plant["medicinal"].isNotEmpty) ...[
              Text("🏥 Medicinal Uses:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(plant["medicinal"]),
              SizedBox(height: 10),
            ],

            SizedBox(height: 20),

            // ✅ Back Button
            Center(
              child: ElevatedButton(
                onPressed: () => Get.back(),
                child: Text("Back"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
