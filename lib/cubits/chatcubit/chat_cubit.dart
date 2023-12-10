import 'package:chat_app/constant.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  List<MessageModel> messagelist = [];

  CollectionReference messages =
      FirebaseFirestore.instance.collection(kmessagescollection);
  void sendMessage({required String message, required String email}) {
    messages.add({
      kmessage: message,
      kCreateAt: DateTime.now(),
      'id': email,
    });
  }

  void getMessages() {
    messages.orderBy(kCreateAt, descending: true).snapshots().listen((event) {
      messagelist.clear();
      for (var doc in event.docs) {
        messagelist.add(MessageModel.fromJson(doc));
      }

      emit(ChatSuccessState(massageslist: messagelist));
    });
  }
}
