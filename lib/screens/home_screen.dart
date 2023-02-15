// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:notes_taking_app/model/notes.dart';
import 'package:notes_taking_app/screens/add_update_task.dart';
import 'package:notes_taking_app/util/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;
  late Future<List<NotesModel>> datalist;
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    datalist = dbHelper!.getDataList();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text(
          'TO DO List',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 1),
        ),
        centerTitle: true,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.help_outline_sharp,
              size: 30,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: datalist,
              builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No task found',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      int todoId = snapshot.data![index].id!.toInt();
                      String todosub = snapshot.data![index].subject.toString();
                      String todonote = snapshot.data![index].note.toString();
                      return Dismissible(
                        key: ValueKey<int>(todoId),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          child: Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (DismissDirection direction) {
                          setState(() {
                            dbHelper!.delete(todoId);
                            datalist = dbHelper!.getDataList();
                            snapshot.data!.remove(snapshot.data![index]);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.yellow.shade300,
                              // ignore: prefer_const_literals_to_create_immutables
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                )
                              ]),
                          child: Column(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.all(10),
                                title: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    todonote,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                  todonote,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(9),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddUpdateTask(
                                                        todoId: todoId,
                                                        todosub: todosub,
                                                        todonote: todonote,
                                                        update: true,
                                                      )));
                                        },
                                        child: Icon(Icons.edit_note),
                                      )
                                    ]),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddUpdateTask()));
        },
      ),
    );
  }
}
