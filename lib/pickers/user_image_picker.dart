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
  void pickImage(bool isCamera) async {
    ImagePicker picker = ImagePicker();
    var pickedImage = await picker.getImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 250,
    );
    if (_pickedImage == null) {
      return;
    }
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
        FittedBox(
          fit: BoxFit.contain,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton.icon(
                textColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.camera_alt),
                onPressed: () => pickImage(true),
                label: Text('Take a Picture'),
              ),
              FlatButton.icon(
                textColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.image),
                onPressed: () => pickImage(false),
                label: Text('Choose from Gallery'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
