import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petbook/common/modelss/user_model.dart';
import 'package:petbook/common/routes/routes.dart';
import 'package:petbook/common/widgets/custom_icon_button.dart';
import 'package:petbook/feature/chat/pages/chat_page.dart';
import 'package:petbook/feature/contact/controller/contacts_controller.dart';
import 'package:petbook/feature/contact/widget/contact_card.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  shareSmsLink(phoneNumber) async {
    Uri sms = Uri.parse(
      "sms:$phoneNumber?body=Let's chat on WhatsApp! it's a fast, simple, and secure app we can call each other for free. Get it at https://whatsapp.com/dl/",
    );
    if (await launchUrl(sms)) {
    } else {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select contact',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 3),
            ref.watch(contactsControllerProvider).when(
              data: (allContacts) {
                return Text(
                  "${allContacts.length} contact${allContacts.length == 1 ? '' : 's'}",
                  style: const TextStyle(fontSize: 12),
                );
              },
              error: (e, t) {
                return const SizedBox();
              },
              loading: () {
                return const Text(
                  'counting...',
                  style: TextStyle(fontSize: 12),
                );
              },
            ),
          ],
        ),
        actions: [
          CustomIconButton(onPressed: () {}, icon: Icons.search),
          CustomIconButton(onPressed: () {}, icon: Icons.more_vert),
        ],
      ),
      body: ref.watch(contactsControllerProvider).when(
        data: (allContacts) {
          return ListView.builder(
            itemCount: allContacts.length,
            itemBuilder: (context, index) {
              UserModel firebaseContact = allContacts[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index == 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*myListTile(
                          leading: Icons.group,
                          text: 'New group',
                        ),
                        myListTile(
                          leading: Icons.contacts,
                          text: 'New contact',
                          trailing: Icons.qr_code,
                        ),*/
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Text(
                            'Contacts on ChatPet',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey, // Use 'Colors' instead of 'context.theme.greyColor'
                            ),
                          ),
                        ),
                      ],
                    ),
                  ContactCard(
                    onTap: () {
                      // Create an instance of ChatPage
                      ChatPage chatPage = ChatPage(user: firebaseContact); // Pass data as needed

                      // Push the ChatPage onto the navigator stack
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => chatPage),
                      );
                    },
                    contactSource: firebaseContact, // Provide the contact data to the ContactCard widget
                  ),
                ],
              );
            },
          );
        },
        error: (e, t) {
          return null;
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blue, // Use a color here
            ),
          );
        },
      ),
    );
  }

  ListTile myListTile({
    required IconData leading,
    required String text,
    IconData? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.only(top: 10, left: 20, right: 10),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.green, // Use 'Colors' instead of 'Coloors'
        child: Icon(
          leading,
          color: Colors.white,
        ),
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        trailing ?? Icons.arrow_forward, // Provide a default value
        color: Colors.grey, // Use 'Colors' instead of 'Coloors'
      ),
    );
  }
}
