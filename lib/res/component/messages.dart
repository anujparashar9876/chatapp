import 'dart:developer';

import 'package:chatapp/Utils/utils.dart';
import 'package:chatapp/model/chatUser.dart';
import 'package:chatapp/model/messageModel.dart';
import 'package:chatapp/res/app_colors.dart';
import 'package:chatapp/res/component/chat_bottom_sheet_item.dart';
import 'package:chatapp/viewModel/checkUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';

class MessageDesign extends StatefulWidget {
  final MessageModel message;
  final ChatUser user;
  const MessageDesign({super.key, required this.message, required this.user});

  @override
  State<MessageDesign> createState() => _MessageDesignState();
}

class _MessageDesignState extends State<MessageDesign> {

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    
  }
  @override
  Widget build(BuildContext context) {
    bool ispressed = CheckUser.user.uid == widget.message.fromid;
    return InkWell(
      onLongPress: () {
        // widget.func;
        _showBottomsheet(ispressed,context);
        
      },
      child: ispressed ? _tealMessage() : _greyMessage(),
    );
  }

  Widget _tealMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10, top: 5),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              if (!widget.message.isdelete)
                widget.message.read.isNotEmpty
                    ? const Icon(
                        Icons.done_all_outlined,
                        color: AppColors.bluetick,
                        size: 15,
                      )
                    : Icon(
                        Icons.done,
                        color: AppColors.grey,
                        size: 15,
                      ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              Text(
                Utils.getFormattedTime(
                    context: context, time: widget.message.sent),
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w200),
              ),
            ],
          ),
        ),
        Flexible(
          child: Container(
              padding:
                  EdgeInsets.all(widget.message.type == Type.text ? 15 : 8),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.teal,
                border: Border.all(color: Colors.black54),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  widget.message.type == Type.text
                      ? 
                      widget.message.isdelete
                          ? Text(
                              'Message Deleted from You\'r side!!',
                              style: TextStyle(fontWeight: FontWeight.w200),
                            )
                          : 
                          Text(widget.message.message)
                      : widget.message.isdelete
                          ? Text(
                              'Message Deleted from You\'r side!!',
                              style: TextStyle(fontWeight: FontWeight.w200),
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Image.network(
                                widget.message.message,
                                fit: BoxFit.cover,
                              ),
                            ),
                ],
              )),
        ),
      ],
    );
  }

  Widget _greyMessage() {
    if (widget.message.read.isEmpty) {
      CheckUser.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.03,
        ),
        CircleAvatar(
          backgroundImage: NetworkImage(widget.user.image),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.text ? 15 : 8),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey,
              border: Border.all(color: Colors.black54),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: widget.message.type == Type.text
                ? 
                widget.message.deleteother
                    ? Text(
                        'Message Deleted from You\'r side!!',
                        style: TextStyle(fontWeight: FontWeight.w200),
                      )
                    : 
                    Text(widget.message.message)
                : 
                widget.message.deleteother
                    ? Text(
                        'Message Deleted from You\'r side!!',
                        style: TextStyle(fontWeight: FontWeight.w200),
                      )
                    : 
                    Container(
                        child: Image.network(widget.message.message),
                      ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
          child: Text(
            Utils.getFormattedTime(context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w200),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.01,
        ),
        widget.message.isstar
            ? widget.message.isdelete
                ? Icon(null)
                : IconButton(
                    icon: Icon(
                      Icons.star_outlined,
                      color: AppColors.star,
                    ),
                    onPressed: () {
                      CheckUser.unstared(widget.message);
                    },
                  )
            : Icon(null),
      ],
    );
  }

  void _showBottomsheet(bool ispressed,BuildContext context) {
    showModalBottomSheet(
        
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        builder: (_) {
          return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Wrap(children: [
                Align(
                  heightFactor: 5,
                  child: Container(
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                if (!widget.message.isdelete)
                  widget.message.type == Type.text
                      ? ChatBottomSheetItems(
                          icon: Icon(Icons.copy),
                          itemTitle: 'Copy Text',
                          onTap: () async {
                            await Clipboard.setData(
                                    ClipboardData(text: widget.message.message))
                                .then((value) {
                              
                              Utils.showSnackBar(context, 'Copied');
                              Navigator.pop(context);
                            });
                          })
                      : ChatBottomSheetItems(
                          icon: Icon(Icons.download),
                          itemTitle: 'Save Image',
                          onTap: () {
                            try {
                              GallerySaver.saveImage(widget.message.message,
                                      albumName: 'Chat App')
                                  .then((success) {
                                Navigator.pop(context);
                                if (success != null && success) {
                                  Utils.showSnackBar(context, 'Image Saved');
                                }
                              });
                            } catch (e) {
                              log(e.toString());
                            }
                          }),
                if (!widget.message.isdelete)
                  ChatBottomSheetItems(
                      icon: Icon(Icons.forward_outlined),
                      itemTitle: 'Forward message',
                      onTap: () {
                        Navigator.pop(context);
                        showForwardMessageDialog(context, widget.message);
                      }),
                if (!widget.message.isdelete && !ispressed)
                  ChatBottomSheetItems(
                      icon: Icon(
                        Icons.star_border_purple500_rounded,
                        color: Colors.amber,
                      ),
                      itemTitle: 'Star',
                      onTap: () {
                        CheckUser.stared(widget.message);
                        Navigator.pop(context);
                      }),
                if (!widget.message.isdelete)
                  Divider(
                    color: Colors.black,
                  ),
                if (widget.message.type == Type.text &&
                    ispressed &&
                    !widget.message.isdelete)
                  ChatBottomSheetItems(
                      icon: Icon(Icons.edit),
                      itemTitle: 'Edit Message',
                      onTap: () {
                        Navigator.pop(context);
                        showMessageUpdateDialog();
                      }),
                if (!widget.message.isdelete)
                  ChatBottomSheetItems(
                      icon: Icon(Icons.delete_outline_outlined),
                      itemTitle: 'Delete for me',
                      onTap: () {
                        Navigator.pop(context);
                        Utils.showAlertDialog(context, 'Delete For Me', 'Do you want to delete?', (){
                          Navigator.pop(context);
                          ispressed?
                          CheckUser.deleteForMe(widget.message):CheckUser.deleteForMeother(widget.message);
                        }, 'Yes');
                        
                        
                      }),
                if (ispressed && !widget.message.isdelete)
                  ChatBottomSheetItems(
                      icon: Icon(Icons.delete),
                      itemTitle: 'Delete Message',
                      onTap: (){
                        Navigator.pop(context);
                        Utils.showAlertDialog(context, 'Delete For Everyone', 'Do you want to delete?', 
                        () async{
                          Navigator.of(context).pop();
                          await CheckUser.deleteMessage(widget.message);
                          
                        }, 'Yes');
                        
                        
                      }),
                if (ispressed && !widget.message.isdelete)
                  Divider(
                    color: Colors.black,
                  ),
                ChatBottomSheetItems(
                    icon: Icon(Icons.send_time_extension_sharp),
                    itemTitle:
                        'Sent at: ${Utils.getFormattedTime(context: context, time: widget.message.sent)}',
                    onTap: () {}),
                if (ispressed)
                  ChatBottomSheetItems(
                      icon: Icon(Icons.remove_red_eye_outlined),
                      itemTitle: widget.message.read.isEmpty
                          ? "Read at: Not seen"
                          : 'Read at: ${Utils.getMessageTime(context: context, time: widget.message.read)}',
                      onTap: () {}),
              ]));
        });
  }

  void showMessageUpdateDialog() {
    String updateMessage = widget.message.message;
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding:
                  EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Icon(Icons.edit_note_rounded),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Edit Message'),
                ],
              ),
              content: TextFormField(
                initialValue: updateMessage,
                maxLines: null,
                onChanged: (value) => updateMessage = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      CheckUser.updateMessage(widget.message, updateMessage);
                    },
                    child: Text('Update'))
              ],
            ));
  }

  static void showForwardMessageDialog(
      BuildContext context, MessageModel message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Forward Message'),
        content: Container(
          // Set a fixed height for the content
          height: 200,
          width: double.maxFinite,
          child: FutureBuilder<List<ChatUser>>(
            future: CheckUser.getUsersExceptCurrentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final users = snapshot.data;
                return ListView.builder(
                  itemCount: users!.length,
                  itemBuilder: (context, index) {
                    print('hello');
                    final user = users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.image),
                      ),
                      title: Text(
                        user.name,
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        CheckUser.forwardMessage(user, message);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              } else {
                return const Text('No users available.');
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
