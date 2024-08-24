class DrawingPointModel {
  final double x;
  final double y;
  final double pressure;
  final DateTime timeStamp;

  DrawingPointModel({
    required this.x,
    required this.y,
    required this.timeStamp,
    required this.pressure,
  });

  factory DrawingPointModel.fromJson(Map<String, dynamic> json) {
    return DrawingPointModel(
      x: json['x'],
      y: json['y'],
      timeStamp: json['timeStamp'],
      pressure: json['pressure'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'timeStamp': timeStamp,
      'pressure': pressure,
    };
  }
}
