import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/Shared/Components/components.dart';
import 'package:to_do_app/Shared/Cubit/cubit.dart';
import 'package:to_do_app/Shared/Cubit/states.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoAppCubit, ToDoAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ToDoAppCubit cubit = ToDoAppCubit.createInstance(context);
        return cubit.doneTasks.isEmpty
            ? buildEmptyScreen()
            : ListView.separated(
                itemBuilder: (context, index) {
                  return buildTask(
                      model: cubit.doneTasks[index], context: context);
                },
                separatorBuilder: (context, index) => Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.red[400],
                    ),
                itemCount: cubit.doneTasks.length);
      },
    );
  }
}
