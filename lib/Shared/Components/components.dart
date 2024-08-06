import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/Shared/Cubit/cubit.dart';

Widget builtTextFormField({
  TextInputType keyboardtype = TextInputType.text,
  required String? Function(String?) validatorFunc,
  required String labelText,
  required Widget prefixIcon,
  void Function()? onTap,
  required TextEditingController? controller,
}) =>
    TextFormField(
      controller: controller,
      cursorColor: Colors.red[400],
      onTap: onTap,
      keyboardType: keyboardtype,
      validator: validatorFunc,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(15)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black87),
        hintMaxLines: 1,
        prefixIcon: prefixIcon,
      ),
    );

Widget buildTask({required Map model, required BuildContext context}) {
  ToDoAppCubit cubit = BlocProvider.of(context);
  return Padding(
    padding: const EdgeInsets.all(10),
    child: InkWell(
      onLongPress: () {
        cubit.clearRecordFromDatabase(id: model['id']);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.red[400],
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          model['time'],
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model['title'],
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          model['date'],
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      cubit.updateRecord(state: "done", id: model['id']);
                    },
                    icon: const Icon(Icons.task_alt_rounded),
                    color: Colors.green.shade400,
                    iconSize: 30,
                  ),
                  IconButton(
                    onPressed: () {
                      cubit.updateRecord(state: "archived", id: model['id']);
                    },
                    icon: const Icon(Icons.archive_outlined),
                    color: Colors.black87,
                    iconSize: 30,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget buildEmptyScreen() {
  return const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.menu,
          size: 150,
          color: Colors.black26,
        ),
        Text(
          "There're no tasks to show",
          style: TextStyle(
            color: Colors.black26,
            fontSize: 20,
          ),
        ),
      ],
    ),
  );
}
