import 'package:flutter/material.dart';
import 'package:newproject/checklist.dart';

class ChecklistPage extends StatefulWidget {
  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final List<Task> _tasks = [
    Task(name: '운동하기'),
    Task(name: '영양제 복용'),
    Task(name: '스터디'),
    Task(name: '저녁 준비'),
  ];

  final TextEditingController _taskController = TextEditingController();

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(Task(name: _taskController.text));
        _taskController.clear();
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    int completedTasks = _tasks.where((task) => task.isCompleted).length;
    double progress = _tasks.isNotEmpty ? completedTasks / _tasks.length : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('체크리스트'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _deleteTask(index);
                  },
                  child: CheckboxListTile(
                    title: Text(_tasks[index].name),
                    value: _tasks[index].isCompleted,
                    onChanged: (bool? value) {
                      _toggleTaskCompletion(index);
                    },
                  ),
                );
              },
            ),
          ),
          LinearProgressIndicator(value: progress),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              _showAddTaskDialog();
            },
            child: Text("추가"),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("새 체크리스트 항목 추가"),
          content: TextField(
            controller: _taskController,
            decoration: InputDecoration(labelText: "할 일 입력"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addTask();
                Navigator.of(context).pop();
              },
              child: Text("추가"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("취소"),
            ),
          ],
        );
      },
    );
  }
}

class Task {
  String name;
  bool isCompleted;

  Task({required this.name, this.isCompleted = false});
}