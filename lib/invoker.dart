class DSLMethod {
  final Function(Map<String, String> params) func;

  DSLMethod(this.func);
}

class DSLMethodInvoker {
  final _methodMap = <String, DSLMethod>{};

  void registerMethod(String name, DSLMethod method) {
    _methodMap[name] = method;
  }

  void invoke(String name, {Map<String, String> params}) {
    final method = _methodMap[name];
    method?.func(params ?? <String, String>{});
  }
}
