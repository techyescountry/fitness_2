import 'package:bloc/bloc.dart';
import 'package:fitness_2/core/service/auth_service.dart';
import 'package:flutter/material.dart';
part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final emailController = TextEditingController();
  bool isError = false;
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordTappedEvent>((event, emit) async {
      try {
        emit(ForgotPasswordLoading());
        await AuthService.resetPassword(emailController.text);
        emit(ForgotPasswordSuccess());
      } catch (e) {
        print('Error: ' + e.toString());
        emit(ForgotPasswordError(message: e.toString()));
      }
    });
  }
}
