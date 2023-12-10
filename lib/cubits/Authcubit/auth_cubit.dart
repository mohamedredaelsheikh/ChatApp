import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> loginuser(
      {required String email, required String passward}) async {
    emit(LoginLoadingState());
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: passward);
      emit(LoginSuccesState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailureState(error: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(
            LoginFailureState(error: 'Wrong password provided for that user.'));
      }
    } catch (e) {
      emit(LoginFailureState(error: "There is an error please try again"));
    }
  }

  Future<void> registeruser(
      {required String email, required String passward}) async {
    emit(RegisterLoadingState());
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: passward);
      emit(RegisterSuccesState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterFailureState(error: 'The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailureState(
            error: 'The account already exists for that email.'));
      }
    } catch (e) {
      emit(RegisterFailureState(error: "There is an error please try again"));
    }
  }
}
