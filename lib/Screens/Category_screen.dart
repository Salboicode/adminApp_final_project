// ignore_for_file: must_be_immutable, file_names

import 'package:final_project_adminapp/Cubits/courses_cubit.dart';
import 'package:final_project_adminapp/Cubits/courses_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;

  CategoryScreen({super.key, required this.categoryName});

  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CoursesCubit(categoryName)..getCoursesByCategory(),
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<CoursesCubit, CoursesState>(
            builder: (context, state) {
              if (state is CoursesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is CoursesError) {
                return Center(
                  child: Text(state.error),
                );
              } else if (state is CoursesLoaded) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text(
                      'Courses',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        ),
                    ),
                    centerTitle: true,
                    backgroundColor: const Color.fromARGB(255, 114, 58, 124) ,
                  ),
                  body: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text('Add New Course'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller: controller,
                                          decoration: const InputDecoration(
                                            labelText: 'Course Name',
                                          ),
                                        ),
                                        TextFormField(
                                          controller: controller2,
                                          decoration: const InputDecoration(
                                            labelText: 'Course Description',
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.read<CoursesCubit>().addNewCourse(
                                                name: controller.text,
                                                description: controller2.text,
                                              );
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Add'),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: const Text('Add New Course'),
                        ),
                      ),
                      if (context.read<CoursesCubit>().courses.isEmpty)
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No Courses Found'),
                          ],
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: context.read<CoursesCubit>().courses.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.fromLTRB(25, 10, 25, 10) ,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 114, 58, 124),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  title: Text(context
                                      .read<CoursesCubit>()
                                      .courses[index]
                                      .name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      ),
                                  subtitle: Text(context
                                      .read<CoursesCubit>()
                                      .courses[index]
                                      .description,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                      ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
