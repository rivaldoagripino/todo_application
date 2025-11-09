import 'package:flutter_modular/flutter_modular.dart';
import 'package:todo_application/modules/todo/todo_module.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute(Modular.initialRoute, module: TodoModule()),
      ];
}
