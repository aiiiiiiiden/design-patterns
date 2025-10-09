import 'package:flutter/material.dart';
import '../observer/observer.dart';

/// ConcreteObserver - 차트 Observer
/// 카운터 값의 히스토리를 차트로 표시
class ChartObserver extends StatefulWidget implements Observer {
  final int maxHistoryLength;

  const ChartObserver({
    super.key,
    this.maxHistoryLength = 20,
  });

  @override
  State<ChartObserver> createState() => ChartObserverState();

  @override
  void update(int value) {
    // StatefulWidget에서는 State에서 처리
  }
}

class ChartObserverState extends State<ChartObserver> implements Observer {
  final List<int> _history = [0];

  @override
  void update(int value) {
    setState(() {
      _history.add(value);
      if (_history.length > widget.maxHistoryLength) {
        _history.removeAt(0);
      }
    });
    print('Chart 업데이트: 히스토리에 값 추가 (값: $value)');
  }

  @override
  Widget build(BuildContext context) {
    final maxValue =
        _history.isEmpty ? 1 : _history.reduce((a, b) => a.abs() > b.abs() ? a : b).abs();
    final minValue = _history.isEmpty ? 0 : _history.reduce((a, b) => a < b ? a : b);
    final range = (maxValue - minValue).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'History Chart',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _history.map((value) {
              final normalizedHeight = range == 0
                  ? 50.0
                  : ((value - minValue) / range) * 80 + 20;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Container(
                    height: normalizedHeight,
                    decoration: BoxDecoration(
                      color: value >= 0 ? Colors.blue : Colors.red,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Range: $minValue ~ $maxValue',
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Observer getObserver() => this;
}
