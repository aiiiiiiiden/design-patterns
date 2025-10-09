import 'package:flutter/material.dart';
import '../observer/observer.dart';

/// ConcreteObserver - 색상 박스 Observer
/// 카운터 값에 따라 색상이 변하는 박스
class ColorBoxObserver extends StatefulWidget implements Observer {
  final double size;

  const ColorBoxObserver({
    super.key,
    this.size = 100,
  });

  @override
  State<ColorBoxObserver> createState() => ColorBoxObserverState();

  @override
  void update(int value) {
    // StatefulWidget에서는 State에서 처리
  }
}

class ColorBoxObserverState extends State<ColorBoxObserver>
    implements Observer {
  int _currentValue = 0;

  @override
  void update(int value) {
    setState(() {
      _currentValue = value;
    });
    print('ColorBox 업데이트: 색상 변경 (값: $_currentValue)');
  }

  Color _getColorByValue(int value) {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ];
    return colors[value.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Color Box',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: _getColorByValue(_currentValue),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _getColorByValue(_currentValue).withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$_currentValue',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Observer getObserver() => this;
}
