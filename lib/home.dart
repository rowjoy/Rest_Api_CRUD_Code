// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_10/api/funtion.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Createddata obj = Createddata();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getdata();
    datadelet(id);
    obj.datacreated(nameController.text, emailController.text);
  }

  List data = [];
  late String id;
  Future getdata() async {
    final responce =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    if (responce.statusCode == 200) {
      setState(() {
        data = jsonDecode(responce.body);
      });
      print('Add data$data');
    } else {
      print('erro');
    }
  }

  Future datadelet(id) async {
    final responce = await http
        .delete(Uri.parse('https://jsonplaceholder.typicode.com/users/$id'));
    print(responce.statusCode);

    if (responce.statusCode == 200) {
      print('DELETE COMPLETE');
    } else {
      print('nOT dELET');
    }
  }

  Future update() async {
    final responce = await http
        .put(Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
            body: jsonEncode({
              "name": nameController.text,
              "username": emailController.text,
            }),
            headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    print(responce.statusCode);
    if (responce.statusCode == 200) {
      print('Data Update Sucassfully');
      nameController.clear();
      emailController.clear();
    } else {
      print('erro');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Number',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            obj.datacreated(
                              nameController.text,
                              emailController.text,
                            );
                          });
                        },
                        child: Text('Submit')),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            update();
                          });
                        },
                        child: Text('Update')),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: ListTile(
                            title: Text(data[index]['name']),
                            subtitle: Text(data[index]['email']),
                            trailing: Container(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        nameController.text =
                                            data[index]['name'];
                                        emailController.text =
                                            data[index]['email'];
                                      },
                                      icon: Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          datadelet(data[index]['id']);
                                        });
                                      },
                                      icon: Icon(Icons.delete))
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
