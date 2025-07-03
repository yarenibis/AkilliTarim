import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetectionScreen extends StatefulWidget {
  final String modelType;

  DetectionScreen({required this.modelType});

  @override
  _DetectionScreenState createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  File? _image;
  String? _result;
  String? _recommendation;
  bool _loading = false;

  Map<String, String> _recommendations = {};

  final picker = ImagePicker();

  final String recommendationsUrl =
      'https://firebasestorage.googleapis.com/v0/b/tarim-41e24.firebasestorage.app/o/recommendations.json?alt=media&token=10f4b9d9-095f-45ee-b61a-3dafabb90606';

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    try {
      final response = await http.get(Uri.parse(recommendationsUrl));
      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = json.decode(utf8Body);
        final Map<String, dynamic> selectedData = data[widget.modelType] ?? {};
        setState(() {
          _recommendations =
              selectedData.map((key, value) => MapEntry(key, value.toString()));
        });
      } else {
        print('JSON çekme hatası: ${response.statusCode}');
      }
    } catch (e) {
      print('JSON çekme sırasında hata oluştu: $e');
    }
  }

  final Map<String, Map<String, String>> labelTranslations = {
    "apple": {
      "Apple Scab": "Elma Kabuk Lekesi Hastalığı",
      "Black Rot": "Siyah Çürüklük",
      "Cedar Apple Rust": "Sedir Pası",
      "Healthy": "Elma - Sağlıklı",
    },
    "corn": {
      "Blight": "Kuruma / Yanıklık Hastalığı",
      "Common_Rust": "Yaygın Pas Hastalığı",
      "Gray_Leaf_Spot": "Gri Yaprak Lekesi",
      "Healthy": "Mısır - Sağlıklı",
    },
    "grape": {
      "Black rot": "Siyah Leke",
      "ESCA": "Esca Hastalığı (Odun İç Hastalığı)",
      "Healthy": "Sağlıklı",
      "Blight": "Yaprak yanıklığı",
    },
    "potato": {
      "Early_Blight": "Erken Yaprak Yanıklığı",
      "Healthy": "Sağlıklı",
      "Late_Blight": "Geç yaprak yanıklığı",
    },
    "insect": {
      "Boxelder Bugs": "Dişbudak Ağacı Böceği",
  "Cabbage Looper": "Lahana Kıvrım Tırtılı",
  "Cutworm": "Kesici Kurdu / Gece Kelebeği Larvası",
  "Epilachna vigintioctopunctata": "28 Noktalı Asya Hanım Böceği",
  "Flea Beetles": "Pire Böceği",
  "Mediterranean fruit fly": "Akdeniz Meyve Sineği",
  "Riptortus": "Riptortus linearis (Bir tür tarla zararlısı)",
  "Squash Bug": "	Kabak Zararlısı / Kabak Böceği",
    }
  };

  String translateLabel(String label) {
    return labelTranslations[widget.modelType]?[label] ?? label;
  }

  Future<void> _showImageSourceActionSheet() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Kameradan Çek'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Galeriden Seç'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _result = null;
        _recommendation = null;
      });
    }
  }

  Future<void> _detectAndUpload() async {
    if (_image == null) return;

    setState(() {
      _loading = true;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
      final uri = Uri.parse('http://10.0.2.2:8000/predict');

      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('file', _image!.path));
      request.fields['model_type'] = widget.modelType;

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final resultData = jsonDecode(responseBody);
        final predictedClass = resultData['prediction'];
        final confidence = resultData['confidence'];

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await storageRef.putFile(_image!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance.collection('predictions').add({
          'user_id': userId,
          'model': widget.modelType,
          'predicted_class': predictedClass,
          'confidence': confidence,
          'image_url': imageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        final translatedLabel = translateLabel(predictedClass);

        String? recommendation;

final match = _recommendations.entries.firstWhere(
  (e) => e.key.toLowerCase().trim() == predictedClass.toLowerCase().trim(),
  orElse: () => const MapEntry('', 'Bu sınıf için öneri yok.'),
);

recommendation = match.value;

print('🎯 predictedClass: $predictedClass');
print('🔍 recommendations keys: ${_recommendations.keys}');

        setState(() {
          _result =
              'Sonuç: $translatedLabel (%${confidence.toStringAsFixed(2)})';
          _recommendation = '🌿 Öneri: $recommendation';
        });
      } else {
        setState(() {
          _result = 'API Hatası: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Hata oluştu: $e';
      });
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.modelType == "insect"
        ? "Zararlı Böcek Tespiti"
        : "Bitki Hastalığı Tespiti";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green[800],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              _image == null
                  ? Text('Bir resim seçiniz.')
                  : Image.file(_image!, height: 200),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _showImageSourceActionSheet,
                icon: Icon(Icons.add_a_photo),
                label: Text('Resim Yükle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[600],
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _loading ? null : _detectAndUpload,
                icon: _loading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Icon(Icons.search),
                label: Text('Tahmin Et'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                ),
              ),
              SizedBox(height: 20),
              _result != null
                  ? Text(
                      _result!,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )
                  : Container(),
              SizedBox(height: 10),
              _recommendation != null
                  ? Text(
                      _recommendation!,
                      style: TextStyle(fontSize: 16, color: Colors.green[900]),
                      textAlign: TextAlign.center,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
