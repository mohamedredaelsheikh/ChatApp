part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccesState extends RegisterState {}

class RegisterFailureState extends RegisterState {
  final String error;

  RegisterFailureState({required this.error});
}
