import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/Utils/Routes/route_name.dart';
import 'package:chatapp/Utils/utils.dart';
import 'package:chatapp/model/chatUser.dart';
import 'package:chatapp/model/messageModel.dart';
import 'package:chatapp/res/app_colors.dart';
import 'package:chatapp/res/component/messages.dart';
import 'package:chatapp/viewModel/checkUser.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessageModel> _list = [];
  TextEditingController sendController = TextEditingController();

  Future cameraPick() async {
    XFile? selectedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (selectedImage != null) {
      CheckUser.sentChatImage(widget.user, File(selectedImage.path));
      log('Image selected');
    } else {
      log('No image selected');
    }
  }

  late FocusNode messageFocusNode;

  @override
  void initState() {
    messageFocusNode = FocusNode();
    super.initState();
  }

  Future galaryMultiPicker() async {
    List<XFile> images = await ImagePicker().pickMultiImage();
    for (var i in images) {
      await CheckUser.sentChatImage(widget.user, File(i.path));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: CheckUser.getAllmessage(widget.user),
                  // CheckUser.getAllUser(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      final data = snapshot.data?.docs;
                      // log('data:${data![0].data()}');
                      _list = data!
                              .map((e) => MessageModel.fromMap(e.data()))
                              .toList() ??
                          [];

                      if (_list.isNotEmpty) {
                        return ListView.builder(
                          reverse: true,
                          itemCount: _list.length,
                          padding: const EdgeInsets.only(top: 10),
                          itemBuilder: (context, index) {
                            return Dismissible(
                                key: Key(_list[index].message),
                                onDismissed: (direction) {
                                  if (!_list[index].isdelete) {
                                    CheckUser.deleteMessage(_list[index]);
                                  } else {
                                    return null;
                                  }
                                },
                                child: MessageDesign(
                                  message: _list[index],
                                  user: widget.user,
                                  
                                ));
                          },
                        );
                      } else {
                        print(widget.user.image);
                        return Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundImage: NetworkImage(widget.user.image),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Say Hi!! 👋🏻",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ));
                      }
                    }

                    // switch (snapshot.connectionState) {
                    //   case ConnectionState.waiting:
                    //   case ConnectionState.none:
                    //     return const Center(
                    //       child: CircularProgressIndicator(),
                    //     );

                    //   case ConnectionState.active:
                    //   case ConnectionState.done:

                    // }
                  }),
            ),
            widget.user.isblock
                ? InkWell(
                    onTap: () {
                      CheckUser.unblockUser(widget.user.uid);
                      CheckUser.isunblock(widget.user);
                    },
                    child: Container(
                      height: 50,
                      child: Text('Blocked'),
                    ))
                : chatInputTextField(),
          ],
        ),
      ),
    );
  }

  Widget chatInputTextField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
              child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                Expanded(
                  child: TextField(
                    focusNode: messageFocusNode,
                    controller: sendController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: TextStyle(color: Colors.teal),
                        border: InputBorder.none),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      galaryMultiPicker();
                    },
                    icon: const Icon(
                      CupertinoIcons.photo,
                      color: Colors.teal,
                    )),
                IconButton(
                    onPressed: () {
                      cameraPick();
                    },
                    icon: const Icon(
                      CupertinoIcons.camera,
                      color: Colors.teal,
                    )),
              ],
            ),
          )),
          const SizedBox(
            width: 10,
          ),
          CupertinoButton(
            child: const Icon(Icons.send),
            onPressed: () {
              if (sendController.text.isNotEmpty) {
                CheckUser.sendMessage(
                    widget.user, sendController.text.trim(), Type.text);
                sendController.clear();
              }
            },
            color: Colors.teal,
            padding: const EdgeInsets.all(5),
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, RouteName.partner,
              arguments: {"user": widget.user});
        },
        child: StreamBuilder(
            stream: CheckUser.getLastSeenInfo(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatUser.fromMap(e.data())).toList() ?? [];

              return Row(
                children: [
                  //back button
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon:
                          const Icon(Icons.arrow_back, color: AppColors.white)),

                  //user profile picture
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * .1),
                    child: CachedNetworkImage(
                      width: MediaQuery.of(context).size.height * .05,
                      height: MediaQuery.of(context).size.height * .05,
                      imageUrl:
                          list.isNotEmpty ? list[0].image : widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),

                  //for adding some space
                  const SizedBox(width: 10),

                  //user name & last seen time
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //user name
                      Text(list.isNotEmpty ? list[0].name : widget.user.name,
                          style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.white,
                              fontWeight: FontWeight.w500)),

                      //for adding some space
                      const SizedBox(height: 2),

                      //last seen time of user
                      Text(
                          list.isNotEmpty
                              ? list[0].is_online
                                  ? 'Online'
                                  : Utils.getLastActiveTime(
                                      context: context,
                                      lastActive: list[0].last_active)
                              : Utils.getLastActiveTime(
                                  context: context,
                                  lastActive: widget.user.last_active),
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.white)),
                    ],
                  )
                ],
              );
            }));
  }
}
