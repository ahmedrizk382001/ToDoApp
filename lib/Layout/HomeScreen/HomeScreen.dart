import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/Shared/Components/components.dart';
import 'package:to_do_app/Shared/Cubit/cubit.dart';
import 'package:to_do_app/Shared/Cubit/states.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController taskTitle = TextEditingController();
  TextEditingController taskTime = TextEditingController();
  TextEditingController taskDate = TextEditingController();

  Widget fapIcon1 = const Icon(
    Icons.edit,
    color: Colors.black87,
    size: 30,
  );

  Widget fapIcon2 = const Icon(
    Icons.add_rounded,
    color: Colors.black87,
    size: 40,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToDoAppCubit()..createDatabase(),
      child: BlocConsumer<ToDoAppCubit, ToDoAppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            ToDoAppCubit cubit = ToDoAppCubit.createInstance(context);
            return Scaffold(
              key: scaffoldKey,
              bottomNavigationBar: BottomNavigationBar(
                onTap: (value) {
                  cubit.changeBottomNavigationBar(value);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: "New Tasks"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.task_alt), label: "Done Tasks"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined), label: "Archived"),
                ],
                backgroundColor: Colors.red[400],
                currentIndex: cubit.currentIndex,
                iconSize: 30,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.black87,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetShow) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertToDatabase(
                          title: taskTitle.text,
                          date: taskDate.text,
                          time: taskTime.text);
                      cubit.showBottomSheetState(
                          isShow: false, fapIcon: fapIcon1);
                      Navigator.pop(context);
                    }
                  } else {
                    cubit.showBottomSheetState(isShow: true, fapIcon: fapIcon2);

                    scaffoldKey.currentState!
                        .showBottomSheet((context) => Form(
                              key: formKey,
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    builtTextFormField(
                                        validatorFunc: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter task title";
                                          }
                                          return null;
                                        },
                                        labelText: "Task Title",
                                        prefixIcon: const Icon(Icons.title),
                                        controller: taskTitle),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    builtTextFormField(
                                      validatorFunc: (value) {
                                        if (value!.isEmpty) {
                                          return "Please enter task time";
                                        }
                                        return null;
                                      },
                                      labelText: "Task Time",
                                      prefixIcon: const Icon(Icons.access_time),
                                      controller: taskTime,
                                      onTap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          taskTime.text =
                                              value!.format(context);
                                        }).catchError((error) {
                                          print(
                                              "Time Picker Error: ${error.toString()}");
                                        });
                                      },
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    builtTextFormField(
                                      validatorFunc: (value) {
                                        if (value!.isEmpty) {
                                          return "Please enter task date";
                                        }
                                        return null;
                                      },
                                      labelText: "Task Date",
                                      prefixIcon: const Icon(Icons.date_range),
                                      controller: taskDate,
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2100),
                                                initialDate: DateTime.now())
                                            .then((value) {
                                          taskDate.text =
                                              DateFormat.yMMMd().format(value!);
                                        }).catchError((error) {
                                          print(
                                              "Date Picker Error: ${error.toString()}");
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        .closed
                        .then((value) {
                      cubit.showBottomSheetState(
                          isShow: false, fapIcon: fapIcon1);
                    });
                  }
                },
                backgroundColor: Colors.red[400],
                splashColor: Colors.red,
                child: cubit.floatingABIcon,
              ),
              appBar: AppBar(
                backgroundColor: Colors.red[400],
                title: Text(
                  cubit.appBarTitles[cubit.currentIndex],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
              ),
              body: cubit.Screens[cubit.currentIndex],
            );
          }),
    );
  }
}
