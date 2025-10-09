import 'package:flutter_test/flutter_test.dart';
import 'package:observer_pattern/subject/counter_subject.dart';
import 'package:observer_pattern/observer/observer.dart';

/// Mock Observer for testing
class MockObserver implements Observer {
  int updateCallCount = 0;
  int? lastReceivedValue;
  List<int> receivedValues = [];

  @override
  void update(int value) {
    updateCallCount++;
    lastReceivedValue = value;
    receivedValues.add(value);
  }

  void reset() {
    updateCallCount = 0;
    lastReceivedValue = null;
    receivedValues.clear();
  }
}

void main() {
  group('CounterSubject Tests', () {
    late CounterSubject subject;

    setUp(() {
      subject = CounterSubject();
    });

    test('초기 카운터 값은 0이어야 한다', () {
      expect(subject.count, 0);
    });

    test('increment() 호출 시 카운터가 1 증가해야 한다', () {
      subject.increment();
      expect(subject.count, 1);

      subject.increment();
      expect(subject.count, 2);
    });

    test('decrement() 호출 시 카운터가 1 감소해야 한다', () {
      subject.decrement();
      expect(subject.count, -1);

      subject.decrement();
      expect(subject.count, -2);
    });

    test('reset() 호출 시 카운터가 0으로 초기화되어야 한다', () {
      subject.increment();
      subject.increment();
      subject.increment();
      expect(subject.count, 3);

      subject.reset();
      expect(subject.count, 0);
    });

    test('여러 번 증가/감소 후 정확한 값을 유지해야 한다', () {
      subject.increment(); // 1
      subject.increment(); // 2
      subject.increment(); // 3
      subject.decrement(); // 2
      subject.increment(); // 3

      expect(subject.count, 3);
    });
  });

  group('Observer 등록/해제 Tests', () {
    late CounterSubject subject;
    late MockObserver observer1;
    late MockObserver observer2;

    setUp(() {
      subject = CounterSubject();
      observer1 = MockObserver();
      observer2 = MockObserver();
    });

    test('Observer를 등록할 수 있어야 한다', () {
      expect(() => subject.attach(observer1), returnsNormally);
      expect(() => subject.attach(observer2), returnsNormally);
    });

    test('Observer를 해제할 수 있어야 한다', () {
      subject.attach(observer1);
      expect(() => subject.detach(observer1), returnsNormally);
    });

    test('등록되지 않은 Observer 해제 시 에러가 발생하지 않아야 한다', () {
      expect(() => subject.detach(observer1), returnsNormally);
    });

    test('같은 Observer를 여러 번 등록할 수 있어야 한다', () {
      subject.attach(observer1);
      subject.attach(observer1);

      subject.increment();

      // 두 번 등록되었으므로 update가 2번 호출됨
      expect(observer1.updateCallCount, 2);
    });
  });

  group('알림(Notification) Tests', () {
    late CounterSubject subject;
    late MockObserver observer1;
    late MockObserver observer2;
    late MockObserver observer3;

    setUp(() {
      subject = CounterSubject();
      observer1 = MockObserver();
      observer2 = MockObserver();
      observer3 = MockObserver();
    });

    test('increment 시 모든 등록된 Observer에게 알림을 보내야 한다', () {
      subject.attach(observer1);
      subject.attach(observer2);
      subject.attach(observer3);

      subject.increment();

      expect(observer1.updateCallCount, 1);
      expect(observer2.updateCallCount, 1);
      expect(observer3.updateCallCount, 1);
    });

    test('decrement 시 모든 등록된 Observer에게 알림을 보내야 한다', () {
      subject.attach(observer1);
      subject.attach(observer2);

      subject.decrement();

      expect(observer1.updateCallCount, 1);
      expect(observer2.updateCallCount, 1);
    });

    test('reset 시 모든 등록된 Observer에게 알림을 보내야 한다', () {
      subject.attach(observer1);
      subject.attach(observer2);

      subject.increment();
      subject.increment();
      observer1.reset();
      observer2.reset();

      subject.reset();

      expect(observer1.updateCallCount, 1);
      expect(observer2.updateCallCount, 1);
    });

    test('Observer에게 올바른 값이 전달되어야 한다', () {
      subject.attach(observer1);

      subject.increment(); // 1
      expect(observer1.lastReceivedValue, 1);

      subject.increment(); // 2
      expect(observer1.lastReceivedValue, 2);

      subject.decrement(); // 1
      expect(observer1.lastReceivedValue, 1);

      subject.reset(); // 0
      expect(observer1.lastReceivedValue, 0);
    });

    test('해제된 Observer는 알림을 받지 않아야 한다', () {
      subject.attach(observer1);
      subject.attach(observer2);

      subject.increment();
      expect(observer1.updateCallCount, 1);
      expect(observer2.updateCallCount, 1);

      subject.detach(observer1);
      observer1.reset();
      observer2.reset();

      subject.increment();
      expect(observer1.updateCallCount, 0); // 해제되어 알림 받지 않음
      expect(observer2.updateCallCount, 1); // 계속 알림 받음
    });

    test('Observer 없이도 카운터 동작이 정상적이어야 한다', () {
      expect(() => subject.increment(), returnsNormally);
      expect(() => subject.decrement(), returnsNormally);
      expect(() => subject.reset(), returnsNormally);

      expect(subject.count, 0);
    });
  });

  group('복잡한 시나리오 Tests', () {
    late CounterSubject subject;
    late MockObserver observer1;
    late MockObserver observer2;
    late MockObserver observer3;

    setUp(() {
      subject = CounterSubject();
      observer1 = MockObserver();
      observer2 = MockObserver();
      observer3 = MockObserver();
    });

    test('여러 Observer가 서로 다른 시점에 등록/해제되어도 정상 동작해야 한다', () {
      subject.attach(observer1);
      subject.increment(); // observer1만 알림

      subject.attach(observer2);
      subject.increment(); // observer1, observer2 알림

      subject.attach(observer3);
      subject.increment(); // observer1, observer2, observer3 알림

      subject.detach(observer2);
      subject.increment(); // observer1, observer3 알림

      expect(observer1.updateCallCount, 4);
      expect(observer2.updateCallCount, 2);
      expect(observer3.updateCallCount, 2);
    });

    test('Observer가 받은 값의 히스토리가 정확해야 한다', () {
      subject.attach(observer1);

      subject.increment(); // 1
      subject.increment(); // 2
      subject.increment(); // 3
      subject.decrement(); // 2
      subject.reset(); // 0
      subject.decrement(); // -1

      expect(observer1.receivedValues, [1, 2, 3, 2, 0, -1]);
    });

    test('대량의 Observer 등록/해제가 정상적으로 동작해야 한다', () {
      final observers = List.generate(100, (index) => MockObserver());

      // 100개 Observer 등록
      for (var observer in observers) {
        subject.attach(observer);
      }

      subject.increment();

      // 모든 Observer가 알림을 받았는지 확인
      for (var observer in observers) {
        expect(observer.updateCallCount, 1);
        expect(observer.lastReceivedValue, 1);
      }

      // 50개 Observer 해제
      for (var i = 0; i < 50; i++) {
        subject.detach(observers[i]);
        observers[i].reset();
      }

      subject.increment();

      // 해제된 Observer는 알림을 받지 않음
      for (var i = 0; i < 50; i++) {
        expect(observers[i].updateCallCount, 0);
      }

      // 남은 Observer는 알림을 받음
      for (var i = 50; i < 100; i++) {
        expect(observers[i].updateCallCount, 2);
      }
    });

    test('음수 카운터 값도 정상적으로 동작해야 한다', () {
      subject.attach(observer1);

      subject.decrement(); // -1
      subject.decrement(); // -2
      subject.decrement(); // -3

      expect(observer1.receivedValues, [-1, -2, -3]);
      expect(subject.count, -3);
    });

    test('연속된 reset 호출이 정상적으로 동작해야 한다', () {
      subject.attach(observer1);

      subject.increment();
      subject.reset();
      subject.reset();
      subject.reset();

      expect(observer1.receivedValues, [1, 0, 0, 0]);
      expect(subject.count, 0);
    });
  });

  group('Observer 패턴 원칙 Tests', () {
    late CounterSubject subject;
    late MockObserver observer1;
    late MockObserver observer2;

    setUp(() {
      subject = CounterSubject();
      observer1 = MockObserver();
      observer2 = MockObserver();
    });

    test('Subject는 Observer의 구체적인 타입을 알 필요가 없다 (느슨한 결합)', () {
      // MockObserver는 Observer 인터페이스만 구현
      Observer genericObserver = observer1;
      expect(() => subject.attach(genericObserver), returnsNormally);
    });

    test('Observer는 Subject로부터 독립적으로 동작할 수 있다', () {
      // Observer는 update 메서드만 호출되면 동작
      observer1.update(42);
      expect(observer1.lastReceivedValue, 42);
      expect(observer1.updateCallCount, 1);
    });

    test('런타임에 Observer를 동적으로 추가/제거할 수 있다', () {
      subject.increment(); // 알림 없음

      subject.attach(observer1);
      subject.increment(); // observer1에 알림

      subject.attach(observer2);
      subject.increment(); // observer1, observer2에 알림

      subject.detach(observer1);
      subject.increment(); // observer2에만 알림

      expect(observer1.updateCallCount, 2);
      expect(observer2.updateCallCount, 2);
    });
  });
}
