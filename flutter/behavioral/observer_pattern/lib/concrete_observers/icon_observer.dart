import 'package:flutter/material.dart';
import '../observer/observer.dart';

/// ConcreteObserver - 아이콘 Observer
/// 카운터 값에 따라 다른 아이콘을 표시
class IconObserver extends StatefulWidget implements Observer {
  final double size;

  const IconObserver({
    super.key,
    this.size = 60,
  });

  @override
  State<IconObserver> createState() => IconObserverState();

  @override
  void update(int value) {
    // StatefulWidget에서는 State에서 처리
  }
}

class IconObserverState extends State<IconObserver> implements Observer {
  int _currentValue = 0;

  @override
  void update(int value) {
    setState(() {
      _currentValue = value;
    });
    print('Icon 업데이트: 아이콘 변경 (값: $_currentValue)');
  }

  IconData _getIconByValue(int value) {
    final icons = [
      Icons.sentiment_very_dissatisfied,
      Icons.sentiment_dissatisfied,
      Icons.sentiment_neutral,
      Icons.sentiment_satisfied,
      Icons.sentiment_very_satisfied,
      Icons.star,
      Icons.favorite,
    ];

    final index = (value.abs() % icons.length);
    return icons[index];
  }

  Color _getColorByValue(int value) {
    if (value < 0) return Colors.red;
    if (value == 0) return Colors.grey;
    if (value < 5) return Colors.orange;
    if (value < 10) return Colors.blue;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Mood Icon',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Icon(
          _getIconByValue(_currentValue),
          size: widget.size,
          color: _getColorByValue(_currentValue),
        ),
      ],
    );
  }

  Observer getObserver() => this;
}
