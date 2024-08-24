class UploadModel {
  String imageUrl;
  String name;
  bool normal;

  UploadModel(
      {required this.imageUrl, required this.name, required this.normal});

  factory UploadModel.fromJson(Map<String, dynamic> json) {
    return UploadModel(
      imageUrl: json['imageUrl'],
      name: json['name'],
      normal: json['normal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'name': name,
      'normal': normal,
    };
  }
}
