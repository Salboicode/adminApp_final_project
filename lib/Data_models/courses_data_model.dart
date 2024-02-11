class CourseDataModel {
  String name;
  String description;
  String category;

  CourseDataModel({
    required this.name,
    required this.description,
    required this.category,
  });

  factory CourseDataModel.fromJson(Map<String, dynamic> json) {
    return CourseDataModel(
      name: json['name'],
      description: json['description'],
      category: json['category'],
    );
  }
}
