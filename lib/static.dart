// lib/static.dart

import 'package:flutter/material.dart';

class StaticPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('통계'),

      ),
      body: Center(
        child: Text(
          '여기에 통계 정보를 표시합니다.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
