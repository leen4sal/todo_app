import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/cubit/status.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 1;
  IconData fabIcon = Icons.edit;
  bool isBottomSheetShown = false;
  bool isbottomsheetedittingshown = false;
  bool editpressed=false;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  Database database;
  List<String> titles = ['Done', 'Tasks', 'Archived'];
  List<Widget> screens = [
    DoneTasksScreen(),
    NewTasksScreen(),
    ArchiveTasksScreen()
  ];
  void getDataFromDatabase(database)  {
    newTasks=[];
    doneTasks=[];
    archiveTasks=[];
    emit(AppGetDataLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value)
    {
      value.forEach((element) {
        if(element['status']=='new')
        {
          newTasks.add(element);
        }
        else if(element['status']=='done')
        {
          doneTasks.add(element);
        }
        else {
          archiveTasks.add(element);}

      });
      emit(AppGetDatabaseState());
    });

  }
  void createDatabase() async {
    openDatabase(join(await getDatabasesPath(), 'tasks.db'), version: 1,
        onCreate: (database, version) {
          print('database created!!');
          database
              .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT,date TEXT, time TEXT, status TEXT)')
              .then((value) {
            print('table created!!');
          }).catchError((error) => print('${error.toString()} happened'));
        }, onOpen: (Database database) {
          getDataFromDatabase(database);
          print('database opened!!');
        }).then((value) {  database=value;
    emit(AppCreateDatabaseState());});
  }
  insertDatabase(
      { String title,
        String date,
        String time,
        String status='new'}) async {
    await database.transaction((txn,)  {
      txn
          .rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "$status")')
          .then((value) {
        print('inserted successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print("${error.toString()} is error");
      });
      return null;
    });
  }
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }
  void changeBottomSheet({@required bool isShow, @required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
  void changeBottomSheetEditting({@required bool isShow,}) {
    isbottomsheetedittingshown = isShow;
    emit(AppChangeBottomSheetEdittingState());
  }
  void deleteFromDatabase({String join, @required int id}){
    database
        .rawDelete('DELETE FROM tasks WHERE id = ?',[id]).then((value) {
      print('deleting done');
      emit(AppDeleteFromDatabaseState());
      getDataFromDatabase(database);
    });
  }
  void updateDatabase({ String title,String date,String time,String status ,int id}) async{
    database.rawUpdate(
        'UPDATE Tasks SET title = ?, date = ?, time = ?, status = ? WHERE id = ?',
        ['$title','$date','$time','$status', id ,]).then((value)  {
      // print(value);
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
      print('updated successfully');
    });
  }
  void deleteListOfDatabase({ List<Map> list,}) async{
    for(int index=0;index<list.length;index++) {
      await database.rawDelete(
          'DELETE FROM tasks WHERE id = ?', [list[index]['id']]);
    }
    getDataFromDatabase(database);
    emit(AppDeleteListOfDatabaseState());
  }
  void deleteData() async {
    deleteDatabase( join(await getDatabasesPath(), 'tasks.db'),).then((value)
    {
      emit(AppDeleteTableState());
      getDataFromDatabase(database);
      print('database deleted!');
    });
  }
  void whichonepressed({  bool edit,}){
    editpressed=edit;
    emit(AppWhichOnePressedState());
  }
}
