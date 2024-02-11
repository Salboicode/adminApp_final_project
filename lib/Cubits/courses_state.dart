abstract class CoursesState {}

class CoursesInitial extends CoursesState {}

class CoursesLoading extends CoursesState {}

class CoursesLoaded extends CoursesState {}

class CoursesError extends CoursesState {
  final String error;
  CoursesError(this.error);
}