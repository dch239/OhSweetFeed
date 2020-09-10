import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ohhsweetfeed/constants.dart';
import 'package:ohhsweetfeed/tools/app_data.dart';
import 'package:ohhsweetfeed/tools/app_tools.dart';
import 'dart:io';
import 'package:ohhsweetfeed/tools/app_methods.dart';
import 'package:ohhsweetfeed/tools/firebase_methods.dart';

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String _type;
  String _name;
  String _subName;
  String _price;
  String _description;
  List<File> _imageList;
  //String image;
  List<String> _availableDecoration;
  List<String> _availableShapes;
  AppMethods appMethods = FirebaseMethods();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget _buildType() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Type'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Type is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _type = value;
      },
    );
  }

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildSubName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Sub Name'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'SubName is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _subName = value;
      },
    );
  }

  Widget _buildPrice() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Price'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Price is required';
        }

        return null;
      },
      onSaved: (String value) {
        _price = value;
      },
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Description'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Description is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _description = value;
      },
    );
  }

  Widget _buildAvailableDecorations() {
    return TextFormField(
      maxLines: 2,
      decoration: InputDecoration(
          labelText: 'Available Decorations',
          hintText: 'Please separate entries with comma. If none enter 0.'),
      onSaved: (String value) {
        final _delimiter = ',';
        _availableDecoration = value.split(_delimiter);
      },
    );
  }

  Widget _buildAvailableShapes() {
    return TextFormField(
      maxLines: 2,
      decoration: InputDecoration(
          labelText: 'Available Shapes',
          hintText: 'Please separate entries with comma. If none enter 0.'),
      onSaved: (String value) {
        final _delimiter = ', ';
        _availableShapes = value.split(_delimiter);
      },
    );
  }

  pickImage() async {
    ImagePicker _imagepicker = ImagePicker();
    PickedFile pickedFile =
        await _imagepicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      if (file != null) {
        List<File> imageFile = List();
        imageFile.add(file);
        if (_imageList == null) {
          _imageList = List.from(imageFile, growable: true);
        } else {
          for (int s = 0; s < imageFile.length; s++) {
            _imageList.add(file);
          }
        }
        setState(() {});
      }
    }
  }

  void removeImage(int index) async {
    _imageList.removeAt(index);
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add Item"),
        actions: <Widget>[
          RaisedButton.icon(
              onPressed: pickImage,
              icon: Icon(Icons.add_a_photo),
              label: Text("Add Image"))
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                MultiImagePickerList(
                    imageList: _imageList,
                    removeNewImage: (index) {
                      removeImage(index);
                      return;
                    }),
                _buildType(),
                _buildName(),
                _buildSubName(),
                _buildPrice(),
                _buildDescription(),
                _buildAvailableDecorations(),
                _buildAvailableShapes(),
                SizedBox(height: 40),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Upload',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }
                    _formKey.currentState.save();
                    displayProgressDialog(context);
                    Map<String, dynamic> newProduct = {
                      productType: _type,
                      productName: _name,
                      productSubName: _subName,
                      productPrice: _price,
                      productDescription: _description,
                      productAvailableDecorations: _availableDecoration,
                      productAvailableShapes: _availableShapes,
                    };

                    String productID =
                        await appMethods.addNewProduct(newProduct: newProduct);
                    List<String> imagesURL = await appMethods.addProductImages(
                        imageList: _imageList, docId: productID);

                    if (imagesURL != null &&
                        imagesURL.contains(kUploadFailureMessage)) {
                      closeProgressDialog(context);
                      showSnackBar(
                          scaffoldKey: _scaffoldKey,
                          message: kUploadFailureMessage);
                    }
                    bool result = await appMethods.updateServiceImages(
                        docId: productID, data: imagesURL);

                    if (result != null && result == true) {
                      closeProgressDialog(context);
                      _formKey.currentState.reset();
                      showSnackBar(
                          scaffoldKey: _scaffoldKey,
                          message: "Successfully added");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
