// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_vm.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProductVM on _ProductVM, Store {
  late final _$screenStateAtom =
      Atom(name: '_ProductVM.screenState', context: context);

  @override
  VMState get screenState {
    _$screenStateAtom.reportRead();
    return super.screenState;
  }

  @override
  set screenState(VMState value) {
    _$screenStateAtom.reportWrite(value, super.screenState, () {
      super.screenState = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_ProductVM.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$_ProductVMActionController =
      ActionController(name: '_ProductVM', context: context);

  @override
  void changeState({required VMState newState}) {
    final _$actionInfo = _$_ProductVMActionController.startAction(
        name: '_ProductVM.changeState');
    try {
      return super.changeState(newState: newState);
    } finally {
      _$_ProductVMActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
screenState: ${screenState},
errorMessage: ${errorMessage}
    ''';
  }
}
