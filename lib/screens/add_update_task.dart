import 'package:flutter/material.dart';
import 'package:notes_taking_app/model/notes.dart';
import 'package:notes_taking_app/screens/home_screen.dart';
import 'package:notes_taking_app/util/db_helper.dart';

class AddUpdateTask extends StatefulWidget {
  // const AddUpdateTask({super.key});
  final int? todoId;
  final String? todosub;
  final String? todonote;
  final String? todoUpdate;
  bool? update;

   AddUpdateTask(
      {Key? key,
       this.todoId,
       this.todosub,
       this.todonote,
       this.todoUpdate,
       this.update
       })
      : super(key: key);

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
  DBHelper? dbHelper;
  late Future<List<NotesModel>> datalist;
  final _fromKey = GlobalKey<FormState>();

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
    final subjectController = TextEditingController(text: widget.todosub);
    final noteController = TextEditingController(text: widget.todosub);
    String appsub;
    if (widget.update == true) {
      appsub = 'Update task';
    } else {
      appsub = 'Add task';
    }
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          appsub,
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 1),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(9.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _fromKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller: subjectController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Subject",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Some subject";
                          }
                          return null;
                        },
                      ),
                    ),
                    // ignore: prefer_const_constructors
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        maxLines: null,
                        minLines: 5,
                        keyboardType: TextInputType.multiline,
                        controller: noteController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Note",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Some Note";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 40,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      color: Colors.green[400],
                      child: InkWell(
                        onTap: () {
                          if (_fromKey.currentState!.validate()) {
                            if(widget.update==true){
                              dbHelper!.update(
                                
                              NotesModel(
                                id: widget.todoId,
                                  note: noteController.text,
                                  subject: subjectController.text),
                            );
                            }
                            else{
                              dbHelper!.insert(
                              NotesModel(
                                  note: noteController.text,
                                  subject: subjectController.text),
                            );
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                            noteController.clear();
                            subjectController.clear();
                            print('data added');
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 55,
                          width: 120,
                          decoration: const BoxDecoration(
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black12,

                              //     blurRadius: 5,
                              //     spreadRadius: 1,
                              //   )
                              // ],

                              ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.red[400],
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            subjectController.clear();
                            noteController.clear();
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 55,
                          width: 120,
                          decoration: const BoxDecoration(
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black12,

                              //     blurRadius: 5,
                              //     spreadRadius: 1,
                              //   )
                              // ],

                              ),
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
