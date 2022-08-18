import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/status.dart';

class NewTasksScreen extends StatelessWidget {

  NewTasksScreen({Key key ,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return
      BlocConsumer<AppCubit,AppStates>(
        builder:(context, state)
        {
          var newTasks=AppCubit.get(context).newTasks;
          return defaultBuilder(list: newTasks ,context1: context);}
        ,listener: (context, state) {
      },
      );
  }
}
