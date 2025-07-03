import 'package:flutter/material.dart';
import 'detection_screen.dart';
import 'module_list_screen.dart';
import 'Plant_selection.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.green[800],
  title: Row(
    children: [
      Icon(Icons.eco, color: Color.fromARGB(255, 35, 54, 43)), // Yaprak ikonu 🌿
      SizedBox(width: 8),
      Text(
        "PlantCare",
        style: TextStyle(
          color: const Color.fromARGB(255, 35, 54, 43),
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Ekran taşarsa kaydırılabilir olsun
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
  decoration: BoxDecoration(
    color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
    borderRadius: BorderRadius.circular(8),
  ),
  padding: EdgeInsets.all(8),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
  "Bitki Sağlığını Koruyun",
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: const Color.fromARGB(255, 46, 75, 58), // veya Colors.white
    shadows: [
      Shadow(
        offset: Offset(1, 1),
        blurRadius: 2.0,
        color: const Color.fromARGB(255, 158, 158, 158).withOpacity(0.6),
      ),
    ],
  ),
),

      SizedBox(height: 6),
     Text(
  "Böcek ve hastalık tespiti ile tarım ürünlerinizi koruyun.",
  style: TextStyle(
    fontSize: 16,
    color: const Color.fromARGB(255, 46, 75, 58),
    shadows: [
      Shadow(
        offset: Offset(0.5, 0.5),
        blurRadius: 1.0,
        color: Colors.grey.withOpacity(0.5),
      ),
    ],
  ),
),

    ],
  ),
),



              SizedBox(height: 20),

              // Böcek Tespiti Kartı
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetectionScreen(modelType: "insect"),
                    ),
                  );
                },
                child: Card(
                  color: const Color.fromARGB(255, 230, 189, 111),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Image.asset('assets/insect_icon.png', width: 60),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Böcek Tespiti",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Bitkilerde zararlı böcekleri tespit edin.",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Bitki Hastalıkları Tespiti Kartı
              GestureDetector(
                onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantSelectionScreen(), // 👈 Artık model türünü burada seçiyoruz
      ),
    );
                },
                child: Card(
                  color: const Color.fromARGB(255, 230, 189, 111),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Image.asset('assets/plant_disease_icon.png', width: 60),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bitki Hastalıkları",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Bitkilerde hastalık belirtilerini belirleyin.",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Sürdürülebilir Tarım Kartı
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModuleListScreen(),
                    ),
                  );
                },
                child: Card(
                  color: Colors.lightGreen[200],
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.eco, size: 50, color: Colors.green[900]),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sürdürülebilir Tarım",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Çevre dostu üretim yöntemlerini öğrenin.",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
