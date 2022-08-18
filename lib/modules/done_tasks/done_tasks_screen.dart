import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/status.dart';

class DoneTasksScreen extends StatelessWidget {
  DoneTasksScreen({Key key ,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return
      BlocConsumer<AppCubit,AppStates>(builder:(context, state) {
        var doneTasks=AppCubit.get(context).doneTasks;
        return defaultBuilder(list: doneTasks,context1: context);

      } ,listener: (context, state) {
      },
      );
  }
}
