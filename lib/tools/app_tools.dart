import 'package:flutter/material.dart';
import 'package:ohhsweetfeed/user_screens/progress_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

Widget AppTextField(
    {IconData textIcon,
    String textHint,
    bool isPassword,
    TextEditingController controller}) {
  return Padding(
    padding: const EdgeInsets.only(left: 18, right: 18),
    child: Container(
        decoration: BoxDecoration(
            //color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: TextFormField(
          controller: controller,
          obscureText: isPassword == null ? false : isPassword,
          decoration: InputDecoration(
            hintText: (textHint == null) ? " " : textHint,
            prefixIcon: textIcon == null ? Container() : Icon(textIcon),
          ),
        )),
  );
}

Widget appButton(
    {String btnTxt = "AppButton",
    double btnPadding = 0,
    VoidCallback onClick}) {
  return Padding(
    padding: EdgeInsets.all(btnPadding),
    child: RaisedButton(
      onPressed: onClick,
      child: Center(
        child: Text(
          btnTxt,
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}

Widget MultiImagePickerList(
    {List<File> imageList, Function removeNewImage(int position)}) {
  return new Padding(
    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
    child: imageList == null || imageList.length == 0
        ? new Container()
        : new Container(
            height: 150.0,
            child: ListView.builder(
                itemCount: imageList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Stack(
                    children: <Widget>[
                      Card(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          // width: 150.0,
                          // height: 150.0,
                          child: Image(
                            image: FileImage(imageList[index]),
                          ),
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          child: new IconButton(
                              icon: new Icon(
                                Icons.clear,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                removeNewImage(index);
                              }),
                        ),
                      )
                    ],
                  );
                }),
          ),
  );
}

showSnackBar({final scaffoldKey, String message}) {
  scaffoldKey.currentState.showSnackBar(SnackBar(
    backgroundColor: Colors.grey,
    content: Text(message),
  ));
}

displayProgressDialog(BuildContext context) {
  Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return ProgressDialog();
      }));
}

closeProgressDialog(BuildContext context) {
  Navigator.of(context).pop();
}

writeDataLocally({String value, String key}) async {
  Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();
  final SharedPreferences localData = await saveLocal;
  localData.setString(key, value);
}

writeBoolDataLocally({bool value, String key}) async {
  Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();
  final SharedPreferences localData = await saveLocal;
  localData.setBool(key, value);
}

getStringDataLocally({String key}) async {
  Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();
  final SharedPreferences localData = await saveLocal;
  return localData.getString(key);
}

getBoolDataLocally({String key}) async {
  Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();
  final SharedPreferences localData = await saveLocal;
  return localData.getBool(key) == null ? false : localData.getBool(key);
}

clearDataLocally() async {
  Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();
  final SharedPreferences localData = await saveLocal;
  return localData.clear();
}
