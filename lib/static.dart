// lib/static.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatelessWidget {
  final Map<DateTime, Map<String, dynamic>> dateData;

  StatisticsPage({required this.dateData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("주 단위 할 일 완료율"),
          SizedBox(height: 200, child: _buildCompletionChart('weekly')),

          Text("월 단위 할 일 완료율"),
          SizedBox(height: 200, child: _buildCompletionChart('monthly')),

          Text("영양소 섭취 통계"),
          SizedBox(height: 200, child: _buildNutrientChart()),

          Text("추천 목표"),
          _buildGoalRecommendation(),
        ],
      ),
    );
  }

  // 완료율 그래프 생성
  Widget _buildCompletionChart(String period) {
    List<PieChartSectionData> sections = [];
    double completed = 0, total = 0;

    dateData.forEach((date, data) {
      if (data['checklist'] != null) {
        total += (data['checklist'] as List).length;
        completed += (data['checklist'] as List).where((task) => task == '완료').length;
      }
    });

    double completionRate = total > 0 ? (completed / total) * 100 : 0;

    sections.add(PieChartSectionData(value: completionRate, color: Colors.blue, title: "$completionRate%"));
    sections.add(PieChartSectionData(value: 100 - completionRate, color: Colors.grey, title: ""));

    return PieChart(PieChartData(sections: sections));
  }

  // 영양소 섭취 그래프 생성
  Widget _buildNutrientChart() {
    return BarChart(BarChartData(
      barGroups: [
        BarChartGroupData(
          x: 1,
          barRods: [BarChartRodData(y: 120, colors: [Colors.blue])], // 예: 섭취량 120g
        ),
        BarChartGroupData(
          x: 2,
          barRods: [BarChartRodData(y: 80, colors: [Colors.red])], // 예: 목표 대비 부족한 섭취량
        ),
      ],
    ));
  }

  // 목표 추천 UI
  Widget _buildGoalRecommendation() {
    return FutureBuilder<String>(
      future: _fetchGoalRecommendations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("목표 추천을 가져오는 중 오류 발생");
        } else {
          return Text(snapshot.data ?? "추천 목표를 로드할 수 없습니다.");
        }
      },
    );
  }

  // AI 기반 목표 추천 API 호출 (예시)
  Future<String> _fetchGoalRecommendations() async {
    // AI API 호출을 통해 목표를 추천 받는 코드 작성
    return Future.value("운동 목표: 하루에 5000걸음 걷기");
  }
}