import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:petbook/feature/auth/pages/login_page.dart';
import 'package:petbook/profile/profile_edit.dart';
import 'package:petbook/profile/profile_menu.dart';

import '../auth/login.dart';
import 'api/loggedInUser.dart';
import 'fromRasel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key, this.main = false}) : super(key: key);

  final bool main;

  @override
  Widget build(BuildContext context) {
    print(main);
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      // backgroundColor: ThemeData.light().scaffoldBackgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            FutureBuilder(
                future: FirebaseAuth.instance.authStateChanges().first,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null) {
                    return Stack(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.height * 0.17,
                          height: MediaQuery.of(context).size.height * 0.17,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(snapshot.data?.photoURL ??
                                      'https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg?w=1380&t=st=1693564186~exp=1693564786~hmac=34badb23f9ce7734364a431e350be4ddba450762fc9d703bf10b4dc3d9f0e96b'))),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.height * 0.05,
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Icon(
                              LineAwesomeIcons.alternate_pencil,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return CircularProgressIndicator();
                }),
            const SizedBox(height: 10),
            Builder(builder: (context) {
              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser != null) {
                return getCustomFont(
                    currentUser.email.toString(), 20, Colors.brown, 1,
                    fontWeight: FontWeight.w600);
              } else
                return Container();
            }),
            Builder(builder: (context) {
              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser != null) {
                return getCustomFont(
                    currentUser.displayName.toString(), 20, Colors.brown, 1,
                    fontWeight: FontWeight.w600);
              } else
                return Container();
            }),
            const SizedBox(height: 5),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: ElevatedButton(
                onPressed: () => Get.to(() => UpdateProfileScreen()),
                style: ElevatedButton.styleFrom(
                    elevation: 5,
                    side: BorderSide.none,
                    shape: const StadiumBorder()),
                child: const Text('Edit Profile'),
              ),
            ),
            const SizedBox(height: 20),
            Divider(
              thickness: 2,
            ),
            const SizedBox(height: 10),

            /// -- MENU
            ProfileMenuWidget(
                title: "Settings",
                icon: LineAwesomeIcons.cog,
                onPress: () {
                  Get.defaultDialog(
                    title: "Notifications",
                    titleStyle: const TextStyle(fontSize: 20),
                    content: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        'Turn off notifications',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    confirm: ElevatedButton(
                      onPressed: () async {
                        // await requestPermissionAndSendNotificationSubscription(
                        //     8,
                        //     enable: false);
                      },
                      style: ElevatedButton.styleFrom(side: BorderSide.none),
                      child: const Text("Yes"),
                    ),
                    cancel: OutlinedButton(
                        onPressed: () async {
                          // Get.back();
                          // await requestPermissionAndSendNotificationSubscription(
                          //     8,
                          //     enable: true);
                        },
                        child: const Text(
                          "No",
                        )),
                  );
                }),
            ProfileMenuWidget(
                title: "My Pets",
                icon: Icons.pets,
                onPress: () {
                  // Get.to(() => const AllTicketPage());
                }),
            ProfileMenuWidget(
                title: "My Posts",
                icon: Icons.post_add,
                onPress: () {
                  //Get.to(() => const AllTicketPage());
                }),
            ProfileMenuWidget(
                title: "My Profile Info",
                icon: Icons.manage_accounts_rounded,
                onPress: () {}),
            ProfileMenuWidget(
                title: "Logout",
                icon: LineAwesomeIcons.alternate_sign_out,
                endIcon: false,
                onPress: () {
                  Get.defaultDialog(
                    title: "Log Out",
                    titleStyle: const TextStyle(fontSize: 20),
                    content: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Text(
                          "Are you sure, you want to Logout?",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                      ),
                    ),
                    confirm: ElevatedButton(
                      onPressed: () async {
                        print('YEs');
                        await FirebaseAuth.instance.signOut();
                        // SharedPreferencesHelper.clearLoginDetails();
                        Get.to(() => MyLogin(
                              themeMode: ThemeMode.light,
                            ));
                      },
                      style: ElevatedButton.styleFrom(side: BorderSide.none),
                      child: const Text("Yes"),
                    ),
                    cancel: OutlinedButton(
                        onPressed: () => Get.back(),
                        child: const Text(
                          "No",
                        )),
                  );
                }),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
          ],
        ),
      ),
      // bottomNavigationBar: main
      //     ? SizedBox()
      //     : EventNavBar(
      //         currentIndex: 3,
      //         widget: EventHomePage(
      //           id: 8,
      //         ),
      //       ),
    );
  }
}
