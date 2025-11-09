import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

enum PageStatus {
  initial,
  loading,
  success,
  error
}

abstract class ModularCubitState<TWidget extends StatefulWidget,
    TBind extends Cubit> extends State<TWidget> {
  final TBind _cubit = Modular.get<TBind>();

  TBind get cubit => _cubit;

  @override
  void dispose() {
    super.dispose();
    final isDisposed = Modular.dispose<TBind>();
    if (isDisposed) {
      return;
    }

    if (_cubit is Disposable) {
      (_cubit as Disposable).dispose();
    }

    if (_cubit is Sink) {
      (_cubit as Sink).close();
    } else if (_cubit is ChangeNotifier) {
      (_cubit as ChangeNotifier).dispose();
    }
  }
}
