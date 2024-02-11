// ignore_for_file: camel_case_types, file_names

class Category {
  final String name;
  final String? image;
  Category({
    required this.name,
    required this.image,
  });

  factory Category.fromDoc(Map<String, dynamic> json){
    return Category(
      name :json['name'],
      image: json['image'],
    );
  }
}