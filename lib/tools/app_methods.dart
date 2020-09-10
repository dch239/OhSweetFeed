import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AppMethods {
  Future<String> loginUser({String email, String password});
  Future<String> createUserAccount(
      {String name, String phone, String email, String password});
  Future<bool> logOutUser();
  Future<DocumentSnapshot> getUserInfo(String userid);
  Future<String> addNewProduct({Map newProduct});
  Future<List<String>> addProductImages({List<File> imageList, String docId});
  Future<bool> updateServiceImages({String docId, List<String> data});
}
