import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_adminapp/Cubits/app_state.dart';
import 'package:final_project_adminapp/Data_models/Category_data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  Future<void> addNewCategory({
    required String categoryName,
  }) async {
    try {
      String? imageUrl =
          await uploadImageToFireBase(categoryName: categoryName);

      await FirebaseFirestore.instance.collection('categories').add({
        'name': categoryName,
        'image': imageUrl ?? '',
      }).then((value) {
        categories.add(Category(name: categoryName, image: imageUrl));
        emit(AppLoaded());
      });
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  List<Category> categories = [];
  Future<void> getCategories() async {
    try {
      emit(AppLoading());
      await FirebaseFirestore.instance
          .collection('categories')
          .get()
          .then((value) {
        categories.clear();
        for (var element in value.docs) {
          categories.add(Category(name: element['name'], image: element['image']));
        }
        emit(AppLoaded());
      });
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  ImagePicker picker = ImagePicker();

  File? image;
  Future<void> pickImageG() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      this.image = File(image.path);
      emit(AppImagePicked());
    }
  }

  Future<String?> uploadImageToFireBase({
    required String categoryName,
  }) async {
    try {
      emit(AppLoading());
      final ref = FirebaseStorage.instance
          .ref()
          .child('categoryImages')
          .child('$categoryName.jpg');

      await ref.putFile(image!);

      final imageUrl = await ref.getDownloadURL();

      return imageUrl;
    } catch (error) {
      emit(AppError('Error: $error'));
      return null;
    }
  }
}
