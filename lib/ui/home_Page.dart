import 'package:firestore_tutorial/models/user_profile.dart';
import 'package:firestore_tutorial/services/auth_services.dart';
import 'package:firestore_tutorial/services/database_services.dart';
import 'package:firestore_tutorial/services/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/alert_services.dart';
import '../widgets/chat_tile.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt _getIt = GetIt.instance;

  late AuthServices _authServices;
  late NavigationServices _navigationServices;
  late AlertServices _alertServices;
  late DatabaseServices _databaseServices;

  @override
  void initState() {
    super.initState();
    _authServices = _getIt.get<AuthServices>();
    _navigationServices = _getIt.get<NavigationServices>();
    _alertServices = _getIt.get<AlertServices>();
    _databaseServices = _getIt.get<DatabaseServices>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _buildUI(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: const Text(
        "Messages",
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
            onPressed: () async {
              bool result = await _authServices.logOut();
              if (result) {
                _alertServices.showToast(
                    text: "Successfully logged out!", icon: Icons.done_outline);
                _navigationServices.pushReplacementNamed("/login");
              }
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ))
      ],
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
      child: _chatsList(),
    ));
  }

  Widget _chatsList() {
    return StreamBuilder(
        stream: _databaseServices.getUserProfiles(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting ||
              snapshots.connectionState == ConnectionState.none) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshots.hasError) {
            return const Expanded(
                child: Center(
              child: Text("Unable to load data"),
            ));
          } else if (snapshots.hasData && snapshots.data != null) {
            print(snapshots.data);
            final users = snapshots.data!.docs;
            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  UserProfile user = users[index].data();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: ChatTile(
                        userProfile: user,
                        onTap: () async {
                          final chatExists =
                              await _databaseServices.checkChatExists(
                                  _authServices.user!.uid, user.uid!);
                          if (!chatExists) {
                            await _databaseServices.createNewChat(
                                _authServices.user!.uid, user.uid!);
                          }
                          _navigationServices.push(MaterialPageRoute(
                              builder: (context) => ChatPage(chatUser: user)));
                        }),
                  );
                });
          }
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        });
  }
}
