import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class USerPickerImage extends StatefulWidget {
  final bool loginState;
  USerPickerImage({this.pickImagefun, this.loginState});

  final void Function(
    File pickImage,
  ) pickImagefun;
  @override
  _USerPickerImageState createState() => _USerPickerImageState();
}

class _USerPickerImageState extends State<USerPickerImage> {
  File _image;
  final picker = ImagePicker();

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        _image = null;
      }
    });
    widget.pickImagefun(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Stack(
        alignment: Alignment.center,
        // fit: StackFit.expand,
        children: [
          Container(
            padding: EdgeInsets.all(30),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: _image == null
                    ? AssetImage('assets/images/user.png')
                    : FileImage(_image),
              ),
            ),
            height: widget.loginState ? 100 : 200,
            width: widget.loginState ? 100 : 200,
          ),
          if (!widget.loginState)
            Align(
              child: GestureDetector(
                child: Container(
                  child: Icon(Icons.edit_rounded),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey),
                  height: 30,
                  width: 60,
                ),
                onTap: _getImage,
              ),
              alignment: Alignment.bottomCenter,
            ),
        ],
      ),
    );
  }
}
