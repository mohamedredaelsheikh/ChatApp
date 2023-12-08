// ignore_for_file: must_be_immutable

import 'package:chat_app/constant.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/widgets/chat_buble.dart';
import 'package:chat_app/widgets/chat_buble_from_friend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  static String id = 'chatpage';
  TextEditingController controllor = TextEditingController();
  final scrollcontrollor = ScrollController();
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kmessagescollection);
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreateAt, descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If the Future is still running, show a loading indicator
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // If the Future throws an error, display it to the user
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<Message> messagelist = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagelist.add(
              Message.fromJson(
                snapshot.data!.docs[i],
              ),
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
                  child: ListView.builder(
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: controllor,
                    onSubmitted: (data) {
                      messages.add({
                        kmessage: data,
                        kCreateAt: DateTime.now(),
                        'id': email,
                      });
                      controllor.clear();
                      scrollcontrollor.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn,
                      );
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      suffixIcon: const Icon(
                        Icons.send,
                        color: kPrimaryColor,
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
        } else {
          // If the Future is complete but there is no data, display a message
          return const Center(child: Text('No messages available.'));
        }
      },
    );
  }
}
