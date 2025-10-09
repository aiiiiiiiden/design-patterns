/// Observer 인터페이스
/// Subject의 상태 변경을 감지하기 위한 기본 인터페이스
abstract class Observer {
  /// Subject의 상태가 변경되었을 때 호출되는 메서드
  void update(int value);
}
