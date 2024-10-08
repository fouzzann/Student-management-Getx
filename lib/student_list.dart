import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:task_5/db_helper.dart';
import 'package:task_5/getx_list.dart';
import 'package:task_5/model.dart';
import 'package:task_5/student_add_page.dart';
import 'package:task_5/student_edit.dart';
import 'package:task_5/student_profile.dart';

class StudentList extends StatelessWidget {
  final StudentController studentController = Get.put(StudentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Students List",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() => studentController.isLoading.value
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.orange[700],
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 15),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) => studentController.runfilter(value),
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.orange, width: 2),
                            borderRadius: BorderRadius.circular(50)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        labelText: "search",
                        labelStyle: TextStyle(),
                        suffixIcon: Icon(
                          Icons.search,
                        )),
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (studentController.founders.isEmpty) {
                      return Center(
                        child: Container(
                          child: LottieBuilder.asset('assets/Animation - 1727442198566.json',fit: BoxFit.fill,
                          ),
                        
                          height: 210,
                          
                        )
                      );
                    }

                    return ListView.builder(
                      itemCount: studentController.founders.length,
                      itemBuilder: (context, index) {
                      
                        final student = StudentModel(
                          id: studentController.founders[index]['id'],
                          name: studentController.founders[index]['name'],
                          age: studentController.founders[index]['age'],
                          phone: studentController.founders[index]['phone'],
                          gender: studentController.founders[index]['gender'],
                          image: studentController.founders[index]['images'],
                        );

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => StudentProfile(
                                student: student,
                              ),
                            ));
                          },
                          child: Card(
                            color: Colors.grey[800],
                            margin: EdgeInsets.all(15),
                            child: ListTile(
                              title: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  student.name,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              leading: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: ClipOval(
                                  child: Image.file(
                                    File(student.image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                        builder: (context) => StudentEdit(
                                          student: student,
                                        ),
                                      ));
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _deleteData(
                                          student.id, student.name, context);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[600],
        onPressed: () {
          Get.to(StudentAdd());
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  // Delete function
  Future<void> _deleteData(int id, String name, context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              "Are you sure you want to Delete $name?",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            backgroundColor: Colors.grey[900],
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(
              "Delete Student",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "NO",
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () async {
                    await SQLHelper.deleteData(id);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("DATA DELETED"),
                        duration: Duration(milliseconds: 800)));
                    studentController.refreshData();
                  },
                  child: Text(
                    "YES",
                    style: TextStyle(color: Colors.orange[600]),
                  ))
            ],
          );
        });
  }
}
