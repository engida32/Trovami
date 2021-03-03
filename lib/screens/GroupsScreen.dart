import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:trovami/helpers/RoutesHelper.dart';
import 'package:trovami/managers/GroupsManager.dart';
import 'package:trovami/managers/ThemeManager.dart';
import 'package:trovami/model/Group.dart';
import '../Strings.dart';
import 'UnitTestsScreen.dart';
import 'AddGroupScreen.dart';

class GroupsScreen extends StatefulWidget {
  String selectedGroup = "";
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<GroupsScreen> {
  _BodyState();

  GroupsManager groupsMgr;

  @override
  void initState();

  @override
  Widget build(BuildContext context) {
    groupsMgr = Provider.of<GroupsManager>(context);

    return Scaffold(
        appBar: AppBar(
          leading: Container(),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.group_add),
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddGroupScreen(),
                  ),
                );
              },
              iconSize: 42.0,
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _handleMoreMenu(),
              iconSize: 35.0,
            ),
          ],
          title: Text('Groups'),
        ),
        body: _body()
    );
  }

  _body() {
    if (groupsMgr.groups.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(Strings.noGroupsFound, style: ThemeManager().getStyle(STYLE_NORMAL_BOLD),),
        );
    } else {
        return _groupWidgets(context);
    }
  }

  Widget _groupWidgets(BuildContext context) {
    List <Widget> groupWidgets = List<Widget>();

    for (Group group in groupsMgr.groups.values) {
      groupWidgets.add(
          InkWell(
            splashColor: Colors.blue,
            onTap: () {
              _handleGroupTap(context, group);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                alignment: Alignment.center,
                child: _getGroup(group),
              ),
            ),
          ));
      groupWidgets.add(Divider(height: 2.0, color: Colors.blueGrey),
      );
    }

    if (groupWidgets.isEmpty){
      print("Trovami.GroupsScreen: No groups found");
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("No Groups Found", style: ThemeManager().getStyle(STYLE_NORMAL_BOLD),),
      );

    }

    print("Trovami.GroupsScreen: Displaying ${groupWidgets.length} groups");

    return SingleChildScrollView(
      child: Column(
        children: groupWidgets
      ),
    );
  }

  //<editor-fold desc="Private Members">
  _getGroup(Group group) {
    Widget widget;

    widget = Row (
        children: <Widget>[
          Spacer(),
          Text(group.name, style: ThemeManager().getStyle(STYLE_NORMAL),),
          Spacer(),
          Text("(${group.members.length} members)", style: ThemeManager().getStyle(STYLE_NORMAL)),
          Spacer(),
        ]
    );
    return widget;
  }

  _handleMoreMenu() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UnitTestsScreen(),
      ),
    );
  }

  void _handleGroupTap(BuildContext context, Group group) {
    groupsMgr.setCurrent(group.id);

    RoutesHelper.pushRoute(context, ROUTE_GROUP_DETAILS);
  }
}
