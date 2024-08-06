import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/Modules/ArchivedTasksScreen/ArchivedTasksScreen.dart';
import 'package:to_do_app/Modules/DoneTasksScreen/DoneTasksScreen.dart';
import 'package:to_do_app/Modules/NewTasksScreen/NewTasksScreen.dart';
import 'package:to_do_app/Shared/Cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class ToDoAppCubit extends Cubit<ToDoAppStates> {
  ToDoAppCubit() : super(InitialState());
  //instance of ToDoAppCubit
  static ToDoAppCubit createInstance(BuildContext context) =>
      BlocProvider.of<ToDoAppCubit>(context);
  //two lists to switch between screens using bottomNavBar
  List<Widget> Screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> appBarTitles = ["New Tasks", "Done Tasks", "Archived Tasks"];
  //method changing BottomNavBar states to switch
  int currentIndex = 0;
  void changeBottomNavigationBar(int index) {
    currentIndex = index;
    emit(ChangeBottomNavigationBarState());
  }

  //Bottom Sheet state changing
  bool isBottomSheetShow = false;
  Widget floatingABIcon = const Icon(
    Icons.edit,
    color: Colors.black87,
    size: 30,
  );

  void showBottomSheetState({
    required bool isShow,
    required Widget fapIcon,
  }) {
    isBottomSheetShow = isShow;
    floatingABIcon = fapIcon;
    emit(BottomSheetState());
  }

  //Local DataBase Imp
  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  // create the database
  void createDatabase() async {
    database = await openDatabase(
      "ToDoList.db",
      version: 1,
      onCreate: (Database database, int version) {
        database
            .execute(
                'CREATE TABLE ToDoList (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          emit(DatabaseCreatedState());
          print("database is created");
        }).catchError((error) {
          print("Error while creating database: ${error.toString()}");
        });
      },
      onOpen: (database) {
        print("Database Opened");
        emit(DatabaseOpenedState());
        getDatabase(database);
      },
    );
  }

  insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO ToDoList(title, date, time, status) VALUES("$title", "$date", "$time" , "new" )')
          .then((value) {
        emit(DatabaseInsertDataState());
        getDatabase(database);
        print("Data inserted: $value");
      }).catchError((error) {
        print("Error While inserting in database: ${error.toString()}");
      });
    });
  }

  void updateRecord({
    required String state,
    required int id,
  }) async {
    // Update some record
    await database.rawUpdate('UPDATE ToDoList SET status = ? WHERE id = ?',
        [state, id]).then((value) {
      print("Data updated count: $value");
      emit(DatabaseUpdateRecordState());
      getDatabase(database);
    }).catchError((error) {
      print("Error while updating record: ${error.toString()}");
    });
  }

  clearRecordFromDatabase({
    required int id,
  }) {
    // Delete a record
    database.rawDelete('DELETE FROM ToDoList WHERE id = ?', [id]).then((value) {
      emit(DatabaseDeleteRecordState());
      print("Record Deleted: $value");
      getDatabase(database);
    }).catchError((error) {
      print("Error while deleting record: ${error.toString()}");
    });
  }

  void getDatabase(db) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    db.rawQuery('SELECT * FROM ToDoList').then((value) {
      for (Map<String, Object?> element in value) {
        if (element['status'] == "new") {
          newTasks.add(element);
        } else if (element['status'] == "done") {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
        emit(DatabaseGetDataState());
      }
    }).catchError((error) {
      print("Error while getting Database: ${error.toString()}");
    });
  }
}
