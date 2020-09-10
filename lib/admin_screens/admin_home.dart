import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ohhsweetfeed/admin_screens/add_item.dart';
import 'package:ohhsweetfeed/tools/app_methods.dart';
import 'package:ohhsweetfeed/tools/firebase_methods.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Section"),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Admin"),
              accountEmail: Text("OSFadmin@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.people),
              ),
            ),
            ListTile(
              trailing: CircleAvatar(child: Icon(Icons.exit_to_app)),
              title: Text("Logout"),
              onTap: () async {
                FirebaseMethods appMethods = FirebaseMethods();
                await appMethods.logOutUser();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
      body: GridView.count(
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          FeatureButton(
            icon: Icons.add,
            text: "Add Item",
            onClick: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddItem()));
            },
          ),
          FeatureButton(
            icon: Icons.edit,
            text: "Edit Items",
          ),
          FeatureButton(
            icon: Icons.pageview,
            text: "See Orders",
          )
        ],
      ),
    );
  }
}

class FeatureButton extends StatelessWidget {
  final IconData icon;
  final Function onClick;
  final String text;
  FeatureButton({this.icon, this.onClick, this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).bottomAppBarColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(icon: Icon(icon), onPressed: onClick),
          Text(text)
        ],
      ),
    );
  }
}
