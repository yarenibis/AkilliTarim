import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/prediction_result.dart';

class ApiService {
  Future<PredictionResult?> predict(File image, String modelType, String userId) async {
    final uri = Uri.parse('http://10.0.2.2:8000/predict');


    var request = http.MultipartRequest('POST', uri);
    
    // Görsel dosyasını ekle
    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    // Form verilerini ekle
    request.fields['model_type'] = modelType;
   // request.fields['user_id'] = userId; // eğer API'de bu destekleniyorsa

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final resultData = jsonDecode(responseBody);
      return PredictionResult.fromJson(resultData);
    } else {
      print(' API Hatası: ${response.statusCode}');
      print('Yanıt: $responseBody');
      throw Exception('API error: ${response.statusCode}');
    }
  }
}