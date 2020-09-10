import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ohhsweetfeed/tools/app_data.dart';
import 'package:ohhsweetfeed/tools/app_methods.dart';
import 'package:ohhsweetfeed/tools/app_tools.dart';
import 'package:ohhsweetfeed/tools/firebase_methods.dart';
import 'package:ohhsweetfeed/tools/store.dart';
import 'package:ohhsweetfeed/user_screens/about.dart';
import 'package:ohhsweetfeed/user_screens/cart.dart';
import 'package:ohhsweetfeed/user_screens/delivery.dart';
import 'package:ohhsweetfeed/user_screens/favorites.dart';
import 'package:ohhsweetfeed/user_screens/history.dart';
import 'package:ohhsweetfeed/user_screens/item_details.dart';
import 'package:ohhsweetfeed/user_screens/login.dart';
import 'package:ohhsweetfeed/user_screens/login_form.dart';
import 'package:ohhsweetfeed/user_screens/messages.dart';
import 'package:ohhsweetfeed/user_screens/notifications.dart';
import 'package:ohhsweetfeed/user_screens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool accountIsAdmin = false;
  String accountName;
  String accountEmail;
  String accountPhotoURL;
  bool accountIsLoggedIn = false;
  AppMethods appMethods = FirebaseMethods();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }

  Future<bool> accountLoggedIn() async {
    return await getBoolDataLocally(key: userIsLoggedIn);
  }

  Future<bool> accountAdmin() async {
    return await getBoolDataLocally(key: userIsAdmin);
  }

  Future getCurrentUser() async {
    accountIsLoggedIn = await accountLoggedIn();
    accountIsAdmin = await accountAdmin();
    if (accountIsLoggedIn) {
      accountName = await getStringDataLocally(key: userFullName);
      accountEmail = await getStringDataLocally(key: userEmail);
      accountPhotoURL = await getStringDataLocally(key: userPhotoURL);
    }
    print(accountName);
    print("isadmin ${accountIsAdmin.toString()}");
    accountIsAdmin = (accountIsAdmin == null || accountIsLoggedIn == false)
        ? false
        : accountIsAdmin;
    accountName = (accountName == null || accountIsLoggedIn == false)
        ? "Guest User"
        : accountName;
    accountEmail = (accountEmail == null || accountIsLoggedIn == false)
        ? "Guest Email"
        : accountEmail;
    print(accountIsLoggedIn);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("OhSweetFeed"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Favorites()));
            },
          ),
          Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.message,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Messages()));
                },
              ),
              CircleAvatar(
                radius: 8.0,
                backgroundColor: Colors.red,
                child: Text(
                  '0',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            ],
          )
        ],
      ),
      body: StreamBuilder(
          stream: firestore.collection(productData).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final int dataCount = snapshot.data.documents.length;
              if (dataCount == 0) {
                return Center(child: Text("No data"));
              } else {
                return GridView.builder(
                    itemCount: dataCount,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      final DocumentSnapshot document =
                          snapshot.data.documents[index];
                      return GridBuilder(
                          context: context, index: index, document: document);
                    });
              }
            }
          }),
      floatingActionButton: Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Cart()));
            },
            child: Icon(Icons.shopping_cart),
          ),
          CircleAvatar(
            radius: 10.0,
            backgroundColor: Colors.red,
            child: Text(
              '0',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(accountName == null ? "" : accountName),
              accountEmail: Text(accountEmail == null ? "" : accountEmail),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.people),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Notifications()));
              },
              leading: CircleAvatar(
                child: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
              ),
              title: Text('Order Notification'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => History()));
              },
              leading: CircleAvatar(
                child: Icon(
                  Icons.history,
                  color: Colors.white,
                ),
              ),
              title: Text('Order History'),
            ),
            Divider(),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
              leading: CircleAvatar(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              title: Text('Profile Settings'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Delivery()));
              },
              leading: CircleAvatar(
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              ),
              title: Text('Delivery Address'),
            ),
            Divider(),
            ListTile(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => About()));
              },
              trailing: CircleAvatar(child: Icon(Icons.help)),
              title: Text("About Us"),
            ),
            ListTile(
              trailing: CircleAvatar(child: Icon(Icons.exit_to_app)),
              title: Text((accountIsLoggedIn == true) ? "Logout" : "Login"),
              onTap: checkIfLoggedIn,
            ),
          ],
        ),
      ),
    );
  }

  checkIfLoggedIn() async {
    if (accountIsLoggedIn == false) {
      bool response = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => FormScreen()));
      if (response == true) getCurrentUser();
      return;
    }
    bool response = await appMethods.logOutUser();
    if (response == true) getCurrentUser();
  }
}

class GridBuilder extends StatelessWidget {
  final BuildContext context;
  final int index;
  final DocumentSnapshot document;
  GridBuilder({this.context, this.index, this.document});

  @override
  Widget build(BuildContext context) {
    List productImages = document.data()[productImage] as List;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemDetail(
                      document: document,
                    )));
      },
      child: Card(
        child: Column(
          //alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(productImages[0]), fit: BoxFit.cover),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.black.withAlpha(100),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '${document.data()[productName]}',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      Text(
                        'INR ${storeItems[index].price}',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
