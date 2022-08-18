import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/status.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({Key key});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) => {
          if (state is AppInsertDatabaseState) {Navigator.pop(context)}
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = BlocProvider.of(context);
          return Scaffold(
            key: scaffoldKey,
            body: ConditionalBuilder(
              condition: state is! AppGetDataLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(
                  child: CircularProgressIndicator(
                    backgroundColor: basicColor,
                    strokeWidth: 2,
                  )),
            ),
            bottomNavigationBar: SizedBox(
              height: 65,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: AppCubit.get(context).currentIndex,
                onTap: (index) {
                  AppCubit.get(context).changeIndex(index);
                },
                showUnselectedLabels: false,
                elevation: 50,
                fixedColor: basicColor,
                showSelectedLabels: false,
                items: [
                  BottomNavigationBarItem(
                      icon: navBottomIcon(
                        icon: Icons.menu,
                      ),
                      activeIcon: activeIcon(icon: Icons.menu),
                      label: 'Tasks'),
                  BottomNavigationBarItem(
                      icon: navBottomIcon(
                        icon: Icons.done_all,
                      ),
                      activeIcon: activeIcon(icon: Icons.done_all),
                      label: 'Done'),
                  BottomNavigationBarItem(
                      icon: navBottomIcon(
                        icon: Icons.archive,
                      ),
                      activeIcon: activeIcon(icon: Icons.archive),
                      label: 'Archive'),
                ],
              ),
            ),
            appBar: AppBar(
              backgroundColor: basicColor,
              title: Text(
                cubit.titles[cubit.currentIndex],
                style: barTitlesStyle,
              ),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: basicColor,
              child: Icon(
                cubit.fabIcon,
                color: Colors.white,
              ),
              onPressed: () {
                if (cubit.isbottomsheetedittingshown) {
                  if (edittedFormKey.currentState.validate()) {
                    AppCubit.get(context).updateDatabase(
                        title: '${editedTitle.text}',
                        date: '${editedDate.text}',
                        time: '${editedTime.text}',
                        status: '$edittedStatus',
                        id: edittedId);
                    editedTitle.clear();
                    editedDate.clear();
                    editedTime.clear();
                    cubit.isbottomsheetedittingshown = false;
                  }
                } else {
                  //add pressed
                  if (cubit.isBottomSheetShown) {
                    if (newFormKey.currentState.validate()) {
                      cubit.insertDatabase(
                          title: newTitle.text,
                          date: newDate.text,
                          time: newTime.text);
                      newTitle.clear();
                      newDate.clear();
                      newTime.clear();
                      cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
                    }
                  } else {
                    scaffoldKey.currentState
                        .showBottomSheet(
                            (context) => formContainer(
                            context: context,
                            key: newFormKey,
                            titleController: newTitle,
                            dateController: newDate,
                            timeController: newTime,
                            raduis: 8),
                        elevation: 10)
                        .closed
                        .then((value) {
                      cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
                    });
                    cubit.changeBottomSheet(isShow: true, icon: Icons.add);
                  }
                }
              },
            ),
          );
        },
      ),
    );
  }
}
