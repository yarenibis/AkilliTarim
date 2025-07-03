class PredictionResult {
  final String predictedClass;
  final double confidence;

  PredictionResult({required this.predictedClass, required this.confidence});

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      predictedClass: json['predicted_class'],
      confidence: json['confidence'].toDouble(),
    );
  }
}
