import 'dart:developer';
import 'package:chatapp/Utils/Routes/route_name.dart';
import 'package:chatapp/model/chatUser.dart';
import 'package:chatapp/res/app_string.dart';
import 'package:chatapp/res/component/chatCard.dart';
import 'package:chatapp/viewModel/checkUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class HomeScreen extends StatefulWidget {
  // final ChatUser user;
  // final ChatUser user;
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
  final List<ChatUser> searchlist = [];
  bool is_search = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckUser.selfInfo();
    CheckUser.activeStatusUpdate(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message $message');
      if (message.toString().contains('resume'))
        CheckUser.activeStatusUpdate(true);
      if (message.toString().contains('pause'))
        CheckUser.activeStatusUpdate(false);
      return Future.value(message);
    });
    // FetchByUserId(user.id)

    // Provider.of<UserProvider4>(context).setUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (is_search) {
            setState(() {
              is_search = !is_search;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.home),
            title: is_search
                ? TextField(
                    autofocus: true,
                    onChanged: (value) {
                      searchlist.clear();
                      for (var i in list) {
                        if (i.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            i.email
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                          searchlist.add(i);
                        }
                        setState(() {
                          searchlist;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: AppString.searchHint,
                    ),
                  )
                : Text(AppString.appName),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      is_search = !is_search;
                    });
                  },
                  icon: Icon(is_search ? Icons.search_off : Icons.search)),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteName.profile, arguments: {
                      "user": CheckUser.info,
                    });
                  },
                  icon: Icon(Icons.person)),
            ],
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: StreamBuilder(
                    stream: CheckUser.getAllUser(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return Center(
                            child: CircularProgressIndicator(),
                          );

                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          
                            list = data!
                              .map((e) => ChatUser.fromMap(e.data()))
                              .toList();

                          final List<ChatUser> pinuser=list.where((user) => user.is_pin).toList();
                          final List<ChatUser> unpinuser=list.where((user) => !user.is_pin).toList();
                          
                          final List<ChatUser> sortedUser=[...pinuser,...unpinuser];

                          if (list.isNotEmpty) {
                            return ListView.builder(
                                itemCount:
                                    is_search ? searchlist.length : sortedUser.length,
                                
                                shrinkWrap: true,
                                padding: EdgeInsets.only(top: 10),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onLongPress: () {
                                      CheckUser.pinChat(list[index]);
                                    },
                                    child: ChatCard(
                                      user: is_search
                                          ? searchlist[index]
                                          : sortedUser[index],
                                    ),
                                  );
                                  // return Text('${list[index]}');
                                });
                          } else {
                            return Center(
                              child: Text(AppString.noConnection),
                            );
                          }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
