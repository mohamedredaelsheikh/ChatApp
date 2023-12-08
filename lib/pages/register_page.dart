import 'package:chat_app/constant.dart';
import 'package:chat_app/cubits/registercubit/register_cubit.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/widgets/custombuttom.dart';
import 'package:chat_app/widgets/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  static String id = 'RegisterPage';

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> formkey = GlobalKey();

  String? passward;

  String? email;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoadingState) {
          isLoading = true;
        } else if (state is RegisterSuccesState) {
          isLoading = false;
          Navigator.pushNamed(context, ChatPage.id);
        } else if (state is RegisterFailureState) {
          isLoading = false;
          showSnackBar(context, state.error);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            backgroundColor: kPrimaryColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Form(
                key: formkey,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 75,
                    ),
                    Image.asset(
                      'assets/images/scholar.png',
                      height: 100,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Scholor Chat',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'pacifico',
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 75,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomFormTextField(
                      onchange: (data) {
                        email = data;
                      },
                      hinttext: 'Email',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomFormTextField(
                      obscure: true,
                      onchange: (data) {
                        passward = data;
                      },
                      hinttext: 'Passward',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButtom(
                      onTap: () async {
                        if (formkey.currentState!.validate()) {
                          BlocProvider.of<RegisterCubit>(context)
                              .registeruser(email: email!, passward: passward!);
                        } else {}
                      },
                      buttomname: 'Register',
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            '   Login',
                            style: TextStyle(
                              color: Color(0xffC7EDE6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
