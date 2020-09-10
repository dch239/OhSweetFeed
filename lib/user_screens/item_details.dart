import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ohhsweetfeed/tools/app_data.dart';
import 'package:ohhsweetfeed/tools/photo_viewer.dart';
import 'package:ohhsweetfeed/tools/store.dart';
import 'package:ohhsweetfeed/tools/cart_counter.dart';

import 'cart.dart';

class ItemDetail extends StatefulWidget {
  final DocumentSnapshot document;
  ItemDetail({this.document});
  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  @override
  Widget build(BuildContext context) {
    var item = widget.document.data();
    List images = item[productImage] as List;
    Size screenSize = MediaQuery.of(context).size;
    List _buildlist() {
      List<Widget> list = [
        SizedBox(
          height: screenSize.height / 50,
        ),
        Card(
          child: Container(
            width: screenSize.width,
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: screenSize.height / 50,
                ),
                Text(
                  item[productName],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: screenSize.height / 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      item[productSubName],
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    Text("INR ${item[productPrice]}")
                  ],
                ),
                SizedBox(
                  height: screenSize.height / 50,
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Container(
            width: screenSize.width,
            height: 200,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GalleryPage(
                                        imageList: images,
                                        index: index,
                                      )));
                        },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: Image.network(images[index]),
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ),
        Card(
          child: Container(
            width: screenSize.width,
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: screenSize.height / 50,
                ),
                Text(
                  item[productDescription],
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ];
      List<Widget> featureList = [];
      if (item[productAvailableShapes].isNotEmpty &&
          !item[productAvailableShapes].contains('0')) {
        featureList.add(Text(
          'Shape',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ));
        featureList.add(SizedBox(
          height: screenSize.height / 10,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: item[productAvailableShapes].length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ChoiceChip(
                      labelStyle: TextStyle(color: Colors.white),
                      label: Text(item[productAvailableShapes][index]),
                      selected: false),
                );
              }),
        ));
      }
      if (item[productAvailableDecorations].isNotEmpty &&
          !item[productAvailableDecorations].contains('0')) {
        featureList.add(Text('Decorations',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)));
        featureList.add(SizedBox(
          height: screenSize.height / 10,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: item[productAvailableDecorations].length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ChoiceChip(
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      label: Text(item[productAvailableDecorations][index]),
                      selected: true),
                );
              }),
        ));
      }
      if (item[productType].toLowerCase() == 'cake') {
        featureList.add(Text('Pounds',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)));
        featureList.add(SizedBox(
          height: screenSize.height / 10,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ChoiceChip(
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      label: Text(index.toString()),
                      selected: true),
                );
              }),
        ));
      }
      featureList.add(Text('Quantity',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)));
      featureList
          .add(SizedBox(height: screenSize.height / 10, child: CartCounter()));
      featureList.add(Text('Message To Chef',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)));
      featureList.add(SizedBox(
        height: screenSize.height / 10,
        child: TextField(
            decoration: InputDecoration(
                fillColor: Colors.grey, focusColor: Colors.grey)),
      ));

      Card lcard = Card(
        child: Container(
          width: screenSize.width,
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: featureList,
          ),
        ),
      );
      list.add(lcard);
      return (list);
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              //title: Text(widget.item.name),
              background: Image.network(
                images[0],
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(_buildlist()),
          ),
        ],
      ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        elevation: 0,
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: (screenSize.width - 20) / 2,
                child: Text(
                  'ADD TO FAVORITES',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                width: (screenSize.width - 20) / 2,
                child: Text(
                  'ORDER NOW',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
