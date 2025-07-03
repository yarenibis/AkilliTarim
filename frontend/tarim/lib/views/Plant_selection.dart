import 'package:flutter/material.dart';
import 'detection_screen.dart';

class PlantSelectionScreen extends StatelessWidget {
  final List<Map<String, String>> plantModels = [
    {'name': 'Üzüm', 'type': 'grape', 'image': 'assets/grape.jpg'},
    {'name': 'Mısır', 'type': 'corn', 'image': 'assets/corn.jpg'},
    {'name': 'Patates', 'type': 'potato', 'image': 'assets/potato.jpg'},
    {'name': 'Elma', 'type': 'apple', 'image': 'assets/apple.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bitki Türünü Seç')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: plantModels.length,
          itemBuilder: (context, index) {
            final plant = plantModels[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetectionScreen(modelType: plant['type']!),
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  leading: Image.asset(plant['image']!, width: 50),
                  title: Text(plant['name']!),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
