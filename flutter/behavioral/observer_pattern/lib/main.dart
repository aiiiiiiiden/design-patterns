import 'package:flutter/material.dart';
import 'subject/counter_subject.dart';
import 'concrete_observers/text_observer.dart';
import 'concrete_observers/progress_bar_observer.dart';
import 'concrete_observers/color_box_observer.dart';
import 'concrete_observers/icon_observer.dart';
import 'concrete_observers/chart_observer.dart';
import 'observer_pattern_demo2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Observer Pattern Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainTabScreen(),
    );
  }
}

class MainTabScreen extends StatelessWidget {
  const MainTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Observer Pattern Comparison'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.code),
                text: 'Custom Pattern',
              ),
              Tab(
                icon: Icon(Icons.notifications),
                text: 'ValueNotifier',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ObserverPatternDemo(),
            ObserverPatternDemo2(),
          ],
        ),
      ),
    );
  }
}

class ObserverPatternDemo extends StatefulWidget {
  const ObserverPatternDemo({super.key});

  @override
  State<ObserverPatternDemo> createState() => _ObserverPatternDemoState();
}

class _ObserverPatternDemoState extends State<ObserverPatternDemo> {
  // Subject 생성
  final CounterSubject _counterSubject = CounterSubject();

  // Observer Widget들의 GlobalKey
  final GlobalKey<TextObserverState> _textObserver1Key = GlobalKey();
  final GlobalKey<TextObserverState> _textObserver2Key = GlobalKey();
  final GlobalKey<ProgressBarObserverState> _progressBarKey = GlobalKey();
  final GlobalKey<ColorBoxObserverState> _colorBoxKey = GlobalKey();
  final GlobalKey<IconObserverState> _iconObserverKey = GlobalKey();
  final GlobalKey<ChartObserverState> _chartObserverKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Observer들이 생성된 후에 등록하기 위해 post frame callback 사용
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _registerObservers();
    });
  }

  void _registerObservers() {
    // 모든 Observer를 Subject에 등록
    _counterSubject.attach(_textObserver1Key.currentState!);
    _counterSubject.attach(_textObserver2Key.currentState!);
    _counterSubject.attach(_progressBarKey.currentState!);
    _counterSubject.attach(_colorBoxKey.currentState!);
    _counterSubject.attach(_iconObserverKey.currentState!);
    _counterSubject.attach(_chartObserverKey.currentState!);
  }

  @override
  void dispose() {
    // Observer들 해제
    if (_textObserver1Key.currentState != null) {
      _counterSubject.detach(_textObserver1Key.currentState!);
    }
    if (_textObserver2Key.currentState != null) {
      _counterSubject.detach(_textObserver2Key.currentState!);
    }
    if (_progressBarKey.currentState != null) {
      _counterSubject.detach(_progressBarKey.currentState!);
    }
    if (_colorBoxKey.currentState != null) {
      _counterSubject.detach(_colorBoxKey.currentState!);
    }
    if (_iconObserverKey.currentState != null) {
      _counterSubject.detach(_iconObserverKey.currentState!);
    }
    if (_chartObserverKey.currentState != null) {
      _counterSubject.detach(_chartObserverKey.currentState!);
    }
    super.dispose();
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
                      'Observer Pattern',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '카운터 증가/감소 시 여러 Observer들이 자동으로 업데이트됩니다.',
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
                      child: TextObserver(
                        key: _textObserver1Key,
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
                      child: TextObserver(
                        key: _textObserver2Key,
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
                child: ProgressBarObserver(
                  key: _progressBarKey,
                  maxValue: 20,
                  color: Colors.green,
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
                      child: ColorBoxObserver(
                        key: _colorBoxKey,
                        size: 120,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: IconObserver(
                        key: _iconObserverKey,
                        size: 80,
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
                child: ChartObserver(
                  key: _chartObserverKey,
                  maxHistoryLength: 20,
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
                          onPressed: () => _counterSubject.decrement(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                          ),
                          child: const Icon(Icons.remove),
                        ),
                        ElevatedButton(
                          onPressed: () => _counterSubject.reset(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                          ),
                          child: const Icon(Icons.refresh),
                        ),
                        ElevatedButton(
                          onPressed: () => _counterSubject.increment(),
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
        onPressed: () => _counterSubject.increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
