import 'package:flutter/material.dart';
import '../observer/observer.dart';

/// ConcreteObserver - 텍스트 표시 Observer
/// 카운터 값을 텍스트로 표시
class TextObserver extends StatefulWidget implements Observer {
  final String label;
  final TextStyle? textStyle;

  const TextObserver({
    super.key,
    required this.label,
    this.textStyle,
  });

  @override
  State<TextObserver> createState() => TextObserverState();

  @override
  void update(int value) {
    // StatefulWidget에서는 State에서 처리
  }
}

class TextObserverState extends State<TextObserver> implements Observer {
  int _currentValue = 0;

  @override
  void update(int value) {
    setState(() {
      _currentValue = value;
    });
    print('${widget.label} 업데이트: $_currentValue');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '$_currentValue',
          style: widget.textStyle ??
              const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  // State 인스턴스를 반환하는 헬퍼 메서드
  Observer getObserver() => this;
}
