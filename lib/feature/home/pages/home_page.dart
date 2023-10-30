import 'dart:async';

import 'package:petbook/common/widgets/custom_icon_button.dart';
import 'package:petbook/feature/auth/controller/auth_controller.dart';
import 'package:petbook/feature/home/pages/call_home_page.dart';
import 'package:petbook/feature/home/pages/chat_home_page.dart';
import 'package:petbook/feature/home/pages/status_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<Homepage> {
  late Timer timer;

  updateUserPresence() {
    ref.read(authControllerProvider).updateUserPresence();
  }

  @override
  void initState() {
    updateUserPresence();
    timer = Timer.periodic(
      const Duration(minutes: 1),
      (timer) => setState(() {}),
    );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          title: const Text(
            'PetBook',
            style: TextStyle(letterSpacing: 1),
          ),
          elevation: 1,
          actions: const [
            //CustomIconButton(onPressed: () {}, icon: Icons.search),
            //CustomIconButton(onPressed: () {}, icon: Icons.more_vert),
          ],
          bottom: TabBar(
            indicatorWeight: 1,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            splashFactory: NoSplash.splashFactory,
            tabs: [
              Tab(text: 'MESSAGES'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChatHomePage(),
            //StatusHomePage(),
            //CallHomePage(),
          ],
        ),
      ),
    );
  }
}
