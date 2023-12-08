import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

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
}
