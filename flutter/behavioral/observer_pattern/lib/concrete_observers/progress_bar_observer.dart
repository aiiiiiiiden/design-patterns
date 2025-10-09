import 'package:flutter/material.dart';
import '../observer/observer.dart';

/// ConcreteObserver - 프로그레스 바 Observer
/// 카운터 값을 진행 바로 표시 (최대값 기준)
class ProgressBarObserver extends StatefulWidget implements Observer {
  final int maxValue;
  final Color? color;

  const ProgressBarObserver({
    super.key,
    this.maxValue = 100,
    this.color,
  });

  @override
  State<ProgressBarObserver> createState() => ProgressBarObserverState();

  @override
  void update(int value) {
    // StatefulWidget에서는 State에서 처리
  }
}

class ProgressBarObserverState extends State<ProgressBarObserver>
    implements Observer {
  int _currentValue = 0;

  @override
  void update(int value) {
    setState(() {
      _currentValue = value;
    });
    print('ProgressBar 업데이트: $_currentValue / ${widget.maxValue}');
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentValue / widget.maxValue).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Progress',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              '${(_currentValue % (widget.maxValue + 1))} / ${widget.maxValue}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.color ?? Colors.blue,
          ),
          minHeight: 20,
        ),
      ],
    );
  }

  Observer getObserver() => this;
}
