import '../observer/observer.dart';
import 'subject.dart';

/// ConcreteSubject - Counter
/// 카운터 상태를 유지하고 Observer들을 관리
class CounterSubject implements Subject {
  final List<Observer> _observers = [];
  int _count = 0;

  /// 현재 카운터 값 반환
  int get count => _count;

  @override
  void attach(Observer observer) {
    _observers.add(observer);
    print('Observer 등록됨: ${observer.runtimeType}');
  }

  @override
  void detach(Observer observer) {
    _observers.remove(observer);
    print('Observer 해제됨: ${observer.runtimeType}');
  }

  @override
  void notifyObservers() {
    print('모든 Observer들에게 알림 전송 (현재 값: $_count)');
    for (var observer in _observers) {
      observer.update(_count);
    }
  }

  /// 카운터 증가
  void increment() {
    _count++;
    print('카운터 증가: $_count');
    notifyObservers();
  }

  /// 카운터 감소
  void decrement() {
    _count--;
    print('카운터 감소: $_count');
    notifyObservers();
  }

  /// 카운터 리셋
  void reset() {
    _count = 0;
    print('카운터 리셋: $_count');
    notifyObservers();
  }
}
