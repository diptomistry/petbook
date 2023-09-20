import 'package:petbook/common/enum/message_type.dart';
import 'package:petbook/common/modelss/last_message_model.dart';
import 'package:petbook/common/modelss/msg_model.dart';
import 'package:petbook/feature/auth/controller/auth_controller.dart';
import 'package:petbook/feature/chat/repository/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  void sendFileMessage(
      BuildContext context,
      var file,
      String receiverId,
      MessageType messageType,
      ) {
    ref.read(userInfoAuthProvider).whenData((senderData) {
      return chatRepository.sendFileMessage(
        file: file,
        context: context,
        receiverId: receiverId,
        senderData: senderData!,
        ref: ref,
        messageType: messageType,
      );
    });
  }

  Stream<List<MessageModel>> getAllOneToOneMessage(String receiverId) {
    return chatRepository.getAllOneToOneMessage(receiverId);
  }

  Stream<List<LastMessageModel>> getAllLastMessageList() {
    return chatRepository.getAllLastMessageList();
  }

  void sendTextMessage({
    required BuildContext context,
    required String textMessage,
    required String receiverId,
  }) {
    ref.read(userInfoAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
        context: context,
        textMessage: textMessage,
        receiverId: receiverId,
        senderData: value!,
      ),
    );
  }
}
