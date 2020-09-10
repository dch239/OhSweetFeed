import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:ohhsweetfeed/constants.dart';
import 'package:ohhsweetfeed/tools/app_methods.dart';
import 'package:ohhsweetfeed/tools/app_tools.dart';
import 'app_data.dart';

class FirebaseMethods implements AppMethods {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Future<String> createUserAccount(
      {String name, String phone, String email, String password}) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (userCredential != null) {
        User user = userCredential.user;
        try {
          await user.sendEmailVerification();
        } catch (e) {
          return ("An error occured while trying to send email verification");
        }
        await firestore.collection(userData).doc(user.uid).set({
          userID: user.uid,
          userIsAdmin: false,
          userFullName: name,
          userEmail: email,
          userPassword: password,
          phoneNumber: phone
        });
        writeDataLocally(key: userID, value: user.uid);
        writeBoolDataLocally(key: userIsAdmin, value: false);
        writeDataLocally(key: userFullName, value: name);
        writeDataLocally(key: userEmail, value: email);
        writeDataLocally(key: userPassword, value: password);
        writeDataLocally(key: phoneNumber, value: phone);
        writeBoolDataLocally(key: userIsLoggedIn, value: false);
      }
      return kSignUpSuccessMessage;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return ('The account already exists for that email.');
      }
    } catch (e) {
      return (e.toString());
    }
    // TODO: implement createUserAccount
    throw UnimplementedError();
  }

  @override
  Future<String> loginUser({String email, String password}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential != null) {
        User user = userCredential.user;
        DocumentSnapshot userInfo = await getUserInfo(user.uid);
        Map<String, dynamic> info = userInfo.data();
        await writeDataLocally(key: userID, value: user.uid);
        await writeBoolDataLocally(key: userIsAdmin, value: info[userIsAdmin]);
        await writeDataLocally(key: userFullName, value: info[userFullName]);
        await writeDataLocally(key: userEmail, value: info[userEmail]);
        await writeDataLocally(key: userPassword, value: info[userPassword]);
        await writeDataLocally(key: phoneNumber, value: info[phoneNumber]);
        if (user.emailVerified)
          await writeBoolDataLocally(key: userIsLoggedIn, value: true);
        else {
          await writeBoolDataLocally(key: userIsLoggedIn, value: false);
          return kEmailNotVerifiedMessage;
        }
      }
      return kSignInSuccessMessage;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return ('Wrong password provided for that user.');
      }
    }
    // TODO: implement verifyUserLogIn
    throw UnimplementedError();
  }

  Future<String> complete() async {
    return "Sign Up Successful";
  }

  @override
  Future<bool> logOutUser() async {
    // TODO: implement logOutUser
    await auth.signOut();
    await clearDataLocally();
    return done();
    throw UnimplementedError();
  }

  Future<bool> done() async {
    return true;
  }

  @override
  Future<DocumentSnapshot> getUserInfo(String userid) async {
    return await firestore.collection(userData).doc(userid).get();
    // TODO: implement getUserInfo
    throw UnimplementedError();
  }

  @override
  Future<String> addNewProduct({Map newProduct}) async {
    // TODO: implement addNewProduct
    try {
      String documentID;
      DocumentReference documentReference =
          await firestore.collection(productData).add(newProduct);
      documentID = documentReference.id;
      return documentID;
    } on PlatformException catch (e) {
      print(e.details);
      return (kUploadFailureMessage);
    }
    throw UnimplementedError();
  }

  @override
  Future<List<String>> addProductImages(
      {List<File> imageList, String docId}) async {
    List<String> imagesURL = List();
    try {
      for (int s = 0; s < imageList.length; s++) {
        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child(productData)
            .child(docId)
            .child(docId + "$s.jpg");
        StorageUploadTask uploadTask = storageReference.putFile(imageList[s]);
        var downloadURL =
            await (await uploadTask.onComplete).ref.getDownloadURL();
        imagesURL.add(downloadURL.toString());
      }
      return imagesURL;
    } on PlatformException catch (e) {
      imagesURL.add(kUploadFailureMessage);
      print(e.message);
    }
    // TODO: implement addProductImages
    //throw UnimplementedError();
  }

  @override
  Future<bool> updateServiceImages({String docId, List<String> data}) async {
    // TODO: implement updateServiceImages
    bool msg;
    await firestore
        .collection(productData)
        .doc(docId)
        .update({productImage: data}).whenComplete(() {
      msg = true;
    });
    return msg;
    throw UnimplementedError();
  }
}
