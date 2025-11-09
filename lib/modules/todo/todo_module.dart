import 'package:flutter_modular/flutter_modular.dart';
import 'package:todo_application/modules/todo/presentation/cubits/todo_cubit.dart';
import 'package:todo_application/modules/todo/presentation/pages/todo_page.dart';

class TodoModule extends Module {
  static const moduleName = '/todo';

  @override
  List<Bind> get binds => [
        Bind(
          (i) => TodoCubit(),
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (context, args) => const TodoPage(),
        ),
      ];
}
