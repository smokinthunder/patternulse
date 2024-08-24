
import 'package:patternpulse/Data/Models/drawing_point_model.dart';

class DrawingModel {
  final List<DrawingPointModel> drawingPoints;
  final bool normal; 
  final String expectedWord;
  final String imageUrl;

  DrawingModel({
    required this.drawingPoints,
    required this.normal,
    required this.expectedWord,
    required this.imageUrl,
  });

  factory DrawingModel.fromJson(Map<String, dynamic> json) {
    return DrawingModel(
      imageUrl: json['imageUrl'],
      drawingPoints: List<DrawingPointModel>.from(
        json['drawingPoints'].map(
          (x) => DrawingPointModel.fromJson(x),
        ),
      ),
      normal: json['normal'],
      expectedWord: json['expectedWord'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'drawingPoints': drawingPoints.map((x) => x.toJson()).toList(),
      'normal': normal,
      'expectedWord': expectedWord,
    };
  }
}
