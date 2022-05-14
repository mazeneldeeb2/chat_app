import 'package:chat_app/widgets/messages.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flutter Chat",
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButton(
                underline: const SizedBox(),
                icon: const Icon(Icons.more_vert),
                items: [
                  DropdownMenuItem(
                      value: 'logout',
                      child: Row(
                        children: const [
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text("logout"),
                        ],
                      ))
                ],
                onChanged: (_) {
                  FirebaseAuth.instance.signOut();
                }),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: const [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
