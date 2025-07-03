import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ModuleDetailScreen extends StatelessWidget {
  final String moduleId;

  const ModuleDetailScreen({Key? key, required this.moduleId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final docRef = FirebaseFirestore.instance
        .collection('sustainability_modules')
        .doc(moduleId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Yöntemler'),
        backgroundColor: Colors.green[800],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: docRef.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final tips = List<String>.from(data['tips'] ?? []);
          final imgUrls = List<String>.from(data['img_urls'] ?? []);
          final videoUrls = List<String>.from(data['video_urls'] ?? []);

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık
                Text(
                  data['title'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),

                // Açıklama
                Text(
                  data['description'],
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),

                // Görsel Galerisi
                imgUrls.isNotEmpty
                    ? SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imgUrls.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  imgUrls[index],
                                  width: 300,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.broken_image, size: 50),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(),
                SizedBox(height: 20),

                // Yöntemler / Tips
                tips.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Yöntemler:',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          ...tips.map((tip) {
                            return ListTile(
                              leading: Icon(Icons.check_circle, color: Colors.green),
                              title: Text(tip),
                            );
                          }).toList(),
                          SizedBox(height: 20),
                        ],
                      )
                    : Container(),

                // Videolar (sadece varsa göster)
                videoUrls.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Videolar:',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          ...videoUrls.map((url) {
                            String videoId = YoutubePlayer.convertUrlToId(url) ?? "";
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: YoutubePlayer(
                                controller: YoutubePlayerController(
                                  initialVideoId: videoId,
                                  flags: YoutubePlayerFlags(autoPlay: false),
                                ),
                                showVideoProgressIndicator: true,
                                progressIndicatorColor: Colors.green,
                              ),
                            );
                          }).toList(),
                        ],
                      )
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}
