import 'package:flutter/material.dart';
import 'package:newproject/static.dart';

class NutritionPage extends StatefulWidget {
  @override
  _NutritionPageState createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  final List<Nutrition> _nutritions = [
    Nutrition(name: '비타민 C', dosage: '1000mg', count: 1),
    Nutrition(name: '오메가 3', dosage: '2000mg', count: 2),
    Nutrition(name: '프로바이오틱스', dosage: '10억 CFU', count: 1),
  ];

  final TextEditingController _nutritionController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _countController = TextEditingController();

  void _addNutrition() {
    if (_nutritionController.text.isNotEmpty &&
        _dosageController.text.isNotEmpty &&
        _countController.text.isNotEmpty) {
      setState(() {
        _nutritions.add(Nutrition(
          name: _nutritionController.text,
          dosage: _dosageController.text,
          count: int.parse(_countController.text),
        ));
        _nutritionController.clear();
        _dosageController.clear();
        _countController.clear();
      });
    }
  }

  void _deleteNutrition(int index) {
    setState(() {
      _nutritions.removeAt(index);
    });
  }

  void _toggleNutrition(int index) {
    setState(() {
      _nutritions[index].taken = !_nutritions[index].taken;
    });
  }

  double _calculatePercentage() {
    if (_nutritions.isEmpty) return 0.0;
    int takenCount = _nutritions.where((n) => n.taken).length;
    return takenCount / _nutritions.length * 100;
  }

  @override
  Widget build(BuildContext context) {
    double percentage = _calculatePercentage();

    return Scaffold(
      appBar: AppBar(
        title: Text('영양제', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '오늘의 영양제 섭취율: ${percentage.toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _nutritions.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _deleteNutrition(index);
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: CheckboxListTile(
                      title: Text(_nutritions[index].name),
                      subtitle: Text('${_nutritions[index].dosage} - ${_nutritions[index].count}정'),
                      value: _nutritions[index].taken,
                      onChanged: (bool? value) {
                        _toggleNutrition(index);
                      },
                      secondary: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Text(
                          _nutritions[index].name[0],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildAddNutritionDialog(),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildAddNutritionDialog() {
    return AlertDialog(
      title: Text("새 영양제 추가"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nutritionController,
            decoration: InputDecoration(
              labelText: "영양제 이름",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _dosageController,
            decoration: InputDecoration(
              labelText: "복용량",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _countController,
            decoration: InputDecoration(
              labelText: "섭취 개수",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("취소"),
        ),
        ElevatedButton(
          onPressed: () {
            _addNutrition();
            Navigator.of(context).pop();
          },
          child: Text("추가"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
      ],
    );
  }
}

class Nutrition {
  String name;
  String dosage;
  int count;
  bool taken;

  Nutrition({required this.name, required this.dosage, required this.count, this.taken = false});
}