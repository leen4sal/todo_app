import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var edittedFormKey = GlobalKey<FormState>();
var newFormKey = GlobalKey<FormState>();
String edittedStatus;
int edittedId;
Color lightGreen =Color.fromRGBO(43, 206, 60, 100);

Color basicColor=Colors.purple.shade300;
Color otherColor=Colors.orangeAccent;

TextStyle tasksStyle=TextStyle(fontFamily:'Caveat',fontWeight: FontWeight.w500,fontSize: 26, );
TextStyle dateTasksStyle=TextStyle(fontFamily:'Caveat',fontSize: 18,color: Colors.grey );
TextStyle containerTitlesStyle=TextStyle(fontFamily:'Caveat',fontWeight: FontWeight.w600,fontSize: 22,color: Colors.grey );
TextStyle barTitlesStyle=TextStyle(fontWeight: FontWeight.bold ,fontSize: 28);

TextEditingController editedTitle = TextEditingController();
TextEditingController editedDate = TextEditingController();
TextEditingController editedTime = TextEditingController();
TextEditingController newTitle = TextEditingController();
TextEditingController newDate = TextEditingController();
TextEditingController newTime = TextEditingController();
String removedTitle;
String removedDate;
String removedTime;
String removedStatus;
String dismissedTitle;
String dismissedDate;
String dismissedTime;
String dismissedStatus;
