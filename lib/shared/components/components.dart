import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/layout/home_layout.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'constants.dart';

Widget defaultFormField(
    {@required TextEditingController controller,
      bool isObs = false,
      @required TextInputType type,
      @required Function validation,
      @required Function sumbite,
      @required Function change,
      String label,
      Function ontaped,
      double radius = 0.0,
      IconData icon,
      Widget myButton,
      Color color = Colors.grey}) =>
    TextFormField(
      obscureText: isObs,
      keyboardType: type,
      onTap: ontaped,
      onChanged: change,
      onFieldSubmitted: sumbite,
      validator: validation,
      controller: controller,
      decoration: InputDecoration( hoverColor: otherColor,
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius)) ,
            borderSide: BorderSide(color: otherColor, width: 1.0,style: BorderStyle.solid),
          ),
          suffixIcon: myButton,
          hintText: label,hintStyle: TextStyle(fontFamily: 'Caveat',),
          focusColor: otherColor,
          prefixIcon: Icon(icon,color: basicColor,),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: color, width: 0.1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  topRight: Radius.circular(radius)))),
    );

Widget buildTaskItem({
  Map model,
  secondContext,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 5),
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: StadiumBorder(
        side: BorderSide(width: 1, color: otherColor),
      ),
    ),
    height: 85,
    child: Dismissible(
      key: UniqueKey(),
      secondaryBackground: dismissedContainer(
        color: Colors.green,
        icon: Icons.done_all,
        alignment: Alignment.centerRight,
      ),
      background: dismissedContainer(
        color: otherColor,
        icon: Icons.archive,
        alignment: Alignment.centerLeft,
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          dismissedTitle = model['title'];
          dismissedDate = model['date'];
          dismissedTime = model['time'];
          dismissedStatus = model['status'];
          print(dismissedStatus);
          AppCubit.get(secondContext).updateDatabase(
              title: model['title'],
              date: model['date'],
              time: model['time'],
              status: 'archive',
              id: model['id']);
          Scaffold.of(secondContext).showSnackBar(showBar(
              text: 'Item has moved to archive',
              onPressed: () {
                AppCubit.get(secondContext).updateDatabase(
                    title: '$dismissedTitle',
                    date: '$dismissedDate',
                    time: '$dismissedTime',
                    status: '$dismissedStatus',
                    id: model['id']);
              }));
        } else {
          dismissedTitle = model['title'];
          dismissedDate = model['date'];
          dismissedTime = model['time'];
          dismissedStatus = model['status'];
          AppCubit.get(secondContext).updateDatabase(
              title: model['title'],
              date: model['date'],
              time: model['time'],
              status: 'done',
              id: model['id']);
          Scaffold.of(secondContext).showSnackBar(showBar(
              text: 'Item has moved to done tasks',
              onPressed: () {
                AppCubit.get(secondContext).updateDatabase(
                    title: '$dismissedTitle',
                    date: '$dismissedDate',
                    time: '$dismissedTime',
                    status: '$dismissedStatus',
                    id: model['id']);
              }));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              child: Text(
                '${model['time']}',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              backgroundColor: basicColor,
              radius: 35,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: tasksStyle,
                  ),
                  Text('${model['date']}', style: dateTasksStyle)
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
                size: 20,
                color: Colors.green,
              ),
              onPressed: () {
                AppCubit.get(secondContext)
                    .changeBottomSheetEditting(isShow: true);
                edittedId = model['id'];
                editedTitle.text = model['title'];
                editedDate.text = model['date'];
                editedTime.text = model['time'];
                edittedStatus = model['status'];
                showBottomSheet(
                    context: secondContext,
                    elevation: 10,
                    builder: (context) => formContainer(
                        key: edittedFormKey,
                        context: context,
                        titleController: editedTitle,
                        dateController: editedDate,
                        timeController: editedTime,
                        raduis: 8)).closed.then((value) =>
                    AppCubit.get(secondContext).changeBottomSheetEditting(
                      isShow: false,
                    ));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.clear,
                size: 20,
                color: Colors.red,
              ),
              onPressed: () {
                return showDialog(
                  context: secondContext,
                  builder: (context) => removeDialog(
                      secondContext: secondContext,
                      model: model,
                      context: context),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Widget defaultBuilder({List list, Map model, context1}) {
  return ConditionalBuilder(
    condition: list.length != 0,
    builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 6,
              child: ListView.separated(
                  itemBuilder: (context, index) => buildTaskItem(
                      model: list[index], secondContext: context1),
                  separatorBuilder: (context, index) => SizedBox(
                    height: 4,
                  ),
                  itemCount: list.length),
            ),
            // Expanded(flex: 1,
            //   child: Padding( padding: EdgeInsets.only(right: 273,bottom: 9),
            //     child: FloatingActionButton(child: Icon(Icons.delete,color: Colors.white,),backgroundColor: Colors.red,
            //       onPressed: () {
            //         AppCubit.get(context).deleteListOfDatabase(
            //           list: list,
            //         );
            //         //   AppCubit.get(context).deleteData();
            //       },
            //       // child: Text('delete all tasks',style: TextStyle(fontFamily: 'Caveat',fontSize: 22,),),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    ),
    fallback: (context) => Container(
      margin: EdgeInsets.only(right: 8, left: 8, bottom: 8, top: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: otherColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(30)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 40,
              color: Colors.grey,
            ),
            Text(
              'No Tasks Add Some Tasks',
              style: containerTitlesStyle,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget showBar({Function onPressed, String text, context}) {
  return SnackBar(
    content: Text('$text'),
    duration: Duration(seconds: 2),
    action: SnackBarAction(
      onPressed: onPressed,
      label: 'Undo',textColor: Colors.blueAccent,
    ),
  );
}

Widget formContainer({
  @required key,
  @required TextEditingController titleController,
  @required TextEditingController dateController,
  @required TextEditingController timeController,
  double raduis,
  @required context,
}) {
  return Container(
    child: Form(
      key: key,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: defaultFormField(
              radius: raduis,
              controller: titleController,
              type: TextInputType.text,
              validation: (String value) {
                if (value.isEmpty) {
                  return 'title must not be empty';
                } else {
                  return null;
                }
              },
              sumbite: (String value) {
                // print(value);
              },
              label: 'title of task',
              icon: Icons.title,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
            child: defaultFormField(
              radius: raduis,
              ontaped: () {
                showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2022, 8, 30))
                    .then((value) =>
                dateController.text = DateFormat.yMMMd().format(value));
              },
              controller: dateController,
              type: TextInputType.datetime,
              validation: (String value) {
                if (value.isEmpty) {
                  return 'date must not be empty';
                } else {
                  return null;
                }
              },
              sumbite: (String value) {
                print(value);
              },
              label: 'date of task',
              icon: Icons.calendar_today_outlined,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
            child: defaultFormField(
              radius: raduis,
              ontaped: () {
                showTimePicker(context: context, initialTime: TimeOfDay.now())
                    .then(
                        (value) => timeController.text = value.format(context));
              },
              controller: timeController,
              type: TextInputType.datetime,
              validation: (String value) {
                if (value.isEmpty) {
                  return 'time must not be empty';
                } else {
                  return null;
                }
              },
              sumbite: (String value) {
                print(value);
              },
              label: 'time of task',
              icon: Icons.watch_later,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget navBottomIcon({
  IconData icon,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        height: 1,
        width: 40,
        color: Colors.white,
      ),
      SizedBox(
        height: 10,
      ),
      Icon(
        icon,
        color: Colors.grey,
        size: 20,
      ),
    ],
  );
}

Widget activeIcon({IconData icon}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        height: 2,
        width: 40,
        color: basicColor,
      ),
      SizedBox(
        height: 10,
      ),
      Icon(
        icon,
        color: basicColor,
        size: 20,
      ),
    ],
  );
}

Widget dismissedContainer(
    {Color color, IconData icon, AlignmentGeometry alignment}) {
  return Container(
    width: double.infinity,
    height: 85,
    alignment: alignment,
    decoration: ShapeDecoration(
      color: color,
      shape: StadiumBorder(),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
    child: CircleAvatar(
      child: Icon(icon, color: color),
      backgroundColor: Colors.white,
      radius: 35,
    ),
  );
}

Widget removeDialog({Map model, secondContext, context}) {
  return AlertDialog(
    elevation: 10,
    title: Row(
      children: [
        Icon(
          Icons.warning,
          color: Colors.black54,
        ),
        SizedBox(
          width: 10,
        ),
        Text('Warning',style: TextStyle(color: Colors.black54),),
      ],
    ),
    content: const Text("Are you sure you want to remove this task?"),
    actions: <Widget>[
      FlatButton(
        child: Text(
          "Yes",
          style: TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        color: basicColor,
        onPressed: () {
          removedTitle = model['title'];
          removedDate = model['date'];
          removedTime = model['time'];
          removedStatus = model['status'];
          AppCubit.get(secondContext).deleteFromDatabase(id: model['id']);
          Scaffold.of(secondContext).showSnackBar(
            showBar(
                text: 'Item has removed!',
                onPressed: () {
                  AppCubit.get(secondContext).insertDatabase(
                    title: removedTitle,
                    date: removedDate,
                    time: removedTime,
                    status: removedStatus,
                  );
                  Navigator.push(
                      secondContext,
                      MaterialPageRoute(
                        builder: (context) => HomeLayout(),
                      ));
                }),
          );
          Navigator.of(context).pop(true);
        },
      ),
      FlatButton(
        child: Text(
          "No",
          style: TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        color: basicColor,
        onPressed: () {
          Navigator.of(context).pop(false);
        },
      ),
    ],
  );
}
