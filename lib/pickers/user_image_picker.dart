import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;
  UserImagePicker(this.imagePickFn);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  void pickImage() async {
    ImagePicker picker = ImagePicker();
    var pickedImage = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _pickedImage = File(pickedImage.path);
    });
    widget.imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.amber,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          icon: Icon(Icons.image),
          onPressed: pickImage,
          label: Text('Take a Picture'),
        ),
      ],
    );
  }
}
