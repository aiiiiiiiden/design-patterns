import 'package:flutter/material.dart';

/// ValueNotifier를 사용한 Observer Pattern 구현
class ObserverPatternDemo2 extends StatefulWidget {
  const ObserverPatternDemo2({super.key});

  @override
  State<ObserverPatternDemo2> createState() => _ObserverPatternDemo2State();
}

class _ObserverPatternDemo2State extends State<ObserverPatternDemo2> {
  // ValueNotifier를 Subject로 사용
  final ValueNotifier<int> _counterNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _counterNotifier.dispose();
    super.dispose();
  }

  void _increment() {
    _counterNotifier.value++;
    print('카운터 증가: ${_counterNotifier.value}');
  }

  void _decrement() {
    _counterNotifier.value--;
    print('카운터 감소: ${_counterNotifier.value}');
  }

  void _reset() {
    _counterNotifier.value = 0;
    print('카운터 리셋: ${_counterNotifier.value}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 패턴 설명
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ValueNotifier Pattern',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Flutter의 ValueNotifier를 사용한 Observer 패턴 구현',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Observer들을 그리드로 배치
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _TextObserverWidget(
                        notifier: _counterNotifier,
                        label: 'Primary Counter',
                        textStyle: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _TextObserverWidget(
                        notifier: _counterNotifier,
                        label: 'Secondary Counter',
                        textStyle: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Progress Bar Observer
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _ProgressBarObserverWidget(
                  notifier: _counterNotifier,
                  maxValue: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Color Box & Icon Observer
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _ColorBoxObserverWidget(
                        notifier: _counterNotifier,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _IconObserverWidget(
                        notifier: _counterNotifier,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Chart Observer
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _ChartObserverWidget(
                  notifier: _counterNotifier,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 컨트롤 버튼들
            Card(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Controls',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _decrement,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                          ),
                          child: const Icon(Icons.remove),
                        ),
                        ElevatedButton(
                          onPressed: _reset,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                          ),
                          child: const Icon(Icons.refresh),
                        ),
                        ElevatedButton(
                          onPressed: _increment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                          ),
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Text Observer Widget
class _TextObserverWidget extends StatelessWidget {
  final ValueNotifier<int> notifier;
  final String label;
  final TextStyle? textStyle;

  const _TextObserverWidget({
    required this.notifier,
    required this.label,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        ValueListenableBuilder<int>(
          valueListenable: notifier,
          builder: (context, value, child) {
            print('$label 업데이트: $value');
            return Text(
              '$value',
              style: textStyle ??
                  const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
            );
          },
        ),
      ],
    );
  }
}

/// Progress Bar Observer Widget
class _ProgressBarObserverWidget extends StatelessWidget {
  final ValueNotifier<int> notifier;
  final int maxValue;

  const _ProgressBarObserverWidget({
    required this.notifier,
    this.maxValue = 100,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: notifier,
      builder: (context, value, child) {
        final progress = (value / maxValue).clamp(0.0, 1.0);
        print('ProgressBar 업데이트: $value / $maxValue');

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
                  '${(value % (maxValue + 1))} / $maxValue',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 20,
            ),
          ],
        );
      },
    );
  }
}

/// Color Box Observer Widget
class _ColorBoxObserverWidget extends StatelessWidget {
  final ValueNotifier<int> notifier;

  const _ColorBoxObserverWidget({
    required this.notifier,
  });

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
        ValueListenableBuilder<int>(
          valueListenable: notifier,
          builder: (context, value, child) {
            print('ColorBox 업데이트: 색상 변경 (값: $value)');
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: _getColorByValue(value),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: _getColorByValue(value).withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$value',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Icon Observer Widget
class _IconObserverWidget extends StatelessWidget {
  final ValueNotifier<int> notifier;

  const _IconObserverWidget({
    required this.notifier,
  });

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
    return icons[value.abs() % icons.length];
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
        ValueListenableBuilder<int>(
          valueListenable: notifier,
          builder: (context, value, child) {
            print('Icon 업데이트: 아이콘 변경 (값: $value)');
            return Icon(
              _getIconByValue(value),
              size: 80,
              color: _getColorByValue(value),
            );
          },
        ),
      ],
    );
  }
}

/// Chart Observer Widget
class _ChartObserverWidget extends StatefulWidget {
  final ValueNotifier<int> notifier;

  const _ChartObserverWidget({
    required this.notifier,
  });

  @override
  State<_ChartObserverWidget> createState() => _ChartObserverWidgetState();
}

class _ChartObserverWidgetState extends State<_ChartObserverWidget> {
  final List<int> _history = [0];

  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(_onValueChanged);
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_onValueChanged);
    super.dispose();
  }

  void _onValueChanged() {
    setState(() {
      _history.add(widget.notifier.value);
      if (_history.length > 20) {
        _history.removeAt(0);
      }
    });
    print('Chart 업데이트: 히스토리에 값 추가 (값: ${widget.notifier.value})');
  }

  @override
  Widget build(BuildContext context) {
    final maxValue = _history.isEmpty
        ? 1
        : _history.reduce((a, b) => a.abs() > b.abs() ? a : b).abs();
    final minValue =
        _history.isEmpty ? 0 : _history.reduce((a, b) => a < b ? a : b);
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
              final normalizedHeight =
                  range == 0 ? 50.0 : ((value - minValue) / range) * 80 + 20;

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
}
