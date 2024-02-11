import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_adminapp/Cubits/courses_state.dart';
import 'package:final_project_adminapp/Data_models/courses_data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// cubit for courses screen

class CoursesCubit extends Cubit<CoursesState> {
  CoursesCubit(this.category) : super(CoursesInitial());

  final String category;
  Future<void> addNewCourse({
    required String name,
    required String description,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('courses').add({
        'name': name,
        'description': description,
        'category': category,
      }).then((value) {
        courses.add(CourseDataModel(
          name: name,
          description: description,
          category: category,
        ));
        emit(CoursesLoaded());
      });
    } catch (e) {
      emit(CoursesError(e.toString()));
    }
  }

  List<CourseDataModel> courses = [];

  Future<void> getCoursesByCategory() async {
    try {
      emit(CoursesLoading());
      await FirebaseFirestore.instance
          .collection('courses')
          .where('category', isEqualTo: category)
          .get()
          .then((value) {
        courses.clear();
        for (var c in value.docs) {
          courses.add(CourseDataModel.fromJson(c.data()));
        }
        emit(CoursesLoaded());
      });
    } catch (e) {
      emit(CoursesError(e.toString()));
    }
  }
}


