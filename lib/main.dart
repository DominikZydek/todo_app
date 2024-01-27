import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<TodoItem> items = [];
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
              'To Do List',
              style: TextStyle(color: Colors.grey[200]),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(items[index].task),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        items.removeAt(index);
                        // TODO: database query here !!!
                      });
                    },
                    background: Container(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.delete,
                          color: Colors.grey[200],
                        ),
                      ),
                    ),
                    child: Theme(
                      data: ThemeData(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: Card(
                        color: Colors.grey[900],
                        child: CheckboxListTile(
                          title: Text(
                            items[index].task,
                            style: TextStyle(
                              color: items[index].isCompleted
                                ? Colors.grey[600]
                                : Colors.grey[200],
                              decoration: items[index].isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                              decorationColor: items[index].isCompleted
                                ? Colors.grey[200]
                                : null
                            ),
                          ),
                          value: items[index].isCompleted,
                          onChanged: (value) {
                            setState(() {
                              items[index].isCompleted = value!;
                              // TODO: database query here !!!
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: Colors.grey[600],
                          checkColor: Colors.grey[200],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 75,
        width: 75,
        child: FloatingActionButton(
          onPressed: () {
            _showAddItemDialog(context);
          },
          backgroundColor: Colors.grey[900],
          child: Icon(
            Icons.add,
            color: Colors.grey[200],
            size: 50,
          ),
        ),
      ),
    );
  }

  Future<void> _showAddItemDialog(BuildContext context) async{
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'Add an item',
            style: TextStyle(color: Colors.grey[200]),
          ),
          content: TextField(
            controller: textController,
            style: TextStyle(color: Colors.grey[200]),
            decoration: InputDecoration(
              labelText: 'Type here...',
              labelStyle: TextStyle(color: Colors.grey[400]),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[200]),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (textController.text.isNotEmpty) {
                        items.add(TodoItem(task: textController.text, isCompleted: false));
                        textController.clear();
                        // TODO: database query here !!!
                      }
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.grey[200]),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

}

class TodoItem {
  final String task;
  bool isCompleted;

  TodoItem({required this.task, required this.isCompleted});

  @override
  String toString() {
    return '$task - $isCompleted';
  }
}
