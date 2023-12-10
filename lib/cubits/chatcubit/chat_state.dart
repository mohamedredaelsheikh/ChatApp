part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

class ChatInitial extends ChatState {}

class ChatSuccessState extends ChatState {
  final List<MessageModel> massageslist;

  ChatSuccessState({required this.massageslist});
}
