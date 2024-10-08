import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_chat/res/components/round_Textfield.dart';

import 'messages_page.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  final TextEditingController searchingChatController = TextEditingController();
  List searchItems = [];
  List<DocumentSnapshot> filteredUsers = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Stream<QuerySnapshot> _userStream;

  @override
  void initState() {
    super.initState();
    _userStream = FirebaseFirestore.instance.collection('users').snapshots();
  }

  // Method to filter users based on search text
  void _filterUsers(String searchText) {
    setState(() {
      filteredUsers = [];
      if (searchText.isEmpty) {
        // filteredUsers.addAll(_snapshots.data!.docs);
      } else {
        // filteredUsers.addAll(_snapshots.data!.docs.where((user) =>
        //     user['displayName']
        //         .toString()
        //         .toLowerCase()
        //         .contains(searchText.toLowerCase())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("USERS"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundTextField(
                onPressed: () {},
                onChanged: _filterUsers,
                controller: searchingChatController,
                textbackgroundColor: Colors.transparent,
                hintText: "Search here..!",
                width: double.infinity,
              ),
              // CustomScrollView(slivers: [SliverToBoxAdapter(child: Stories())]),
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    bottomLeft: Radius.circular(32),
                  ),
                  child: _buildUserList())
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshots) {
          if (snapshots.hasError) {
            return const Text('error while building userList');
          }

          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Loading'));
          }

          // return Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: ListView.builder(
          //     itemCount: snapshots.data!.docs.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       return _buildUserListItem(snapshots.data!.docs[index]);
          //     },
          //   ),
          // );

          print('dataListLength: ${snapshots.data!.docs.length}');
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              children: snapshots.data!.docs
                  .map<Widget>((doc) => _buildUserListItem(doc))
                  .toList(),
            ),
          );
        });
  }

  Widget _buildUserListItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;
    print('buildList chat Data${data['photoURL']}');

    if (_auth.currentUser!.email != data['email']) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          bottomLeft: Radius.circular(32),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                data['photoURL'] ?? 'https://source.unsplash.com/random'),
          ),
          title: Text(data['displayName'] ?? 'Unknown'), //photoURL
          onTap: () {
            Get.to(MessagePage(
              receiverEmail: data['email'],
              uid: data['uid'] ?? '',
              receiverName: data['displayName'] ?? 'Unknown',
              photoURL: data['photoURL'] ?? '',
            ));
          },
        ),
      );
    } else {
      return Container();
    }
  }
}
