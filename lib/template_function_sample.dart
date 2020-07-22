import 'invoker.dart';

class MyTemplateFunction {
  DSLMethod testPrint = DSLMethod((params){
    print("test !! ： ${params['content']}");
  });
}