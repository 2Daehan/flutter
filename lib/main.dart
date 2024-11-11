import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'login.dart';
import 'checklist.dart';
import 'nutrition.dart';
import 'static.dart';
import 'goal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _selectedPageIndex = 0;

  Map<DateTime, Map<String, dynamic>> _dateData = {
    DateTime.utc(2024, 10, 1): {
      'checklist': ['운동하기', '영양제 복용'],
      'nutrition': {'칼로리': 2200, '단백질': 150},
      'goal': '5km 달리기',
    },
    DateTime.utc(2024, 10, 2): {
      'checklist': ['스트레칭', '물 2L 마시기'],
      'nutrition': {'칼로리': 1800, '단백질': 130},
      'goal': '책 30페이지 읽기',
    },
  };

  Map<String, dynamic> _currentData = {};

  @override
  void initState() {
    super.initState();
    _loadDataForSelectedDay(_focusedDay);
  }

  void _loadDataForSelectedDay(DateTime selectedDay) {
    setState(() {
      _currentData = _dateData[selectedDay] ?? {
        'checklist': ['데이터 없음'],
        'nutrition': {'칼로리': 0, '단백질': 0},
        'goal': '목표 없음',
      };
    });
  }

  void _showCalendarDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _loadDataForSelectedDay(selectedDay);
                });
                Navigator.pop(context);
              },
              calendarFormat: CalendarFormat.month,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
              ),
            ),
          ),
        );
      },
    );
  }

  void _nextWeek() {
    setState(() {
      _focusedDay = _focusedDay.add(Duration(days: 7));
    });
  }

  void _previousWeek() {
    setState(() {
      _focusedDay = _focusedDay.subtract(Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Life Style", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.green),
            onPressed: _showCalendarDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildWeekDates(),
          Expanded(
            child: IndexedStack(
              index: _selectedPageIndex,
              children: [
                ChecklistPage(),
                NutritionPage(),
                StatisticsPage(dateData: _dateData),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: '체크리스트',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.link),
            label: '영양제',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '통계',
          ),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildWeekDates() {
    DateTime startOfWeek = _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1));
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 18),
            onPressed: _previousWeek,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(7, (index) {
                  DateTime date = startOfWeek.add(Duration(days: index));
                  bool isSelected = date == _selectedDay;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDay = date;
                        _loadDataForSelectedDay(date);
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 9,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green.withOpacity(0.2) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${["월", "화", "수", "목", "금", "토", "일"][date.weekday - 1]}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.green : Colors.grey,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "${date.day}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.green : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, size: 18),
            onPressed: _nextWeek,
          ),
        ],
      ),
    );
  }
}