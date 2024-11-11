import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatelessWidget {
  final Map<DateTime, Map<String, dynamic>> dateData;

  StatisticsPage({required this.dateData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('통계', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildCompletionChart('weekly', '주간 완료율'),
                  ),
                  Expanded(
                    child: _buildCompletionChart('monthly', '월간 완료율'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _buildNutrientChart(),
            ),
            SizedBox(height: 16),
            _buildGoalRecommendation(),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionChart(String period, String title) {
    List<PieChartSectionData> sections = [];
    double completed = 0, total = 0;

    dateData.forEach((date, data) {
      if (data['checklist'] != null) {
        total += (data['checklist'] as List).length;
        completed += (data['checklist'] as List).where((task) => task == '완료').length;
      }
    });

    double completionRate = total > 0 ? (completed / total) * 100 : 0;

    sections.add(PieChartSectionData(
      value: completionRate,
      color: Colors.blue,
      title: "${completionRate.toStringAsFixed(1)}%",
      radius: 50,
      titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
    ));
    sections.add(PieChartSectionData(
      value: 100 - completionRate,
      color: Colors.grey[300],
      title: "",
      radius: 50,
    ));

    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        Expanded(
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 20,
              sectionsSpace: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNutrientChart() {
    return Column(
      children: [
        Text("영양소 섭취 통계", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 150,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (context, value) => const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
                  margin: 10,
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return '단백질';
                      case 1:
                        return '탄수화물';
                      case 2:
                        return '지방';
                      default:
                        return '';
                    }
                  },
                ),
                leftTitles: SideTitles(showTitles: false),
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(y: 120, colors: [Colors.blue], width: 12),
                    BarChartRodData(y: 100, colors: [Colors.grey], width: 12),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(y: 80, colors: [Colors.blue], width: 12),
                    BarChartRodData(y: 100, colors: [Colors.grey], width: 12),
                  ],
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [
                    BarChartRodData(y: 50, colors: [Colors.blue], width: 12),
                    BarChartRodData(y: 70, colors: [Colors.grey], width: 12),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalRecommendation() {
    return FutureBuilder<String>(
      future: _fetchGoalRecommendations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("목표 추천을 가져오는 중 오류 발생", style: TextStyle(color: Colors.red, fontSize: 12));
        } else {
          return Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "AI 추천 목표",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(snapshot.data ?? "추천 목표를 로드할 수 없습니다.", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<String> _fetchGoalRecommendations() async {
    await Future.delayed(Duration(seconds: 1));
    return "운동: 5000걸음/일\n단백질: 20% 증가";
  }
}