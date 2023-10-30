import 'package:cached_network_image/cached_network_image.dart';
import 'package:petbook/common/extension/custon_theme_extension.dart';
import 'package:petbook/common/modelss/last_message_model.dart';
import 'package:petbook/common/modelss/user_model.dart';
import 'package:petbook/common/routes/routes.dart';
import 'package:petbook/common/utils/coloors.dart';
import 'package:petbook/feature/chat/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:petbook/feature/contact/pages/contact_page.dart';

import '../../chat/pages/chat_page.dart';

class ChatHomePage extends ConsumerWidget {
  const ChatHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: StreamBuilder<List<LastMessageModel>>(
        stream: ref.watch(chatControllerProvider).getAllLastMessageList(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Coloors.greenDark,
              ),
            );
          }
          final sortedData = snapshot.data!
            ..sort((a, b) => b.timeSent.compareTo(a.timeSent));
          return ListView.builder(
            itemCount: sortedData.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final lastMessageData = snapshot.data![index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(
                                user: UserModel(
                                  username: lastMessageData.username,
                                  uid: lastMessageData.contactId,
                                  profileImageUrl:
                                      lastMessageData.profileImageUrl,
                                  active: true,
                                  lastSeen: 0,
                                  phoneNumber: '0',
                                  groupId: [],
                                ),
                              )));
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lastMessageData.username,
                      style: TextStyle(fontSize: 13, color: Colors.black
                          //color: context.theme.greyColor,
                          ),
                    ),
                    Text(
                      DateFormat.Hm().format(lastMessageData.timeSent),
                      style: TextStyle(fontSize: 13, color: Colors.black
                          //color: context.theme.greyColor,
                          ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    lastMessageData.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    //style: TextStyle(color: context.theme.greyColor),
                  ),
                ),
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    lastMessageData.profileImageUrl,
                  ),
                  radius: 24,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  ContactPage(), // Replace with the actual ContactPage widget.
            ),
          );
        },
        child: Icon(Icons.chat),
      ),
    );
  }
}
