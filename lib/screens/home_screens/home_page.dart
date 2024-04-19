import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:s_chat/model/chats_models/chat_models.dart';
import 'package:s_chat/res/colors/app_colors.dart';
import 'package:s_chat/res/components/round_Textfield.dart';
import 'package:s_chat/res/widgets/avatar.dart';
import 'package:s_chat/res/widgets/helpers.dart';
import 'package:s_chat/res/widgets/icon_buttons.dart';

import '../chat_screens/contact_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchingChatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 15,
        leading: Center(
            child: Avatar(
          radius: 20,
          url: Helpers.randomPictureUrl(),
        ))
        // const Padding(
        //   padding: EdgeInsets.all(5.0),
        //   child: CircleAvatar(radius:25,backgroundImage: NetworkImage("https://source.unsplash.com/random"),),
        // )
        ,
        title: const Text('Chatting'),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_vert_outlined))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoundTextField(
              onPressed: () {},
              controller: searchingChatController,
              textbackgroundColor: Colors.transparent,
              hintText: "Search here..!",
              width: double.infinity,
            ),
            // CustomScrollView(slivers: [SliverToBoxAdapter(child: Stories())]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white12,
        elevation: 0,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const ContactPage()));
        },
        // child: const Icon(Icons.contact_page_outlined),
        child: IconBackground(icon: Icons.contact_page_outlined, onTap: () {}),
      ),
    );
  }
}

class Stories extends StatelessWidget {
  const Stories({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: EdgeInsets.all(10),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(5),
        color: Colors.transparent,
        height: 110,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Stories",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: AppColor.primaryTextColors),
            ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    final faker = Faker();
                    return _StoryCard(
                        storyData: StoryData(
                            name: faker.person.name(),
                            url: Helpers.randomPictureUrl()));
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({
    Key? key,
    required this.storyData,
  }) : super(key: key);

  final StoryData storyData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Avatar.medium(url: storyData.url),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              storyData.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 8,
                letterSpacing: 0.3,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
