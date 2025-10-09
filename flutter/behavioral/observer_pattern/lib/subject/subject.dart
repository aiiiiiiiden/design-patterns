import '../observer/observer.dart';

/// Subject 인터페이스
/// Observer들을 관리하고 알림을 보내는 기본 인터페이스
abstract class Subject {
  /// Observer를 등록
  void attach(Observer observer);

  /// Observer를 해제
  void detach(Observer observer);

  /// 모든 Observer들에게 알림
  void notifyObservers();
}
