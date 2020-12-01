// autosync.dart

abstract class Service<T>{
  // ignore: unused_field, avoid_init_to_null
  Service<T> _service = null;
  static Service getService(){}
  void serve(T obj);
}