import 'package:firestore_tutorial/models/user_profile.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final UserProfile userProfile;
  final Function onTap;
  const ChatTile({super.key, required this.userProfile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.blueGrey.withOpacity(0.01),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      onTap: (){
        onTap();
      },
      dense: false,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userProfile.pfpURL!),
      ),
      title: Text(userProfile.name!, style:  const TextStyle(fontSize: 19),),
    );
  }
}
