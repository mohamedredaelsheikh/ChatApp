// ignore_for_file: must_be_immutable

import 'package:chat_app/constant.dart';
import 'package:chat_app/cubits/chatcubit/chat_cubit.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/widgets/chat_buble.dart';
import 'package:chat_app/widgets/chat_buble_from_friend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  List<MessageModel> messagelist = [];
  static String id = 'chatpage';
  TextEditingController textcontrollor = TextEditingController();
  final scrollcontrollor = ScrollController();

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments.toString();

    void handleSubmitted(String data) {
      BlocProvider.of<ChatCubit>(context)
          .sendMessage(message: data, email: email);
      textcontrollor.clear();
      scrollcontrollor.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kloge,
              height: 50,
            ),
            const Text('Chat'),
          ],
        ),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                messagelist = BlocProvider.of<ChatCubit>(context).messagelist;

                return ListView.builder(
                  reverse: true,
                  controller: scrollcontrollor,
                  itemCount: messagelist.length,
                  itemBuilder: (context, index) {
                    return messagelist[index].id == email
                        ? ChatBuble(
                            message: messagelist[index],
                          )
                        : ChatBubleFromFriend(message: messagelist[index]);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: textcontrollor,
              onSubmitted: handleSubmitted,
              decoration: InputDecoration(
                hintText: 'Enter your message',
                suffixIcon: IconButton(
                  onPressed: () => handleSubmitted(textcontrollor.text),
                  icon: const Icon(
                    Icons.send,
                    color: kPrimaryColor,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: kPrimaryColor)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
