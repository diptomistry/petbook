import 'package:cached_network_image/cached_network_image.dart';
import 'package:petbook/common/extension/custon_theme_extension.dart';
import 'package:petbook/common/modelss/user_model.dart';
import 'package:flutter/material.dart';

import '../../../common/utils/coloors.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    Key? key,
    required this.contactSource,
    required this.onTap,
  }) : super(key: key);

  final UserModel contactSource;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.only(
        left: 20,
        right: 10,
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.pink!.withOpacity(.3),
        radius: 20,
        backgroundImage: contactSource.profileImageUrl.isNotEmpty
            ? CachedNetworkImageProvider(contactSource.profileImageUrl)
            : null,
        child: contactSource.profileImageUrl.isEmpty
            ? const Icon(
          Icons.person,
          size: 30,
          color: Colors.orangeAccent,
        )
            : null,
      ),
      title: Text(
        contactSource.username,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.orangeAccent,
        ),
      ),
      subtitle: contactSource.uid.isNotEmpty
          ? Text(
        "Hey there! I'm using Chatpet",
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w600,
        ),
      )
          : null,
      trailing: contactSource.uid.isEmpty
          ? TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: Coloors.greenDark,
        ),
        child: const Text('!INVITE'),
      )
          : null,
    );
  }
}
