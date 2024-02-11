// ignore_for_file: must_be_immutable, file_names


import 'package:final_project_adminapp/Cubits/app_cubit.dart';
import 'package:final_project_adminapp/Cubits/app_state.dart';
import 'package:final_project_adminapp/Screens/Category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 58, 124),
      ),
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          if (state is AppLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AppError) {
            return Center(
              child: Text(state.error),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text('Add New Category'),
                            content: BlocBuilder<AppCubit, AppState>(
                              builder: (context, state) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: controller,
                                      decoration: const InputDecoration(
                                        labelText: 'Category Name',
                                      ),
                                    ),
                                    if (context.read<AppCubit>().image != null)
                                      Image.file(
                                          context.read<AppCubit>().image!),
                                    ElevatedButton(
                                        onPressed: () async {
                                          await context
                                              .read<AppCubit>()
                                              .pickImageG();
                                        },
                                        child: const Text('Pick Image')),
                                  ],
                                );
                              },
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
                                  context.read<AppCubit>().addNewCategory(
                                        categoryName: controller.text,
                                      );
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Add'),
                              ),
                            ],
                          );
                        });
                  },
                  child: const Text('Add New Category'),
                ),
                if (context.read<AppCubit>().categories.isEmpty)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No Categories Found'),
                    ],
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: context.read<AppCubit>().categories.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CategoryScreen(
                                  categoryName: context
                                      .read<AppCubit>()
                                      .categories[index]
                                      .name,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.height * 0.25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(
                                  context
                                      .read<AppCubit>()
                                      .categories[index]
                                      .image!,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 200, 0),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(5),
                                  ),
                                  color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.7),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      child: Text(
                                        context
                                            .read<AppCubit>()
                                            .categories[index]
                                            .name,
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
